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

class DefaultMyInfoViewController: BaseNavigatableViewController, ReactorKit.View {
    
    override var bottomVisibleWhenPopped: Bool {
        return true
    }
    
    enum Text {
        static let SVC_1 = "설정"
        static let SVC_7 = "로그아웃"
        static let SVC_8 = "\n로그아웃 하시겠습니까?"
        static let SVC_9 = "회원 탈퇴"
        static let SVC_10 = "탈퇴"
        static let SVC_11 = NSMutableAttributedString(
            string: "\n회원 탈퇴 시 아래 정보를 잃게 되며,\n재가입하더라도 삭제된 데이터는 복구되지 않습니다.\n\n⋅ 모든 서비스 이용 내역 삭제\n⋅ 가입한 모든 워크스페이스에서 자동 탈퇴\n\n위 내용을 확인하고, 회원을 탈퇴합니다.",
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.black
            ]).then {
                $0.addAttribute(
                    .foregroundColor,
                    value: UIColor.redEB4D39,
                    range: NSRange(location: 52, length: 41)
                )
            }
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
        $0.outlineWidth = 1
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
        
        //인증 관련 기능 작업 전 까지 임시로 주석처리
//        self.emailCellView.didSelect
//            .subscribe(onNext: { [weak self] in
//                let viewController = UpdateUserInfoViewController()
//                viewController.reactor = reactor.reactorForUpdateUserInfo(.email)
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            }).disposed(by: self.disposeBag)
//
//        self.phoneNumberCellView.didSelect
//            .subscribe(onNext: { [weak self] in
//                let viewController = UpdateUserInfoViewController()
//                viewController.reactor = reactor.reactorForUpdateUserInfo(.phoneNumber)
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            }).disposed(by: self.disposeBag)
        
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
        account.map { ($0?.ID, nil) }
            .bind(to: self.idCellView.rx.detail)
            .disposed(by: self.disposeBag)
        account.map { ($0?.name, nil) }
            .bind(to: self.nameCellView.rx.detail)
            .disposed(by: self.disposeBag)
        account.map { ($0?.email, ("인증이 필요합니다.", .redEB4D39)) }
            .bind(to: self.emailCellView.rx.detail)
            .disposed(by: self.disposeBag)
        account.map { ($0?.phoneNumber, ("인증이 필요합니다.", .redEB4D39)) }
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
                let navigationViewController = BaseNavigationController(rootViewController: viewController)
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
            title: Text.SVC_7,
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
            attributedMessage: Text.SVC_11,
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

//
//import UIKit
//import SnapKit
//import Then
//import ReactorKit
//
//class DefaultMyInfoViewController: BaseNavigatableViewController, View {
//
//    private let profileImageCellView = SettingProfileCellView(title: "프로필 사진")
//    private let idCellView = SettingTextCellView(title: "아이디", isArrowHidden: true)
//    private let nameCellView = SettingTextCellView(title: "이름")
//    private let emailCellView = SettingTextCellView(title: "이메일")
//    private let phoneNumberCellView = SettingTextCellView(title: "전화번호")
//
//    private let myInfoHeader = SettingScrollViewHeader(title: "계정 관리")
//    private let signOutCellView = SettingTextCellView(title: "로그아웃")
//    private let changePasswordCellView = SettingTextCellView(title: "계정 비밀번호 변경")
//    private let escapeSockseCellView = SettingTextCellView(title: "TARAS 탈퇴")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        #if DEBUG
//        self.setupDebugging()
//        #endif
//    }
//
//    override func setupNaviBar() {
//        super.setupNaviBar()
//
//        self.title = "설정"
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//    }
//
//    override func setupConstraints() {
//        super.setupConstraints()
//
//        let scrollView = UIScrollView().then {
//            $0.contentInset.top = 14
//        }
//
//        self.view.addSubview(scrollView)
//        scrollView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        let contentView = UIStackView().then {
//            $0.axis = .vertical
//        }
//
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//            $0.width.equalToSuperview()
//        }
//
//        func addContent(_ view: UIView, height: CGFloat = 48) {
//            contentView.addArrangedSubview(view)
//            view.snp.makeConstraints {
//                $0.leading.trailing.equalTo(contentView)
//                $0.height.equalTo(height)
//            }
//        }
//
//        addContent(self.profileImageCellView)
//        addContent(self.idCellView)
//        addContent(self.nameCellView)
//        addContent(self.emailCellView)
//        addContent(self.phoneNumberCellView)
//
//        addContent(self.myInfoHeader, height: 71)
//        addContent(self.signOutCellView)
//        addContent(self.changePasswordCellView)
//        addContent(self.escapeSockseCellView)
//
//        //footer
//        addContent(UIView(), height: 26)
//    }
//
//    override func bind() {
//        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
//            self?.navigationController?.popViewController(animated: true)
//        }).disposed(by: self.disposeBag)
//    }
//
//    func bind(reactor: DefaultMyInfoViewReactor) {
//
//        //Action
//
//        self.rx.viewWillAppear
//            .map { _ in Reactor.Action.refresh }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
////        self.profileImageCellView.didSelect
////            .map(reactor.reactorForProfileImageUpdate)
////            .subscribe(onNext: { [weak self] reactor in
////
////            })
////            .disposed(by: self.disposeBag)
//
//        self.nameCellView.didSelect
//            .map(reactor.reactorForNameUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//                let viewController = Default_Name_ViewController()
//                viewController.reactor = reactor
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.emailCellView.didSelect
//            .map(reactor.reactorForEmailUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//                let viewController = Default_Email_ViewController()
//                viewController.reactor = reactor
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.phoneNumberCellView.didSelect
//            .map(reactor.reactorForPhoneNumberUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//                let viewController = Default_PhoneNumber_ViewController()
//                viewController.reactor = reactor
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.signOutCellView.didSelect
//            .subscribe(onNext: { [weak self] _ in
//                self?.signOutAlert {
//                    reactor.action.onNext(.signOut)
//                }
//            })
//            .disposed(by: self.disposeBag)
//
//        self.changePasswordCellView.didSelect
//            .map(reactor.reactorForChangePassword)
//            .subscribe(onNext: { [weak self] reactor in
//                let viewController = Default_PW_ViewController()
//                viewController.reactor = reactor
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        self.escapeSockseCellView.didSelect
//            .subscribe(onNext: { [weak self] _ in
//                self?.escapeSockseAlert {
//                    reactor.action.onNext(.escapeSockse)
//                }
//            })
//            .disposed(by: self.disposeBag)
//
//        //State
//        let userInfo = reactor.state.compactMap { $0.userInfo }
//
////        userInfo
////            .bind(to: self.profileImageCellView.rx.info)
////            .disposed(by: self.disposeBag)
//
//        userInfo
//            .map { $0.userId }
//            .bind(to: self.idCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        userInfo
//            .map { $0.name }
//            .bind(to: self.nameCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        userInfo
//            .map { $0.email }
//            .bind(to: self.emailCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        userInfo
//            .map { $0.phoneNumber ?? "-" }
//            .map { reactor.provider.userManager.denationalizePhoneNumber($0) }
//            .bind(to: self.phoneNumberCellView.rx.detail)
//            .disposed(by: self.disposeBag)
//
//        reactor.state.map { $0.willMoveToSignIn }
//            .distinctUntilChanged()
//            .map { _ in reactor.reactorForSignIn() }
//            .subscribe(onNext: { [weak self] reactor in
//                let viewController = SignInViewController()
//                viewController.reactor = reactor
//                viewController.modalTransitionStyle = .crossDissolve
//                let navigationViewController = UINavigationController(rootViewController: viewController)
//                self?.view.window?.rootViewController = navigationViewController
//            }).disposed(by: self.disposeBag)
//
//        reactor.state.map { $0.errorMessage }
//            .filterNil()
//            .subscribe(onNext: { [weak self] message in
//                self?.errorMesssageAlert(message: message)
//            }).disposed(by: self.disposeBag)
//    }
//
//    func errorMesssageAlert(
//        message: String
//    ) {
//        let actions: [UIAlertController.AlertAction] = [
//            .action(title: "확인", style: .default)
//        ]
//
//        UIAlertController.present(
//            in: self,
//            title: message,
//            style: .alert,
//            actions: actions
//        ).subscribe(onNext: { _ in })
//        .disposed(by: self.disposeBag)
//    }
//
//    func signOutAlert(
//        signOutHandler: @escaping (() -> Void)
//    ) {
//        let actions: [UIAlertController.AlertAction] = [
//                .action(title: "로그아웃", style: .destructive),
//                .action(title: "취소", style: .cancel)
//        ]
//
//        UIAlertController.present(
//            in: self,
//            title: "로그아웃 하시겠습니까?",
//            style: .alert,
//            actions: actions
//        ).subscribe(onNext: { actionIndex in
//            if actionIndex == 0 {
//                signOutHandler()
//            }
//        }).disposed(by: self.disposeBag)
//    }
//
//    func escapeSockseAlert(
//        escapeSockseHandler: @escaping (() -> Void)
//    ) {
//        let actions: [UIAlertController.AlertAction] = [
//                .action(title: "회원 탈퇴", style: .destructive),
//                .action(title: "취소", style: .cancel)
//        ]
//
//        UIAlertController.present(
//            in: self,
//            title: "계정 탈퇴",
//            message: """
//
//            계정 탈퇴 시 아래 정보를 잃게 되며, 재가입하더라도 삭제된 데이터는 복구되지 않습니다.
//
//            • 모든 서비스 이용 내역 삭제
//            • 가입한 모든 워크스페이스에서 자동 탈퇴
//
//            위 내용을 확인하고, 회원을 탈퇴합니다.
//            """,
//            style: .alert,
//            actions: actions
//        ).subscribe(onNext: { actionIndex in
//            if actionIndex == 0 {
//                escapeSockseHandler()
//            }
//        }).disposed(by: self.disposeBag)
//    }
//
//    private func setupDebugging() {
//
//        let longPressRecognizer = UILongPressGestureRecognizer()
//        self.profileImageCellView.addGestureRecognizer(longPressRecognizer)
//
//        longPressRecognizer.rx.event
//            .flatMapLatest {_ in Log.extract() }
//            .subscribe(onNext: { [weak self] viewController in
//                self?.navigationController?.present(viewController, animated: true)
//            }, onError: { error in
//                Log.err(error.localizedDescription)
//            }).disposed(by: self.disposeBag)
//    }
//
//}
//
//
//extension DefaultMyInfoViewController {
//    func gestureRecognizer(
//        _ gestureRecognizer: UIGestureRecognizer,
//        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
//    ) -> Bool {
//        return true
//    }
//}
