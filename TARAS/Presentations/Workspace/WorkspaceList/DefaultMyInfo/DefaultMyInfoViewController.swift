//
//  DefaultMyInfoViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class DefaultMyInfoViewController: BaseNavigationViewController, ReactorKit.View {
    
    enum Text {
        static let SVC_1 = "설정"
        static let SVC_7 = "로그아웃"
        static let SVC_8 = "로그아웃 하시겠습니까?"
        static let SVC_9 = "회원 탈퇴"
        static let SVC_10 = "탈퇴"
        static let SVC_11 = "\nTARAS에서 탈퇴하시겠습니까?"
        static let SVC_12 = "수정"
        static let SVC_13 = "취소"
    }
    
    private let refreshControl = UIRefreshControl()
    private lazy var scrollView = UIScrollView().then {
        $0.refreshControl = self.refreshControl
        $0.isScrollEnabled = true
        $0.clipsToBounds = true
    }
    
    private let myInfoHeader = SettingScrollViewHeader(title: "내 정보")
    private let idCellView = SettingTextCellView(title: "아이디", isArrowHidden: true)
    private let nameCellView = SettingTextCellView(title: "이름")
    private let emailCellView = SettingTextCellView(title: "이메일")
    private let phoneNumberCellView = SettingTextCellView(title: "전화번호")

    private let appInfoHeader = SettingScrollViewHeader(title: "앱 정보")
    private let versionCellView = SettingTextCellView(title: "버전")
    
    private let signOutButton = SRPButton(
        Text.SVC_7,
        appearance: .init(
            titleColors: [.normal(.black)],
            backgroundColors: [.normal(.grayF8F8F8)]
        )
    )
    private let resignButton = SRPButton(
        Text.SVC_9,
        appearance: .init(
            titleColors: [.normal(.black)],
            backgroundColors: [.normal(.white)]
        )
    ).then {
        $0.layer.borderWidth = 1
        $0.outlineColor = .grayF6F6F6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        self.setupDebugging()
        #endif
    }
    
    override func setupConstraints() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.resignButton)
        self.resignButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.signOutButton)
        self.signOutButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.resignButton.snp.top).offset(-12)
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.signOutButton.snp.top).offset(-12)
        }
        
        let contentView = UIStackView().then {
            $0.axis = .vertical
        }
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        func addContent(_ view: UIView, height: CGFloat = 48) {
            contentView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.leading.trailing.equalTo(contentView)
                $0.height.equalTo(height)
            }
        }

        addContent(self.myInfoHeader, height: 71)
        addContent(self.idCellView)
        addContent(self.nameCellView)
        addContent(self.emailCellView)
        addContent(self.phoneNumberCellView)

        addContent(self.appInfoHeader, height: 71)
        addContent(self.versionCellView)

        //footer
        addContent(UIView(), height: 26)
                
        
        let line = UIView().then {
            $0.backgroundColor = .grayF8F8F8
        }
        self.view.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.SVC_1
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: DefaultMyInfoViewReactor) {
        
        // Action
        self.rx.viewWillAppear
            .map {_ in Reactor.Action.reload }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.reload }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nameCellView.didSelect
            .subscribe(onNext: { [weak self] in
                let viewController = UpdateUserInfoViewController()
                viewController.reactor = reactor.reactorForUpdateUserInfo(.name)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.emailCellView.didSelect
            .subscribe(onNext: { [weak self] in
                //TODO: 기능 개발이 완료되어 사용할 수 있을 때, 화면을 연결합니다.
//                let viewController = UpdateUserEmailViewController()
//                viewController.reactor = reactor.reactorForUpdateEmail()
//                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.signOutButton.rx.throttleTap
            .subscribe(onNext: { [weak self] in
                self?.logout(reactor)
            }).disposed(by: self.disposeBag)
        
        self.resignButton.rx.throttleTap
            .subscribe(onNext: { [weak self] in
                self?.resign(reactor)
            }).disposed(by: self.disposeBag)
        
        
        // State
        let account = reactor.state.map { $0.account }.share()
        account.map { ($0?.id, nil) }
            .bind(to: self.idCellView.rx.detail)
            .disposed(by: self.disposeBag)
        account.map { ($0?.name, nil) }
            .bind(to: self.nameCellView.rx.detail)
            .disposed(by: self.disposeBag)
        account.map { ($0?.email, $0?.email == nil ? ("인증이 필요합니다.", .redEB4D39): nil) }
            .bind(to: self.emailCellView.rx.detail)
            .disposed(by: self.disposeBag)
        account.map { ($0?.phoneNumber, $0?.phoneNumber == nil ? ("인증이 필요합니다.", .redEB4D39): nil) }
            .bind(to: self.phoneNumberCellView.rx.detail)
            .disposed(by: self.disposeBag)
        
        let version = reactor.state.compactMap(\.version).share()
        version.map {
                let color: UIColor = ($0.isThisLatest ? .gray888888: .redEB4D39)
                let description = ($0.isThisLatest ? "최신 버전입니다.": "새로운 버전이 있습니다.")
                return ($0.currentVersion, (description, color))
            }.bind(to: self.versionCellView.rx.detail)
            .disposed(by: self.disposeBag)
        version.map(\.isThisLatest)
            .bind(to: self.versionCellView.arrowImageView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLogout == true || $0.isResign == true }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let window = self?.view.window,
                      let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let viewController = SignInViewController()
                viewController.reactor = SignInViewReactor(provider: appDelegate.provider)
                viewController.modalTransitionStyle = .crossDissolve
                let navigationViewController = UINavigationController(rootViewController: viewController)
                window.rootViewController = navigationViewController
                self?.navigationController?.viewControllers = []
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] _ in
                if self?.refreshControl.isRefreshing ?? false {
                    self?.refreshControl.endRefreshing()
                }
            }).disposed(by: self.disposeBag)
        
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
    }
    
    private func logout(_ reactor: DefaultMyInfoViewReactor) {
        
        let actions: [UIAlertController.AlertAction] = [
            .action(title: Text.SVC_13, style: .cancel),
            .action(title: Text.SVC_7, style: .destructive)
        ]
        
        UIAlertController.present(
            in: self,
            title: nil,
            message: Text.SVC_8,
            style: .alert,
            actions: actions
        )
        .filter { $0 == 1 }
        .map {_ in Reactor.Action.logout }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
    }
    
    private func resign(_ reactor: DefaultMyInfoViewReactor) {
        
        let actions: [UIAlertController.AlertAction] = [
            .action(title: Text.SVC_13, style: .cancel),
            .action(title: Text.SVC_10, style: .destructive)
        ]
        
        UIAlertController.present(
            in: self,
            title: Text.SVC_9,
            message: Text.SVC_11,
            style: .alert,
            actions: actions
        )
        .filter { $0 == 1 }
        .map {_ in Reactor.Action.resign }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
    }
    
    private func setupDebugging() {
        
        let longPressRecognizer = UILongPressGestureRecognizer()
        self.myInfoHeader.addGestureRecognizer(longPressRecognizer)
        
        longPressRecognizer.rx.event
            .flatMapLatest {_ in Log.extract() }
            .subscribe(onNext: { [weak self] viewController in
                self?.navigationController?.present(viewController, animated: true)
            }, onError: { error in
                Log.error(error.localizedDescription)
            }).disposed(by: self.disposeBag)
    }
}
