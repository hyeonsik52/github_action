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

class WorkspaceSearchResultViewController: BaseNavigatableViewController, ReactorKit.View {

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
            .map { _ in Reactor.Action.requestJoin }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.resultView.enterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                //가입 상태에 따른 요청
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.workspace }
            .subscribe(onNext: { [weak self] workspace in
                self?.resultView.setupView(with: workspace)
            }).disposed(by: self.disposeBag)
    }
}
