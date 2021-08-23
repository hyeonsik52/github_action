//
//  WorkspaceSearchResultViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import Apollo
import RxSwift
import ReactorKit

class WorkspaceSearchResultViewController: BaseNavigationViewController, ReactorKit.View {

    enum Text {
        static let WSSRVC_1 = "워크스페이스 가입"
    }

    let resultView = WorkspaceSearchResultView()


    // MARK: - Life cycles

    override func setupConstraints() {
        super.setupConstraints()

        self.view.addSubview(self.resultView)
        self.resultView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(90)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        self.resultView.memberCountLabel.sizeToFit()
        let width = self.resultView.memberCountLabel.frame.width + 44
        self.resultView.memberCountLabel.snp.updateConstraints {
            $0.width.equalTo(width)
        }
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = Text.WSSRVC_1
        self.navigationController?.navigationBar.isHidden = false
    }

    override func bind() {
        // 뒤로가기 버튼 액션
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }

    // MARK: - ReactorKit

    func bind(reactor: WorkspaceSearchResultViewReactor) {
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.resultView.enterButton.rx.tap
            .map { _ in Reactor.Action.requestJoin }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.joinState }
            .distinctUntilChanged()
            .map { _ in reactor.currentState.cellModel }
            .subscribe(onNext: { [weak self] cellModel in
                guard let self = self else { return }
                self.resultView.setupView(with: cellModel)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.requestResult }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.cancelResult }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.enterResult }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in reactor.currentState.cellModel.swsIdx }
            .map(reactor.reactorForSWSHome)
            .subscribe(onNext: { [weak self] reactor in
                if let rootViewController = self?.navigationController?.viewControllers.first as? WorkspaceListViewController {
                    let viewController = WorkspaceTabBarController()
                    viewController.reactor = reactor
                    rootViewController.navigationController?.pushViewController(viewController, animated: true)
                    rootViewController.navigationController?.viewControllers.removeAll(where: {
                        $0.isKind(of: WorkspaceSearchViewController.self) || $0.isKind(of: WorkspaceSearchResultViewController.self)
                    })
                }
            }).disposed(by: self.disposeBag)
    }
}
