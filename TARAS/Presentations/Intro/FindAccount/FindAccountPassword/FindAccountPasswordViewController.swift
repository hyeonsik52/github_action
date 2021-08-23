//
//  FindAccountPasswordViewController.swift
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

class FindAccountPasswordViewController: BaseNavigatableViewController, ReactorKit.View {
    
    enum Text {
        static let FAPVC_1 = "다음"
        static let FAPVC_2 = "확인"
        static let ResetCompleted = "비밀번호 변경 완료"
    }
    
    lazy var signUpPasswordView = FindAccountPasswordView().then {
        $0.passwordTextFieldsDelegate = self
    }
    
    let nextButton = TRSButton("").then {
        $0.isEnabled = false
    }
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpPasswordView.passwordTextFieldBecomeFirstResponse()
    }

    override func setupConstraints() {
        
        self.view.addSubview(self.signUpPasswordView)
        self.signUpPasswordView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    
    // MARK: - ReactorKit
    
    func bind(reactor: FindAccountPasswordViewReactor) {
        
        let buttonTitle: String = {
            switch reactor.initialState.type {
            case .findAccount:
                return Text.FAPVC_1
            case .setting:
                return Text.FAPVC_2
            }
        }()
        self.nextButton.setTitle(buttonTitle, for: .normal)
        
        // Action
        let password = self.signUpPasswordView.password.distinctUntilChanged()
        let passwordConfirmed = self.signUpPasswordView.passwordConfirmed.distinctUntilChanged()
        
        let combine = Observable.combineLatest(password, passwordConfirmed)
        
        combine
            .distinctUntilChanged { $0.0 == $1.0 }
            .map(Reactor.Action.checkPasswordValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        combine
            .distinctUntilChanged { $0.1 == $1.1 }
            .map(Reactor.Action.checkConfirmValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(password)
            .map(Reactor.Action.resetPassword)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValid }
            .distinctUntilChanged()
            .bind(to: self.nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .bind(to: self.signUpPasswordView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.filter { $0.type == .findAccount }
            .map { $0.isReset }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                let viewController = FindAccountPasswordCompleteViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.filter { $0.type == .setting }
            .map { $0.isReset }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                Text.ResetCompleted.sek.showToast()
                self?.navigationController?.popToViewController(SettingViewController.self, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}

extension FindAccountPasswordViewController: SignUpTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {

        if sender.returnKeyType == .next {
            self.signUpPasswordView.passwordConfirmTextFieldBecomeFirstResponse()
        } else {
            if self.nextButton.isEnabled {
                self.nextButton.sendActions(for: .touchUpInside)
            }
        }
    }
}
