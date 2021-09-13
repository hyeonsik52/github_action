//
//  WorkspaceHomeViewController.swift
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
//import PanModal
//import SkeletonView

class WorkspaceHomeViewController: BaseViewController, View {
    
    private var workspaceView = WorkspaceSelectView()
    private var headerView = WorkspaceHeaderView()
    
    #if TEST
    private let shortcutView1 = WorkspaceShortcutView().then {
        $0.titleLabel.text = "서비스 간편생성 1"
        $0.contentLabel.text = "미리 설정한 경로로 주행합니다"
        $0.button.setTitle("서비스 시작하기", for: .normal)
    }
    private let shortcutView2 = WorkspaceShortcutView().then {
        $0.titleLabel.text = "서비스 간편생성 2"
        $0.contentLabel.text = "미리 설정한 경로로 주행합니다"
        $0.button.setTitle("서비스 시작하기", for: .normal)
    }
    private let shortcutView3 = WorkspaceShortcutView().then {
        $0.titleLabel.text = "서비스 간편생성 3"
        $0.contentLabel.text = "미리 설정한 경로로 주행합니다"
        $0.button.setTitle("서비스 시작하기", for: .normal)
    }
    #endif
    
    private var tableView = UITableView(frame: .zero, style: .grouped).then{
        
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        $0.backgroundColor = .clear
        
        $0.register(WorkspaceHomeSendedRequestTableViewCell.self, forCellReuseIdentifier: "sendedCell")
        $0.register(WorkspaceHomeReceivedRequestTableViewCell.self, forCellReuseIdentifier: "receivedCell")
        
        $0.register(ServiceStateHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        $0.separatorStyle = .none
        $0.sectionFooterHeight = .leastNonzeroMagnitude
        
        $0.isSkeletonable = true
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ServiceModelContainerSection>!
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let topContainer = UIView()
        self.view.addSubview(topContainer)
        topContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        topContainer.addSubview(self.workspaceView)
        self.workspaceView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.lessThanOrEqualToSuperview().offset(-12)
        }
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.height.equalTo(104)
            make.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        #if TEST
        let headerView = UIView()
        self.tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        let shortcutConrainerView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 10
        }
        headerView.addSubview(shortcutConrainerView)
        shortcutConrainerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        shortcutConrainerView.addArrangedSubview(self.shortcutView1)
        shortcutConrainerView.addArrangedSubview(self.shortcutView2)
        shortcutConrainerView.addArrangedSubview(self.shortcutView3)
        #endif
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func bind(reactor: WorkspaceHomeReactor) {
        
        //Action
        let viewDidLoad = self.rx.viewDidLoad.single()
        
        viewDidLoad.map { Reactor.Action.judgeIsFromPush }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        viewDidLoad.map { Reactor.Action.loadWorkspaceInfo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        viewDidLoad.map { Reactor.Action.loadMyInfo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        viewDidLoad.map { Reactor.Action.loadServices }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        viewDidLoad.map { Reactor.Action.updateLastWorkspaceIdx }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.workspaceView.didSelect
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tabBarController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.headerView.didSelect
            .map(reactor.reactorForCreateService)
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = CreateServiceViewController()
                viewController.reactor = reactor
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        #if TEST
        self.shortcutView1.button.rx.tap
            .throttle(.seconds(30), scheduler: MainScheduler.instance)
            .map { Reactor.Action.requestShortcutService(4) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.shortcutView2.button.rx.tap
            .throttle(.seconds(30), scheduler: MainScheduler.instance)
            .map { Reactor.Action.requestShortcutService(5) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.shortcutView3.button.rx.tap
            .throttle(.seconds(30), scheduler: MainScheduler.instance)
            .map { Reactor.Action.requestShortcutService(6) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        #endif
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.dataSource = RxTableViewSectionedReloadDataSource<ServiceModelContainerSection>(configureCell: { [weak self] dataSource, tableView, indexPath, reactor -> UITableViewCell in
            
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "receivedCell", for: indexPath) as! WorkspaceHomeReceivedRequestTableViewCell
                cell.reactor = reactor
                cell.delegate = self
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "sendedCell", for: indexPath) as! WorkspaceHomeSendedRequestTableViewCell
                cell.reactor = reactor
                cell.delegate = self
                return cell
            default:
                break
            }
            
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        })
        
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.loadServices }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap { $0.worspace }
            .bind(to: self.workspaceView.rx.workspace)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.myUserInfo }
            .bind(to: self.headerView.rx.user)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map {[
                ServiceModelContainerSection(
                    header: "받은 요청",
                    items: [ServiceContainerCellReactor(
                        models: [ServiceModelSection(
                            header: "",
                            items: $0.receivedServices.map{ServiceCellReactor(mode: .homeSended, service: $0.service, serviceUnit: $0.serviceUnit, serviceUnitOffset: $0.serviceUnitOffset)})
                    ])
                ]),
                ServiceModelContainerSection(
                    header: "보낸 요청",
                    items: [ServiceContainerCellReactor(
                        models: [ServiceModelSection(
                            header: "",
                            items: $0.sendedServices.map{ServiceCellReactor(mode: .homeSended, service: $0)})
                    ])
                ])]}
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .bind(to: self.tableView.rx.skeleton)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing ?? false }
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isFromPush }
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                
                switch reactor.pushInfo?.notificationType {
                case .received:
                    if let serviceIdx = reactor.pushInfo?.serviceIdx,
                        let serviceUnitIdx = reactor.pushInfo?.serviceUnitIdx
                    {
                        let viewController = WorkRequestViewController()
                        viewController.reactor = reactor.reactorForSelectReceivedService(
                            serviceIdx: serviceIdx,
                            serviceUnitIdx: serviceUnitIdx
                        )
                        let navigationController = PanModalNavigationController(
                            rootViewController: viewController
                        )
                        self?.presentPanModal(navigationController)
                    }
                    
                case .robotArrived:
                    let viewController = ServiceDetailViewController()
                    viewController.reactor = reactor.reactorForReceivedRequest()
                    self?.navigationController?.pushViewController(viewController, animated: true)
   
                default: return
                }
            }).disposed(by: self.disposeBag)
        
        #if TEST
        // 간편 서비스 생성 실패 시: 에러 메시지를 얼럴트로 표출
        reactor.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.errorMessageAlert(message)
            }).disposed(by: self.disposeBag)
        
        // 간편 서비스 생성 성공 시: '내 서비스' 탭으로 이동
        reactor.isPresetCreateSuccess
            .filter { $0 == true }
            .subscribe(onNext: { isPresetCreateSuccess in
                Log.debug("🟢 Preset service successfully created")
                
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 1
                }
            }).disposed(by: self.disposeBag)
        #endif
    }
}

#if TEST
extension WorkspaceHomeViewController {
    
    func errorMessageAlert(_ errorMessage: String) {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "확인", style: .default)
        ]
        
        DispatchQueue.main.async {
            UIAlertController.present(
                in: self,
                title: errorMessage,
                style: .alert,
                actions: actions
            ).subscribe(onNext: { _ in })
            .disposed(by: self.disposeBag)
        }
    }
}
#endif

extension WorkspaceHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let reactor = self.reactor else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ServiceStateHeaderView
        
        let modelSection = self.dataSource[section]
        header.bind(modelSection.header) { [weak self] in
            
            if section == 0 {
                
                let viewController = ReceivedRequestViewController()
                viewController.reactor = reactor.reactorForReceivedServiceList()
                self?.navigationController?.pushViewController(viewController, animated: true)
                
            }else if section == 1 {
                
                let viewController = SendedRequestViewController()
                viewController.reactor = reactor.reactorForSendedServiceList()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = self.dataSource
            .sectionModels[indexPath.section].items[indexPath.row]
            .currentState[0].items.count
        let unit: CGFloat = 66
        switch indexPath.section {
        case 0:
            return unit * CGFloat(min(count, 3))
        case 1:
            return unit*3 * CGFloat(min(count, 1))
        default:
            return .zero
        }
    }
}

extension WorkspaceHomeViewController: ServiceCellDelegate {
    
    func didSelect(_ service: ServiceModel, _ serviceUnit: ServiceUnitModel?, _ isServiceDetail: Bool) {
        guard let reactor = self.reactor else { return }
        
        if isServiceDetail {
            
            let viewController = ServiceDetailViewController()
            viewController.reactor = reactor.reactorForSelectSendedService(mode: .preparing, serviceIdx: service.serviceIdx)
            
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }else{
            
            guard let serviceUnit = serviceUnit else { return }
            
            let viewController = WorkRequestViewController()
            viewController.reactor = reactor.reactorForSelectReceivedService(serviceIdx: service.serviceIdx, serviceUnitIdx: serviceUnit.serviceUnitIdx)
            let navigationController = PanModalNavigationController(rootViewController: viewController)
            
            self.presentPanModal(navigationController)
        }
    }
}
