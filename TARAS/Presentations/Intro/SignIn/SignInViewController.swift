//
//  SignInViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

/// 로그인 화면
class SignInViewController: BaseNavigationViewController, ReactorKit.View {
    
    override var activityIndicatorPosition: Position {
        return .init(anchor: .init(vertical: .top), offset: .init(x: 0, y: 40))
    }
    
    lazy var signInView = SignInView().then {
        $0.idTextFieldView.textField.delegate = self
        $0.passwordTextFieldView.textField.delegate = self
    }

    // MARK: - Life Cycles

    override func setupConstraints() {
        self.view.addSubview(self.signInView)
        self.signInView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(64)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }


    // MARK: - ReactorKit

    func bind(reactor: SignInViewReactor) {
        
        // Action
        let id = self.signInView.idTextFieldView.textField.rx.text.orEmpty.distinctUntilChanged()
        let password = self.signInView.passwordTextFieldView.textField.rx.text.orEmpty.distinctUntilChanged()
        
        Observable.combineLatest(id, password)
            .map(Reactor.Action.checkValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // 로그인
        signInView.signInButton.rx.tap
            .withLatestFrom(Observable.combineLatest(id, password))
            .map { Reactor.Action.signIn(id: $0, password: $1) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
//        self.signInView.findAccountButton.rx.tap
//            .flatMapLatest {
//                UIAlertController.show(
//                    .actionSheet,
//                    title: "아이디 찾기",
//                    items: [
//                        "전화번호로 아이디 찾기",
//                        "이메일로 아이디 찾기"
//                    ]
//                )
//            }.subscribe(onNext: { [weak self] selected, _ in
//                if selected == 0 {
//                    //아이디-전화번호
//                } else {
//                    //아이디-이메일
//                }
//            }).disposed(by: self.disposeBag)
//
//        self.signInView.resetPasswordButton.rx.tap
//            .flatMapLatest {
//                UIAlertController.show(
//                    .actionSheet,
//                    title: "비밀번호 재설정",
//                    items: [
//                        "전화번호로 비밀번호 재설정",
//                        "이메일로 비밀번호 재설정"
//                    ]
//                )
//            }.subscribe(onNext: { [weak self] selected, _ in
//                if selected == 0 {
//                    //비밀번호-전화번호
//                } else {
//                    //비밀번호-이메일
//                }
//            }).disposed(by: self.disposeBag)

        // 회원가입
        signInView.signUpButton.rx.tap
            .map { _ in reactor.reactorForSignUp() }
            .subscribe(onNext: { [weak self] reactor in
                let viewController = SignUpIdViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        
        // State
        // indicator 활성화
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)

        // 로그인 성공 시, 워크스페이스 목록으로 이동
        reactor.state.compactMap { $0.isSignIn }
            .distinctUntilChanged()
            .map { _ in reactor.reactorForWorkspaceList() }
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                let viewController = WorkspaceListViewController()
                viewController.reactor = reactor
                let navigationController = BaseNavigationController(rootViewController: viewController)
                self.view.window?.rootViewController = navigationController
            }).disposed(by: self.disposeBag)

        // 로그인 시도 시, 에러가 있다면 에러 메시지 표출
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: signInView.warningLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isValid }
            .bind(to: self.signInView.signInButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Custom Methods

    func forgotAccountAlert(
        idHandler: @escaping (() -> Void),
        passwordHandler: @escaping (() -> Void)
    ) {
        let actions: [UIAlertController.AlertAction] = [
                .action(title: "아이디 찾기", style: .default),
                .action(title: "비밀번호 찾기", style: .default),
                .action(title: "취소", style: .cancel)
        ]

        UIAlertController.present(
            in: self,
            title: "아이디 · 비밀번호 찾기",
            style: .actionSheet,
            actions: actions
        ).subscribe(onNext: { actionIndex in
            if actionIndex == 0 {
                idHandler()
            } else if actionIndex == 1 {
                passwordHandler()
            }
        }).disposed(by: self.disposeBag)
    }
}


// MARK: - UITextField Delegate

extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.signInView.idTextFieldView.textField {
            self.signInView.passwordTextFieldView.textField.becomeFirstResponder()
        } else {
            // 로그인 통신
            let signInButton = self.signInView.signInButton
            if signInButton.isEnabled {
                self.signInView.signInButton.sendActions(for: .touchUpInside)
            }
            
            self.view.endEditing(true)
        }
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let policy: InputPolicy = (textField == self.signInView.idTextFieldView.textField ? .id: .password)
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: policy)
    }
}
