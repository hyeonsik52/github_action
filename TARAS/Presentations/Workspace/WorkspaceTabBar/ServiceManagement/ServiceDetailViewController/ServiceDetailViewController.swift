//
//  ServiceDetailViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import PanModal

class ServiceDetailViewController: BaseViewController, View {
    
    private let backButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(UIImage(named: "navi-back"), for: .normal)
    }
    
    private let moreButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(UIImage(named: "service-more"), for: .normal)
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.scrollDirection = .vertical
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        $0.minimumLineSpacing = 14
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        
        $0.backgroundColor = .clear
        
        $0.register(ServiceUnitManagementHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        $0.register(ServiceUnitManagementCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<ServiceUnitSection>!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .LIGHT_GRAY_F6F6F6
        
        let navigationBar = UIView()
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        navigationBar.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(36)
        }
        
        navigationBar.addSubview(self.moreButton)
        self.moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(36)
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: ServiceDetailViewReactor) {
        
        //Action
        let viewDidLoad = self.rx.viewDidLoad.single()
        
        viewDidLoad.map { Reactor.Action.judgeIsFromPush }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        viewDidLoad
            .map { Reactor.Action.loadService(refresh: false) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.back()
            })
            .disposed(by: self.disposeBag)
        
        self.moreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let serviceModel = reactor.currentState.serviceModel
                let status = serviceModel?.status ?? .__unknown("unknown")
                //3가지 타입으로 나뉘어짐
                
                let actionController = UIAlertController(title: "더보기", message: nil, preferredStyle: .actionSheet)

                actionController.addAction(
                    UIAlertAction(title: "서비스 기본 정보", style: .default) { [weak self] action in
                        
                        let viewController = ServiceBasicInfoViewController()
                        viewController.reactor = reactor.reactorForBasicInfo()
                        
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                )
                actionController.addAction(
                    UIAlertAction(title: "작업 로그", style: .default) { action in
                        
                        let viewController = ServiceDetailLogViewController()
                        viewController.reactor = reactor.reactorForDetailLog()
                        
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                )
                switch status {
                case .waitingResponse: fallthrough
                case .waitingRobotAssignment: fallthrough
                case .moving:
                    if reactor.mode != .preview,
                        serviceModel?.creator.isMe == true {
                        //서비스 상태가 이동중이면서, 첫번째 목적지의 상태가 작업 차례 대기라면, 출발지로 이동중 상태이다
                        //서비스가 이동중 상태일 때, 위의 조건과 맞지 않으면 무시한다
                        let firstServiceUnitStatus = reactor.currentState.serviceModel?.serviceUnitList.first?.status
                        if status == .moving,
                            firstServiceUnitStatus != .moving {
                            break
                        }
                        actionController.addAction(
                            UIAlertAction(title: "서비스 요청 취소", style: .default) { [weak self] action in
                                let actionController = UIAlertController(title: "서비스를 취소하시겠습니까?", message: nil, preferredStyle: .alert)
                                actionController.addAction(
                                    UIAlertAction(title: "예", style: .destructive) { action in
                                        reactor.action.onNext(.cancelRequest)
                                    }
                                )
                                actionController.addAction(UIAlertAction(title: "아니오", style: .cancel))
                                self?.navigationController?.present(actionController, animated: true)
                            }
                        )
                    }
                case .canceledOnWaiting: fallthrough
                case .completed: fallthrough
                case .canceledOnReady: fallthrough
                case .error: fallthrough
                case .canceledOnWorking:
                    if reactor.mode != .preview,
                        serviceModel?.creator.isMe == true {
                        actionController.addAction(
                            UIAlertAction(title: "서비스 삭제", style: .default) { action in
                                let actionController = UIAlertController(title: "서비스를 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
                                actionController.addAction(
                                    UIAlertAction(title: "삭제", style: .destructive) { action in
                                        reactor.action.onNext(.deleteService)
                                    }
                                )
                                actionController.addAction(UIAlertAction(title: "취소", style: .cancel))
                                self?.navigationController?.present(actionController, animated: true)
                            }
                        )
                    }
                default:
                    break
                }
                //2단계
//                actionController.addAction(
//                    UIAlertAction(title: "댓글", style: .default) { action in
//
//                    }
//                )
                actionController.addAction(UIAlertAction(title: "취소", style: .cancel))
                
                self?.navigationController?.present(actionController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.dataSource = .init(configureCell: { dataSource, collectionView, indexPath, cellRactor -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ServiceUnitManagementCollectionViewCell
            cell.reactor = cellRactor
            
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, string, indexPath -> UICollectionReusableView in
            
            let service = dataSource[indexPath.section].header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! ServiceUnitManagementHeader
            header.bind(mode: reactor.mode, service: service)
            
            return header
        })
        
        self.collectionView.rx.modelSelected(ServiceUnitCellReactor.self)
            .subscribe(onNext: { [weak self] cellReactor in
                if cellReactor.currentState.mode != .preview {
                    let viewController = WorkRequestViewController()
                    let serviceUnitIdx = cellReactor.currentState.serviceSet.serviceUnit.serviceUnitIdx
                    viewController.reactor = reactor.reactorForWorkRequest(with: serviceUnitIdx)
                    let navigationController = PanModalNavigationController(rootViewController: viewController)
                    
                    self?.presentPanModal(navigationController)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.loadService(refresh: true) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap { $0.serviceModel }
            .map { service in
                [ServiceUnitSection(
                header: service,
                items: service.serviceUnitList.enumerated()
                    .map { ServiceUnitCellReactor(mode: reactor.mode, serviceSet: .init(service: service, serviceUnit: $1, offset: $0+1)) }
                )]}
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.requestCanceled }
            .distinctUntilChanged()
            .subscribe(onNext: { successed in
                reactor.action.onNext(.loadService(refresh: true))
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.serviceDeleted }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] successed in
                if successed {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.collectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isFromPush }
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                switch reactor.pushInfo?.notificationType {
                case .robotArrived:
                    if let serviceUnitIdx = reactor.pushInfo?.serviceUnitIdx
                    {
                        let viewController = WorkRequestViewController()
                        viewController.reactor = reactor.reactorForWorkRequest(with: serviceUnitIdx)
                        let navigationController = PanModalNavigationController(
                            rootViewController: viewController
                        )
                        self?.presentPanModal(navigationController)
                    }
   
                default: return
                }
            }).disposed(by: self.disposeBag)
    }
}


// MARK: - UIGestureRecognizerDelegate

extension ServiceDetailViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}
