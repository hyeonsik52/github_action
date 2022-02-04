//
//  ReceivedServicesViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/05/29.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class ReceivedServicesViewController: BaseViewController, View {
    
    enum Text {
        static let title = "서비스 목록"
    }
    
    weak var delegate: ServiceCellDelegate?
    
    private let settingButton = UIButton().then {
        let image = UIImage(named: "history")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
    }
    private lazy var titleView = WorkspaceTitleView(
        title: Text.title,
        button: self.settingButton,
        buttonWidth: 52
    )
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        let width = UIScreen.main.bounds.width - 16 * 2
        $0.minimumLineSpacing = 12
        $0.estimatedItemSize = .init(width: width, height: 100)
        $0.sectionInset = .init(top: 8, left: 16, bottom: 24, right: 16)
    }
    private lazy var collectionView = UICollectionView.init(
        frame: .zero,
        collectionViewLayout: self.flowLayout
    ).then {
        $0.alwaysBounceVertical = true
        $0.contentInset.top = 16
        $0.verticalScrollIndicatorInsets.top = 16
        
        $0.backgroundColor = .white
        
        $0.register(ServiceCell.self, forCellWithReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ServiceModelSection>(
        configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath) as! ServiceCell
            cell.reactor = reactor
            
            return cell
        }
    )
    
    private let placeholderLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .regular[16]
        $0.textColor = .darkGray303030
        $0.textAlignment = .center
        $0.text = "현재 진행 중인 서비스가 없습니다.\n서비스를 요청해보세요!"
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints{
            $0.top.equalTo(self.titleView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: PagingReceivedServicesViewReactor) {
        
        //State
        reactor.state.map(\.services)
            .map { [.init(header: "", items: $0.map(reactor.reactorForServiceCell))] }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.services)
            .map { !$0.isEmpty }
            .bind(to: self.placeholderLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading ?? false }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] isLoading in
                if self?.collectionView.refreshControl?.isRefreshing == true {
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.refreshControl?.endRefreshing()
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.retryMoreFind }
            .distinctUntilChanged()
            .map { [weak self] _ in
                let lastSection = (self?.dataSource.sectionModels.count ?? 1) - 1
                let lastIndex = self?.dataSource.sectionModels.last?.items.count ?? 0
                return .init(item: lastIndex, section: lastSection)
            }
            .map { Reactor.Action.moreFind($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //Action
        //temp: 서버 느려짐 현상으로 임시 비활성
//        self.rx.viewDidLoad
//            .map { Reactor.Action.refresh(nil) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
        
        //temp: 서버 느려짐 현상으로 임시 비활성
        self.rx.viewWillAppear
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(ServiceCellReactor.self)
            .map { reactor.reactorForServiceDetail(serviceId: $0.currentState.service.id) }
            .subscribe(onNext: { [weak self] reactor in
                self?.navigationPush(
                    type: ServiceDetailViewController.self,
                    reactor: reactor,
                    animated: true,
                    bottomBarHidden: true
                )
            }).disposed(by: self.disposeBag)
        
        self.collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension ReceivedServicesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSection = self.dataSource.sectionModels.count - 1
        let lastIndex = (self.dataSource.sectionModels.last?.items.count ?? 1) - 1
        if indexPath.section > lastSection {
            self.reactor?.action.onNext(.moreFind(indexPath))
        } else if indexPath.section == lastSection, indexPath.item >= lastIndex {
            self.reactor?.action.onNext(.moreFind(indexPath))
        }
    }
}

