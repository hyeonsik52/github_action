//
//  UpdateEmailViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/24.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import RxKeyboard

class UpdateEmailViewController: BaseNavigationViewController, View {
    
    enum Text {
        static let SU_ID_VC_1 = "이메일 입력"
        static let SU_ID_VC_2 = "이메일 주소를 입력해주세요."
        static let SU_ID_VC_3 = "인증 메일 발송"
    }
    
    lazy var emailInputView = SRPInputView(description: Text.SU_ID_VC_2).then {
        $0.textView.autocapitalizationType = .none
        $0.textView.keyboardType = .emailAddress
        $0.textView.srpClearTextViewDelegate = self
    }
    
    
    // MARK: - Life Cycles
    
    override func setupConstraints() {
        self.view.addSubview(self.emailInputView)
        self.emailInputView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.emailInputView.textView.becomeFirstResponder()
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = Text.SU_ID_VC_1
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.setLeftBarButton(self.backButton, animated: true)
    }

    override func bind() {
        // '뒤로가기' 버튼 액션
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        // 리턴키 교체
        self.emailInputView.textView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.emailInputView.textView.returnKeyType = text.count < 1 ? .default : .done
            self.emailInputView.textView.reloadInputViews()
        }).disposed(by: self.disposeBag)
        
        // '확인' 버튼 enable
        self.emailInputView.textView.rx.text.orEmpty
            .map { $0.count > 0 }
            .bind(to: self.emailInputView.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [emailInputView] keyboardVisibleHeight in
                emailInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-keyboardVisibleHeight)
                }
            }).disposed(by: self.disposeBag)
    }
    
    
    // MARK: - ReactorKit
    
    func bind(reactor: UpdateEmailViewReactor) {
        self.emailInputView.textView.placeholder = reactor.placeholder
        
        if reactor.email.count > 0 {
            self.emailInputView.textView.text = reactor.email
        }
        
        self.emailInputView.textView.rx.text.orEmpty
            .map(Reactor.Action.setEmail)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.emailInputView.confirmButton.rx.tap
            .map { Reactor.Action.confirmEmail }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isEmailConfirmed }
            .filter { $0 == true }
            .map { _ in reactor.reactorForEmailAuth() }
            .subscribe(onNext: { [weak self] nextReactor in
                guard let self = self else { return }
                let viewController = UpdateEmailAuthViewController()
                viewController.reactor = nextReactor
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .bind(to: self.emailInputView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}


extension UpdateEmailViewController: SRPClearTextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            if textView.returnKeyType == .done {
                self.emailInputView.confirmButton.sendActions(for: .touchUpInside)
            }
            return false
        }
        return true
    }
}
