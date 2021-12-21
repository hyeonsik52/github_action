//
//  WorkspaceListViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import Apollo
//import NVActivityIndicatorView
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import RxDataSources

class WorkspaceListViewController: BaseViewController, ReactorKit.View {
    
    enum Text {
        static let WSLVC_1 = "워크스페이스"
    }
    
    let refreshControl = UIRefreshControl()
    
    let settingBarButton = UIBarButtonItem(
        image: UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )
    
    let joinWorkspaceBarButton = UIBarButtonItem(
        image: UIImage(named: "naviAdd")?.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.addSubview(self.refreshControl)
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.contentInset.bottom = 60
        $0.register(WorkspaceListCell.self)
        $0.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude)
        )
    }
    
    let tableViewPlaceholder = WorkspaceListPlaceholderView()
    
    let dataSource = RxTableViewSectionedReloadDataSource<WorkspaceListSection>(
        configureCell: { dataSource, tableView, indexPath, reactor -> UITableViewCell in
            let cell = tableView.dequeueCell(ofType: WorkspaceListCell.self, indexPath: indexPath)
            cell.reactor = reactor
            return cell
    })

    
    // MARK: - Life Cycles
    
    override func setupConstraints() {
        self.tableView.backgroundView = self.tableViewPlaceholder
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.WSLVC_1
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.setLeftBarButton(self.settingBarButton, animated: true)
        self.navigationItem.setRightBarButton(self.joinWorkspaceBarButton, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.tableViewPlaceholder.frame = self.tableView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.reactor?.action.onNext(.judgeEntrance)
    }
    
    
    // MARK: - ReactorKit
    
    func bind(reactor: WorkspaceListViewReactor) {
        refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in Reactor.Action.refresh }
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        self.dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource[index].header
        }
        
        self.tableView.rx.modelSelected(WorkspaceListCellReactor.self)
            .filter { $0.currentState.myMemberState == .requestingToJoin }
            .map { reactor.reactorForResult($0) }
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = WorkspaceSearchResultViewController()
                viewController.reactor = reactor
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(WorkspaceListCellReactor.self)
            .filter { $0.currentState.myMemberState == .member }
            .map { reactor.reactorForSWSHome(workspaceId: $0.initialState.id) }
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = WorkspaceTabBarController()
                viewController.reactor = reactor
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.settingBarButton.rx.tap
            .map(reactor.reactorForDefaultMyInfo)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = DefaultMyInfoViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
                
        self.joinWorkspaceBarButton.rx.tap
            .map(reactor.reactorForSearch)
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = WorkspaceSearchViewController()
                viewController.reactor = reactor
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isPlaceholderHidden }
            .bind(to: self.tableViewPlaceholder.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.entranceType }
            .distinctUntilChanged()
            .subscribe(onNext: { entranceType in
                switch entranceType {
                case .signIn:
                    if reactor.provider.userManager.userTB.isInitialOpen,
                        reactor.currentState.sections.count == 0
                    {
                        // todo: 수동 FCM Token 업데이트 reactor 처리
                        reactor.action.onNext(.updateFCMToken)
                        let viewController = WorkspaceSearchViewController()
                        viewController.reactor = reactor.reactorForSearch()
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }

                case .launch:
                    if let lastWorkspaceId = reactor.provider.userManager.userTB.lastWorkspaceId
                    {
                        let nextReactor = reactor.reactorForSWSHome(workspaceId: lastWorkspaceId)
                        let viewController = WorkspaceTabBarController()
                        viewController.reactor = nextReactor
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }

                case .push, .none: return
                }
            }).disposed(by: self.disposeBag)
    }
}
