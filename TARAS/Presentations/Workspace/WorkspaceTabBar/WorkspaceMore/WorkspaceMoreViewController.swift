//
//  WorkspaceMoreViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/25.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class WorkspaceMoreViewController: BaseNavigatableViewController, ReactorKit.View {
    
    enum Text {
        static let Title = "정보"
        static let QuitTitle = "워크스페이스 탈퇴"
        static let QuitContent = "해당 워크스페이스에서 탈퇴하시겠습니까?"
        static let Cancel = "취소"
        static let Quit = "탈퇴"
        static let QuitComplate = "워크스페이스에서 탈퇴하였습니다."
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(.init(named: "setting"), for: .normal)
    }
    private lazy var titleView = WorkspaceTitleView(title: Text.Title, button: self.settingButton, buttonWidth: 52)
    private lazy var workspaceView = JoinRequestView(entry: .joined).then {
        $0.delegate = self
        $0.isHidden = true
    }
    
    override func setupConstraints() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.workspaceView)
        self.workspaceView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: WorkspaceMoreViewReactor) {
        
        // Action
        self.rx.viewWillAppear
            .map {_ in Reactor.Action.reload }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.settingButton.rx.throttleTap
            .subscribe(onNext: { [weak self] in
                let viewController = DefaultMyInfoViewController()
                viewController.reactor = reactor.reactorForSetting()
                self?.trsNavigationController?.pushViewController(viewController, animated: true, hideBottom: true)
            }).disposed(by: self.disposeBag)

        // State
        reactor.state.compactMap { $0.workspace }
            .bind(to: self.workspaceView.rx.workspace)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .filterNil()
            .flatMapLatest { [weak self] message in
                UIAlertController.present(
                    in: self,
                    title: nil,
                    message: message,
                    style: .alert,
                    actions: [.action(title: "확인", style: .default)]
                )
            }
            .subscribe()
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isQuit }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                Text.QuitComplate.sek.showToast()
                self?.tabBarController?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
}

extension WorkspaceMoreViewController: JoinRequestViewDelegate {
    
    func buttonDidTap(_ workspaceId: String,_ memberState: WorkspaceMemberState) {
        guard let reactor = self.reactor else { return }
        switch memberState {
        case .member:

            let actions: [UIAlertController.AlertAction] = [
                .action(title: Text.Cancel, style: .cancel),
                .action(title: Text.Quit, style: .destructive)
            ]

            UIAlertController.present(
                in: self,
                title: Text.QuitTitle,
                message: Text.QuitContent,
                style: .alert,
                actions: actions
            )
            .filter { $0 == 1 }
            .map {_ in Reactor.Action.quit }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
            
        default: break
        }
    }
}
