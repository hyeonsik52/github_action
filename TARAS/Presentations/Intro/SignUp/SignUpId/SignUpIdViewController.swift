//
//  SignUpIdViewController.swift
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

class SignUpIdViewController: BaseNavigationViewController, ReactorKit.View {

    enum Text {
        static let SUVC_1 = "다음"
    }
    
    lazy var signUpView = SignUpIdView().then {
        $0.idTextFieldDelegate = self
    }
    
    let nextButton = SRPButton(Text.SUVC_1).then {
        $0.isEnabled = false
    }
    

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpView.textFieldBecomeFirstResponse()
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
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    
    // MARK: - ReactorKit
    
    func bind(reactor: SignUpIdViewReactor) {
        
        // Action
        self.signUpView.id
            .distinctUntilChanged()
            .map{ Reactor.Action.checkValidation(id: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.signUpView.duplicateCheckButtonDidTap
            .withLatestFrom(self.signUpView.id)
            .map(Reactor.Action.checkDuplication)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // 화면 전환
        self.nextButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(self.signUpView.id)
            .map(reactor.reactorForPassword)
            .subscribe(onNext: { [weak self] reactorForPassword in
                let viewController = SignUpPasswordViewController()
                viewController.reactor = reactorForPassword
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValid }
            .distinctUntilChanged()
            .bind(to: self.signUpView.isDuplicateCheckButtonEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isAvailable }
            .distinctUntilChanged()
            .bind(to: self.nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.message?.color ?? .redEB4D39 }
            .distinctUntilChanged()
            .bind(to: self.signUpView.errorMessageLabel.rx.textColor)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.message?.message }
            .distinctUntilChanged()
            .bind(to: self.signUpView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
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

extension SignUpIdViewController: SignUpTextFieldDelegate {
    
    // id Textfield keyboard 의 return key 액션 정의
    func textFieldShouldReturn(_ sender: UITextField) {
        
        if sender == self.signUpView.idTextFieldView.textField {
            // id가 5자 이상일 때만 '아이디 중복 확인' 버튼 탭
            if self.signUpView.idTextFieldView.innerButton.isEnabled {
                self.signUpView.idTextFieldView.innerButton.sendActions(for: .touchUpInside)
            }
        }
    }
}
