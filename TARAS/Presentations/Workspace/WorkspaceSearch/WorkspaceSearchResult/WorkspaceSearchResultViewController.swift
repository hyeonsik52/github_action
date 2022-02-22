//
//  WorkspaceSearchResultViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Apollo
import RxSwift
import ReactorKit

class WorkspaceSearchResultViewController: BaseNavigationViewController, ReactorKit.View {

    enum Text {
        static let WSSRVC_1 = "워크스페이스 가입"
    }

    let resultView = WorkspaceSearchResultView().then {
        $0.isHidden = true
    }


    // MARK: - Life cycles

    override func setupConstraints() {
        super.setupConstraints()

        self.view.addSubview(self.resultView)
        self.resultView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(90)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = Text.WSSRVC_1
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: - ReactorKit

    func bind(reactor: WorkspaceSearchResultViewReactor) {
        
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.resultView.enterButton.rx.tap
            .map { Reactor.Action.request }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.resultView.enterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let workspace = reactor.currentState.workspace,
                      workspace.myMemberState == .member else { return }
                let viewController = WorkspaceTabBarController()
                viewController.reactor = reactor.reactorForSWSHome(workspaceId: workspace.id)
                self?.navigationController?.pushViewController(viewController, animated: true)
                self?.navigationController?.viewControllers.removeAll(where: {
                    $0.isKind(of: WorkspaceSearchViewController.self) || $0.isKind(of: WorkspaceSearchResultViewController.self)
                })
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.workspace }
            .subscribe(onNext: { [weak self] workspace in
                self?.resultView.setupView(with: workspace)
                self?.resultView.isHidden = false
            }).disposed(by: self.disposeBag)
        
        reactor.state.map(\.result)
            .distinctUntilChanged()
            .filter { $0 == true }
            .do {_ in
                switch reactor.currentState.workspace?.myMemberState {
                case .requestingToJoin:
                    "가입 신청을 취소하였습니다.".sek.showToast()
                case .notMember:
                    "가입 신청을 완료하였습니다.".sek.showToast()
                default: break
                }
            }
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.errorMessage)
            .distinctUntilChanged()
            .filterNil()
            .bind(to: Toaster.rx.showToast(color: .redEB4D39))
            .disposed(by: self.disposeBag)
    }
}
