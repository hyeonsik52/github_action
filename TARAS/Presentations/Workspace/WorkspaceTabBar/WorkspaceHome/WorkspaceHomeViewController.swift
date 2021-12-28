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

class WorkspaceHomeViewController: BaseViewController, View {
    
    private var workspaceView = WorkspaceSelectView()
    private var headerView = WorkspaceHeaderView()
    
    private var tableView = UITableView(frame: .zero, style: .grouped).then{
        
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        $0.backgroundColor = .clear
        
        $0.separatorStyle = .none
        $0.sectionFooterHeight = .leastNonzeroMagnitude
        
        $0.refreshControl = UIRefreshControl()
    }
    
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
        
        self.rx.viewWillAppear
            .map {_ in Reactor.Action.loadMyInfo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.workspaceView.didSelect
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.reactor?.provider.userManager.userTB.update {
                    $0.lastWorkspaceId = nil
                }
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
        
        //State
        reactor.state.compactMap { $0.worspace }
            .bind(to: self.workspaceView.rx.workspace)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.myUserInfo }
            .bind(to: self.headerView.rx.user)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing ?? false }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isFromPush }
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let type = reactor.pushInfo?.notificationType else { return }
                switch type {
                case .serviceStarted, .serviceEnded, .waitingWorkCompleted, .default:
                    //TODO: 상세 화면으로 연결
                    print()
                }
            }).disposed(by: self.disposeBag)
    }
}
