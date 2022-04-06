//
//  ResetPasswordViewController.swift
//  TARAS
//
//  Created by 오현식 on 2022/04/05.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class ResetPasswordViewController: BaseNavigationViewController, ReactorKit.View {
    
    enum Text {
        static let SUVC_1 = "다음"
    }
    
    lazy var resetPasswordView = ResetPasswordView().then {
        $0.passwordTextFieldsDelegate = self
    }
    
    let toCompleteResetPasswordButton = SRPButton(Text.SUVC_1).then {
        $0.isEnabled = false
    }
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetPasswordView.passwordTextFieldBecomeFirstResponse()
    }
    
    override func setupConstraints() {

        self.view.addSubview(self.resetPasswordView)
        self.resetPasswordView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.toCompleteResetPasswordButton)
        self.toCompleteResetPasswordButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: - ReactorKit
    
    func bind(reactor: ResetPasswordViewReactor) {

        //Action
        let password = self.resetPasswordView.password.distinctUntilChanged()
        let passwordConfirmed = self.resetPasswordView.passwordConfirmed.distinctUntilChanged()
        
        Observable.combineLatest(password, passwordConfirmed)
            .distinctUntilChanged { $0.0 == $1.0 && $0.1 == $1.1 }
            .map(Reactor.Action.checkPasswordValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.toCompleteResetPasswordButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(self.resetPasswordView.password)
            .map(Reactor.Action.updatePassword)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValid }
            .distinctUntilChanged()
            .bind(to: self.toCompleteResetPasswordButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isUpdate }
            .distinctUntilChanged()
            .filter { $0 == true }
            .withLatestFrom(password)
            .map(reactor.reactorForCompleteResetPassword)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = CompleteResetPasswordViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.resetPasswordView.errorMessage)
            .disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.toCompleteResetPasswordButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}

extension ResetPasswordViewController: ForgotAccountTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {

        if sender.returnKeyType == .next{
            self.resetPasswordView.passwordConfirmTextFieldBecomeFirstResponse()
        } else {
            if self.toCompleteResetPasswordButton.isEnabled {
                self.toCompleteResetPasswordButton.sendActions(for: .touchUpInside)
            }
        }
    }
}
