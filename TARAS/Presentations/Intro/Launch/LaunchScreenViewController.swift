//
//  LaunchScreenViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class LaunchScreenViewController: BaseViewController, ReactorKit.View {

    let logoImageView = UIImageView(
        image: .init(named: "logo")
    ).then {
        $0.contentMode = .scaleAspectFill
    }
    
    
    // MARK: - Life Cycles

    override func setupConstraints() {
        self.view.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 170, height: 38))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.centerY).offset(-38)
        }
    }
    
    
    // MARK: - ReactorKit

    func bind(reactor: LaunchScreenViewReactor) {

        RealmManager.shared.openRelay
            .filterNil()
            .map(Reactor.Action.check)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // DB에 토큰 정보가 있는 경우, 메인으로 진입
        reactor.state.map { $0.isAutoSignInEnabled }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in reactor.reactorForWorkspaceList() }
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = WorkspaceListViewController()
                viewController.reactor = reactor
                let navigationController = BaseNavigationController(rootViewController: viewController)
                self.view.window?.rootViewController = navigationController
            }).disposed(by: self.disposeBag)

        // DB에 토큰 정보가 없는 경우, 로그인 화면으로 이동
        reactor.state.map { $0.isAutoSignInEnabled }
            .distinctUntilChanged()
            .filter { $0 == false }
            .map { _ in reactor.reactorForSignIn() }
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = SignInViewController()
                viewController.reactor = reactor
                let navigationController = BaseNavigationController(rootViewController: viewController)
                navigationController.modalTransitionStyle = .crossDissolve
                self.view.window?.rootViewController = navigationController
            }).disposed(by: self.disposeBag)
    }
}
