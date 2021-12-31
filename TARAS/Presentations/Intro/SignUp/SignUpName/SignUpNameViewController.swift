//
//  SignUpNameViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class SignUpNameViewController: BaseNavigationViewController, ReactorKit.View {

    enum Text {
        static let SUNVC_1 = "회원가입 완료"
    }
    
    lazy var signUpView = SignUpNameView().then {
        $0.nameTextFieldsDelegate = self
    }
    
    let confirmButton = SRPButton(Text.SUNVC_1).then {
        $0.isEnabled = false
    }
    

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpView.nameTextFieldBecomeFirstResponse()
    }
    
    override func setupConstraints() {

        self.view.addSubview(self.signUpView)
        self.signUpView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    
    // MARK: - ReactorKit
    
    func bind(reactor: SignUpNameViewReactor) {
        
        // Action
        self.signUpView.name
            .distinctUntilChanged()
            .map(Reactor.Action.checkValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.confirmButton.rx.tap
            .withLatestFrom(self.signUpView.name)
            .map(Reactor.Action.signUp)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // State
        reactor.state.map { $0.isValid }
            .distinctUntilChanged()
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.signUpView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isSignUp }
            .distinctUntilChanged()
            .filter { $0 == true }
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                self?.view.endEditing(true)
                return UIAlertController.show(
                    .alert,
                    title: "회원가입 완료",
                    message: "이메일 또는 전화번호 인증을 완료한 경우에만 계정 찾기가 가능합니다. 인증을 진행하시겠습니까?",
                    items: [
                        .init(title: "다음에 하기", style: .cancel),
                        .init(title: "인증하기", style: .default)
                    ],
                    usingCancel: false
                ).map { $0.0 == 1 }
            }.map(Reactor.Action.login)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isLogin)
            .distinctUntilChanged({ $0?.0 == $1?.0 && $0?.1 == $1?.1 })
            .subscribe(onNext: { [weak self] result in
                guard let result = result else { return }
                if result.0 == true {
                    //워크스페이스 목록
                    let viewController = WorkspaceListViewController()
                    viewController.reactor = reactor.reactorForWorkspaceList()
                    let navigationController = BaseNavigationController(rootViewController: viewController)
                    
                    if result.1 == true {
                        //인증으로 연결 시 설정 페이지도 푸시
                        let settingViewController = DefaultMyInfoViewController()
                        settingViewController.reactor = reactor.reactorForSetting()
                        navigationController.pushViewController(settingViewController, animated: false)
                    }
                    
                    self?.view.window?.rootViewController = navigationController
                } else {
                    //로그인 페이지
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }).disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.confirmButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}

extension SignUpNameViewController: SignUpTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {
        
        if self.confirmButton.isEnabled {
            self.confirmButton.sendActions(for: .touchUpInside)
        }
    }
}
