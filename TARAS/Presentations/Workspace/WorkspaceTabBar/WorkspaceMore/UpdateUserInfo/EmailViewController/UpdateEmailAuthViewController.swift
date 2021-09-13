//
//  UpdateEmailAuthViewController.swift
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

class UpdateEmailAuthViewController: BaseNavigatableViewController, View {
    
    enum Text {
        static let UEA_VC_1 = "인증번호 입력"
        static let UEA_VC_2 = "이메일로 발송된 인증번호를 입력해 주세요."
        static let UEA_VC_3 = "확인"
    }
    
    lazy var codeInputView = SRPInputView(.authCodeView, description: Text.UEA_VC_2).then {
        $0.textView.keyboardType = .numberPad
        $0.textView.srpClearTextViewDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.codeInputView.textView.becomeFirstResponder()
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.UEA_VC_1
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.codeInputView)
        self.codeInputView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        self.backButton.rx.tap
        .subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .filter { $0 > 0 }
            .drive(onNext: { [codeInputView] height in
                codeInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-height)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(reactor: UpdateEmailAuthViewReactor) {
        
        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.setRemainTime }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // '확인' 버튼 활성화
        self.codeInputView.textView.rx.text.orEmpty
            .map { $0.count > 5 && reactor.currentState.isTimeOver == false }
            .bind(to: self.codeInputView.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.codeInputView.textView.rx.text.orEmpty
            .map(Reactor.Action.setAuthCode)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.codeInputView.confirmButton.rx.tap
            .map { Reactor.Action.confirmAuthCode }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.codeInputView.authResendButton.rx.tap
            .map { Reactor.Action.resendAuthCode }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.codeInputView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.remainTimeString }
            .distinctUntilChanged()
            .bind(to: self.codeInputView.remainsLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isCodeConfirmed }
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] reactor in
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}


extension UpdateEmailAuthViewController: SRPClearTextViewDelegate { }
