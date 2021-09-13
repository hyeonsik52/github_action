//
//  DefaultMyInfoViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit

class DefaultMyInfoViewController: BaseNavigatableViewController, View {

    private let profileImageCellView = SettingProfileCellView(title: "프로필 사진")
    private let idCellView = SettingTextCellView(title: "아이디", isArrowHidden: true)
    private let nameCellView = SettingTextCellView(title: "이름")
    private let emailCellView = SettingTextCellView(title: "이메일")
    private let phoneNumberCellView = SettingTextCellView(title: "전화번호")

    private let myInfoHeader = SettingScrollViewHeader(title: "계정 관리")
    private let signOutCellView = SettingTextCellView(title: "로그아웃")
    private let changePasswordCellView = SettingTextCellView(title: "계정 비밀번호 변경")
    private let escapeSockseCellView = SettingTextCellView(title: "TARAS 탈퇴")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        self.setupDebugging()
        #endif
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = "설정"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func setupConstraints() {
        super.setupConstraints()

        let scrollView = UIScrollView().then {
            $0.contentInset.top = 14
        }

        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let contentView = UIStackView().then {
            $0.axis = .vertical
        }

        scrollView.addSubview(contentView)
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

        addContent(self.profileImageCellView)
        addContent(self.idCellView)
        addContent(self.nameCellView)
        addContent(self.emailCellView)
        addContent(self.phoneNumberCellView)

        addContent(self.myInfoHeader, height: 71)
        addContent(self.signOutCellView)
        addContent(self.changePasswordCellView)
        addContent(self.escapeSockseCellView)

        //footer
        addContent(UIView(), height: 26)
    }

    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }

    func bind(reactor: DefaultMyInfoViewReactor) {

        //Action

        self.rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
//        self.profileImageCellView.didSelect
//            .map(reactor.reactorForProfileImageUpdate)
//            .subscribe(onNext: { [weak self] reactor in
//
//            })
//            .disposed(by: self.disposeBag)

        self.nameCellView.didSelect
            .map(reactor.reactorForNameUpdate)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = Default_Name_ViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)

        self.emailCellView.didSelect
            .map(reactor.reactorForEmailUpdate)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = Default_Email_ViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)

        self.phoneNumberCellView.didSelect
            .map(reactor.reactorForPhoneNumberUpdate)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = Default_PhoneNumber_ViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)

        self.signOutCellView.didSelect
            .subscribe(onNext: { [weak self] _ in
                self?.signOutAlert {
                    reactor.action.onNext(.signOut)
                }
            })
            .disposed(by: self.disposeBag)

        self.changePasswordCellView.didSelect
            .map(reactor.reactorForChangePassword)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = Default_PW_ViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)

        self.escapeSockseCellView.didSelect
            .subscribe(onNext: { [weak self] _ in
                self?.escapeSockseAlert {
                    reactor.action.onNext(.escapeSockse)
                }
            })
            .disposed(by: self.disposeBag)

        //State
        let userInfo = reactor.state.compactMap { $0.userInfo }

//        userInfo
//            .bind(to: self.profileImageCellView.rx.info)
//            .disposed(by: self.disposeBag)

        userInfo
            .map { $0.userId }
            .bind(to: self.idCellView.rx.detail)
            .disposed(by: self.disposeBag)

        userInfo
            .map { $0.name }
            .bind(to: self.nameCellView.rx.detail)
            .disposed(by: self.disposeBag)

        userInfo
            .map { $0.email }
            .bind(to: self.emailCellView.rx.detail)
            .disposed(by: self.disposeBag)

        userInfo
            .map { $0.phoneNumber ?? "-" }
            .map { reactor.provider.userManager.denationalizePhoneNumber($0) }
            .bind(to: self.phoneNumberCellView.rx.detail)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.willMoveToSignIn }
            .distinctUntilChanged()
            .map { _ in reactor.reactorForSignIn() }
            .subscribe(onNext: { [weak self] reactor in
                let viewController = SignInViewController()
                viewController.reactor = reactor
                viewController.modalTransitionStyle = .crossDissolve
                let navigationViewController = UINavigationController(rootViewController: viewController)
                self?.view.window?.rootViewController = navigationViewController
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filterNil()
            .subscribe(onNext: { [weak self] message in
                self?.errorMesssageAlert(message: message)
            }).disposed(by: self.disposeBag)
    }
    
    func errorMesssageAlert(
        message: String
    ) {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "확인", style: .default)
        ]

        UIAlertController.present(
            in: self,
            title: message,
            style: .alert,
            actions: actions
        ).subscribe(onNext: { _ in })
        .disposed(by: self.disposeBag)
    }

    func signOutAlert(
        signOutHandler: @escaping (() -> Void)
    ) {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "로그아웃", style: .destructive),
                .action(title: "취소", style: .cancel)
        ]

        UIAlertController.present(
            in: self,
            title: "로그아웃 하시겠습니까?",
            style: .alert,
            actions: actions
        ).subscribe(onNext: { actionIndex in
            if actionIndex == 0 {
                signOutHandler()
            }
        }).disposed(by: self.disposeBag)
    }
    
    func escapeSockseAlert(
        escapeSockseHandler: @escaping (() -> Void)
    ) {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "회원 탈퇴", style: .destructive),
                .action(title: "취소", style: .cancel)
        ]

        UIAlertController.present(
            in: self,
            title: "계정 탈퇴",
            message: """
            
            계정 탈퇴 시 아래 정보를 잃게 되며, 재가입하더라도 삭제된 데이터는 복구되지 않습니다.
            
            • 모든 서비스 이용 내역 삭제
            • 가입한 모든 워크스페이스에서 자동 탈퇴
            
            위 내용을 확인하고, 회원을 탈퇴합니다.
            """,
            style: .alert,
            actions: actions
        ).subscribe(onNext: { actionIndex in
            if actionIndex == 0 {
                escapeSockseHandler()
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func setupDebugging() {
        
        let longPressRecognizer = UILongPressGestureRecognizer()
        self.profileImageCellView.addGestureRecognizer(longPressRecognizer)
        
        longPressRecognizer.rx.event
            .flatMapLatest {_ in Log.extract() }
            .subscribe(onNext: { [weak self] viewController in
                self?.navigationController?.present(viewController, animated: true)
            }, onError: { error in
                Log.err(error.localizedDescription)
            }).disposed(by: self.disposeBag)
    }

}


extension DefaultMyInfoViewController {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
