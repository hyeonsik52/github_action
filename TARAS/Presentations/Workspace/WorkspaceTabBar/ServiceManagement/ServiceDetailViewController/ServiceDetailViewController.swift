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

class ServiceDetailViewController: BaseNavigationViewController, View {

    enum Text {
        static let authCodeTitle = "인증번호"
        static let detailTitle = "요청사항"
        static let completedTimeTitle = "완료일시"
        static let workCompletion = "작업 완료"
    }
    
    enum Metric {
        static let cellHeight: CGFloat = 64
    }
    
    enum MoreMenu: Describable {
        case serviceInfo
        case serviceLog
        case cancelService
        case addShortcut
        
        var description: String {
            switch self {
            case .serviceInfo:
                return "서비스 정보 보기"
            case .serviceLog:
                return "서비스 로그 보기"
            case .cancelService:
                return "서비스 중단하기"
            case .addShortcut:
                return "간편 생성 등록하기"
            }
        }
    }
    
    override var navigationPopGestureEnabled: Bool {
        return false
    }
    
    private let moreButton = UIBarButtonItem(
        image: UIImage(named: "service-more")?.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let headerContainer = UIView().then {
        $0.backgroundColor = .grayF6F6F6
        $0.isHidden = true
    }
    
    private let headerContentView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private var authNumberContainer: UIView!
    private let authNumberLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .black0F0F0F
        $0.textAlignment = .right
    }
    
    private var detailContainer: UIView!
    private let detailLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .black0F0F0F
        $0.numberOfLines = 0
    }
    
    private var completedTimeContainer: UIView!
    private let completedTimeLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .black0F0F0F
        $0.textAlignment = .right
    }
    
    private var errorContainer: UIView!
    private let errorLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .redEB4D39
    }
    
    private let workCompletionButtonContainer = UIView().then {
        $0.isHidden = true
    }
    private let workCompletionButton = SRPButton(Text.workCompletion)
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        
        $0.register(ServiceDetailServiceUnitCell.self)
        $0.rowHeight = Metric.cellHeight
        $0.separatorStyle = .none
        
        let leastHeight = CGFloat.leastNonzeroMagnitude
        $0.sectionHeaderHeight = leastHeight
        $0.sectionFooterHeight = leastHeight
        $0.tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: leastHeight))
        $0.tableFooterView = .init(frame: .init(x: 0, y: 0, width: 0, height: leastHeight))
        
        $0.addSubview(self.refreshControl)
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ServiceDetailServiceUnitSection>(
        configureCell: { dataSource, tableView, indexPath, reactor -> UITableViewCell in
            let cell = tableView.dequeueCell(ofType: ServiceDetailServiceUnitCell.self, indexPath: indexPath)
            reactor.isLastCell = (indexPath.row >= dataSource.sectionModels[indexPath.section].items.count-1)
            cell.reactor = reactor
            cell.layer.zPosition = CGFloat(indexPath.row)
            return cell
        }
    )
    
    // MARK: - Life Cycles
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationItem.setRightBarButton(self.moreButton, animated: true)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let header = UIStackView().then {
            $0.axis = .vertical
        }
        self.view.addSubview(header)
        header.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        header.addArrangedSubview(self.headerContainer)
        
        self.headerContainer.addSubview(self.headerContentView)
        self.headerContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        func addContainer(
            title: String?,
            label: UILabel,
            isLabelBottom: Bool = false
        ) -> UIView {
            
            let container = UIView()
            self.headerContentView.addArrangedSubview(container)
            
            let titleLabel = UILabel().then {
                $0.font = .regular[14]
                $0.textColor = .gray999999
                $0.text = title
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            container.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                if !isLabelBottom {
                    $0.bottom.equalToSuperview()
                }
                $0.top.leading.equalToSuperview()
                $0.height.equalTo(48)
            }
            
            container.addSubview(label)
            if isLabelBottom {
                label.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom)
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-4)
                }
            } else {
                label.snp.makeConstraints {
                    $0.centerY.equalTo(titleLabel)
                    $0.leading.equalTo(titleLabel.snp.trailing)
                    $0.trailing.equalToSuperview()
                }
            }
            
            container.isHidden = true
            
            return container
        }
        
        self.authNumberContainer = addContainer(title: Text.authCodeTitle, label: self.authNumberLabel)
        self.detailContainer = addContainer(title: Text.detailTitle, label: self.detailLabel, isLabelBottom: true)
        self.completedTimeContainer = addContainer(title: Text.completedTimeTitle, label: self.completedTimeLabel)
        self.errorContainer = addContainer(title: nil, label: self.errorLabel)
        
        self.headerContentView.addArrangedSubview(self.workCompletionButtonContainer)
        self.workCompletionButtonContainer.snp.makeConstraints {
            $0.height.equalTo(88)
        }
        self.workCompletionButtonContainer.addSubview(self.workCompletionButton)
        self.workCompletionButton.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        let navigationBottomLine = UIView().then {
            $0.backgroundColor = .lightGrayF0F0F0
        }
        self.view.addSubview(navigationBottomLine)
        navigationBottomLine.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        let headerBottomLine = UIView().then {
            $0.backgroundColor = .lightGrayF0F0F0
        }
        self.headerContainer.addSubview(headerBottomLine)
        headerBottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func bind(reactor: ServiceDetailViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refreshService }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refreshService }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(ServiceDetailServiceUnitCellReactor.self)
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                //TODO: 목적지 상세정보 보기
            }).disposed(by: self.disposeBag)
        
        self.moreButton.rx.tap
            .flatMapLatest { _ -> Observable<MoreMenu> in
                //서비스 정보 보기, 서비스 로그 보기,( 서비스 중단하기,) 간편 생성 등록하기
                var items: [MoreMenu] = [.serviceInfo, .serviceLog]
                if let phase = reactor.currentState.service?.phase,
                   phase == .waiting || phase == .delivering {
                    items.append(.cancelService)
                }
                items.append(.addShortcut)
                return UIAlertController.show(.actionSheet, items: items).map(\.1)
            }.subscribe(onNext: { [weak self] selectedMenu in
                switch selectedMenu {
                case .serviceInfo:
                    self?.navigationPush(
                        type: ServiceBasicInfoViewController.self,
                        reactor: reactor.reactorForBasicInfo(),
                        animated: true,
                        bottomBarHidden: true
                    )
                case .serviceLog:
                    self?.navigationPush(
                        type: ServiceDetailLogViewController.self,
                        reactor: reactor.reactorForDetailLog(),
                        animated: true,
                        bottomBarHidden: true
                    )
                case .cancelService:
                    reactor.action.onNext(.cancelService)
                case .addShortcut:
                    print("shortcut")
                }
            }).disposed(by: self.disposeBag)
        
        //State
        let service = reactor.state.map(\.service).share()
        
        service.compactMap(\.?.stateDescription)
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        service.compactMap(\.?.stateColor)
            .subscribe(onNext: { [weak self] color in
                UIView.animate(withDuration: 0.25) {
                    self?.navigationBarColor = color
                }
            }).disposed(by: self.disposeBag)
        
        service
            .subscribe(onNext: { [weak self] service in
                guard let self = self else { return }
                
                //서비스 시작 전은 표시하지 않음
                guard let service = service else {
                    self.headerContainer.isHidden = true
                    return
                }
                self.headerContainer.isHidden = false
                
                //실패, 중단
                self.errorContainer.isHidden = (service.phase != .canceled)
                self.errorLabel.text = service.canceledDescription
                
                //완료
                self.completedTimeContainer.isHidden = (service.phase != .completed)
                self.completedTimeLabel.text = service.finishedAt?.infoDateTimeFormatted
                
                //정차지 도착 - 작업완료, 그 외는 표시하지 않음
                let userId = reactor.provider.userManager.userTB.ID
                let isMyTurn = service.isMyTurn(userId)
                
                let authNumber = service.currentServiceUnit?.authNumber
                self.authNumberContainer.isHidden = (!isMyTurn || (authNumber ?? "").isEmpty)
                self.authNumberLabel.text = authNumber
                
                let detail = service.currentServiceUnit?.detail
                self.detailContainer.isHidden = (!isMyTurn || (detail ?? "").isEmpty)
                self.detailLabel.text = detail
                
                self.workCompletionButtonContainer.isHidden = !isMyTurn
                
                //하위 뷰가 모두 감춰지면 컨테이너도 감춤
                let isContainerHidden = self.headerContentView.subviews.map(\.isHidden).reduce(true, { $0 && $1 })
                self.headerContainer.isHidden = isContainerHidden
                
            }).disposed(by: self.disposeBag)
        
        reactor.state
            .map { [.init(items: $0.serviceUnitReactors)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard self?.refreshControl.isRefreshing == true else { return }
                self?.refreshControl.endRefreshing()
            }).disposed(by: self.disposeBag)
    }
}
