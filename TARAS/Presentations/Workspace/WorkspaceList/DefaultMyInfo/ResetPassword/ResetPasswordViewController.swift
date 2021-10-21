//
//  ResetPasswordViewController.swift
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

class ResetPasswordViewController: BaseNavigatableViewController, ReactorKit.View {

    enum Text {
        static let RPVC_1 = "다음"
    }
    
    lazy var passwordView = ResetPasswordView().then {
        $0.passwordTextFieldsDelegate = self
    }
    
    let nextButton = SRPButton(Text.RPVC_1).then {
        $0.isEnabled = false
    }
    

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordView.passwordTextFieldBecomeFirstResponse()
    }
    
    override func setupConstraints() {

        self.view.addSubview(self.passwordView)
        self.passwordView.snp.makeConstraints {
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
    
    func bind(reactor: ResetPasswordViewReactor) {
        
        // Action
        self.passwordView.password
            .distinctUntilChanged()
            .map(Reactor.Action.checkValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.throttleTap
            .withLatestFrom(self.passwordView.password)
            .map(Reactor.Action.requestAuth)
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
            .bind(to: self.passwordView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isAuthComplete }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map {_ in reactor.reactorForPassword() }
            .subscribe(onNext: { [weak self] reactor in
                let viewController = FindAccountPasswordViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
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

extension ResetPasswordViewController: SignUpTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {
        
        if self.nextButton.isEnabled {
            self.nextButton.sendActions(for: .touchUpInside)
        }
    }
}
