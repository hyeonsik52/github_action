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

class SignUpNameViewController: BaseNavigatableViewController, ReactorKit.View {

    enum Text {
        static let SUNVC_1 = "다음"
    }
    
    lazy var signUpView = SignUpNameView().then {
        $0.nameTextFieldsDelegate = self
    }
    
    let nextButton = TRSButton(Text.SUNVC_1).then {
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
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
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
        
        self.nextButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(self.signUpView.name)
            .map(Reactor.Action.signUp)
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
        
        //오류메시지 필드 필요
//        reactor.state.map { $0.errorMessage }
//            .distinctUntilChanged()
//            .bind(to: self.signUpView.errorMessageLabel.rx.text)
//            .disposed(by: self.disposeBag)
//
        reactor.state.map { $0.isSignUp }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                let viewController = SignUpCompleteViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        // 화면 전환
//        self.nextButton.rx.tap
//            .withLatestFrom(self.signUpView.name)
//            .map(reactor.reactorForEmail)
//            .subscribe(onNext: { [weak self] reactorForEmail in
//                let viewController = SignUpEmailViewController()
//                viewController.reactor = reactorForEmail
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            }).disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.nextButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}

extension SignUpNameViewController: SignUpTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {
        
        if self.nextButton.isEnabled {
            self.nextButton.sendActions(for: .touchUpInside)
        }
    }
}
