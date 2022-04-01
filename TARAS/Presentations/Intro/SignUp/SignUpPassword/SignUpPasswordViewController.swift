//
//  SignUpPasswordViewController.swift
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

class SignUpPasswordViewController: BaseNavigationViewController, ReactorKit.View {
    
    enum Text {
        static let SUPVC_1 = "다음"
    }
    
    lazy var signUpPasswordView = SignUpPasswordView().then {
        $0.passwordTextFieldsDelegate = self
    }
    
    let nextButton = SRPButton(Text.SUPVC_1).then {
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
    
    func bind(reactor: SignUpPasswordViewReactor) {
        
        // Action
        let password = self.signUpPasswordView.password.distinctUntilChanged()
        let passwordConfirmed = self.signUpPasswordView.passwordConfirmed.distinctUntilChanged()
        
        Observable.combineLatest(password, passwordConfirmed)
            .distinctUntilChanged { $0.0 == $1.0 && $0.1 == $1.1 }
            .map(Reactor.Action.checkPasswordValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.tap
            .withLatestFrom(password)
            .map(reactor.reactorForName)
            .subscribe(onNext: { [weak self] reactorForName in
                let viewController = SignUpNameViewController()
                viewController.reactor = reactorForName
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValid }
            .distinctUntilChanged()
            .bind(to: self.nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .bind(to: self.signUpPasswordView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}

extension SignUpPasswordViewController: SignUpTextFieldDelegate {
    
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
