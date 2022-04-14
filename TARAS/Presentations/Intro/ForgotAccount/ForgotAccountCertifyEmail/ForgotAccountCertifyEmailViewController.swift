//
//  ForgotAccountCertifyEmailViewController.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/31.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class ForgotAccountCertifyEmailViewController: BaseNavigationViewController, ReactorKit.View {
    
    enum Text {
        static let completeCertifyEmailButtonTitle = "확인"
        static let retryCertifyEmailButtonTitle = "재인증"
    }
    
    lazy var forgotAccountCertifyEmailView = ForgotAccountCertifyEmailView()
    
    let confirmButton = SRPButton(Text.completeCertifyEmailButtonTitle).then {
        $0.isEnabled = false
    }
    
    let isConfirmButtonisEnable = PublishRelay<Bool>()
        
    var serialTimer: Disposable?
    
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        self.forgotAccountCertifyEmailView.emailTextFieldBecomeFirstResponse()
    }

    override func setupConstraints() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.forgotAccountCertifyEmailView)
        self.forgotAccountCertifyEmailView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
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
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: - ReactorKit
        
        func bind(reactor: ForgotAccountCertifyEmailViewReactor) {
            
        // Action
        self.forgotAccountCertifyEmailView.email
            .distinctUntilChanged()
            .map { Reactor.Action.checkValidation(email: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.forgotAccountCertifyEmailView.authNumber
            .distinctUntilChanged()
            .map { Reactor.Action.checkEnable(authNumber: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.forgotAccountCertifyEmailView.certifyButtonDidTap
            .withLatestFrom(self.forgotAccountCertifyEmailView.email)
            .map(Reactor.Action.sendAuthNumber)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.confirmButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(self.forgotAccountCertifyEmailView.authNumber)
            .map(Reactor.Action.checkAuthNumber)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isEmailValid }
            .distinctUntilChanged()
            .bind(to: self.forgotAccountCertifyEmailView.isCertifyButtonEnabled)
            .disposed(by: self.disposeBag)
        
        self.forgotAccountCertifyEmailView.email.distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.serialTimer?.dispose()
                self?.forgotAccountCertifyEmailView.clearAuthNumberTextFieldView()
            }).disposed(by: self.disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.isAuthNumberValid }.distinctUntilChanged(),
            self.forgotAccountCertifyEmailView.authNumber.distinctUntilChanged(),
            self.isConfirmButtonisEnable,
            resultSelector: { $0 && !$1.isEmpty && $2 }
        )
        .bind(to: self.confirmButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        // 만료시간 표시
        reactor.state.compactMap { $0.authNumberExpires }
            .distinctUntilChanged()
            .filter { $0 > 0 }
            .subscribe(onNext: { [weak self] expires in
                guard let self = self else { return }
                
                self.forgotAccountCertifyEmailView.authNumberTextFieldBecomeFirstResponse()
                self.forgotAccountCertifyEmailView.clearAuthNumberTextFieldView()
                
                // '확인' 버튼 활성화 조건
                self.isConfirmButtonisEnable.accept(true)
                // 인증번호 입력 텍스트 필드 표시
                self.forgotAccountCertifyEmailView.authNumberTextFieldView.isHidden = false
                // '인증' -> '재인증' 문구 변경
                self.forgotAccountCertifyEmailView.emailTextFieldView.innerButton.setTitle(
                    Text.retryCertifyEmailButtonTitle,
                    for: .normal
                )
                
                self.serialTimer?.dispose()
                self.serialTimer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .map { timer in
                        let remainExpires = TimeInterval(expires - timer)
                        
                        if remainExpires == 0 {
                            self.isConfirmButtonisEnable.accept(false)
                        }
                        
                        if remainExpires < 0 {
                            self.serialTimer?.dispose()
                        }

                        return remainExpires.toTimeString
                    }
                    .bind(to: self.forgotAccountCertifyEmailView.remainExpires)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.findUsername }
            .distinctUntilChanged()
            .map { reactor.reactorForCompleteFindId($0) }
            .subscribe(onNext: { [weak self] reactor in
                self?.serialTimer?.dispose()
                let viewController = CompleteFindIdViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
            
            reactor.state.map { $0.requestToken }
                .distinctUntilChanged()
                .map { reactor.reactorForResetPassword($0) }
                .subscribe(onNext: { [weak self] reactor in
                    self?.serialTimer?.dispose()
                    self?.forgotAccountCertifyEmailView.clearAuthNumberTextFieldView()
                    let viewController = ResetPasswordViewController()
                    viewController.reactor = reactor
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.forgotAccountCertifyEmailView.errorMessage)
            .disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.confirmButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}
