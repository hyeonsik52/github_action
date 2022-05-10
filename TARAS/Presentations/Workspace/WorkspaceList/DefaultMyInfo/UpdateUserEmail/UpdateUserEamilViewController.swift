//
//  UpdateUserEamilViewController.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/29.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class UpdateUserEmailViewController: BaseNavigationViewController, ReactorKit.View {
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    enum Text {
        static let completeCertifyEmailButtonTitle = "확인"
        static let retryCertifyEmailButtonTitle = "재인증"
    }
    
    lazy var certifyEmailView = CertifyEmailView()
    
    let confirmButton = SRPButton(Text.completeCertifyEmailButtonTitle).then {
        $0.isEnabled = false
    }
    
    var serialTimer: Disposable?
    
    
    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        self.certifyEmailView.emailTextFieldBecomeFirstResponse()
    }

    override func setupConstraints() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.certifyEmailView)
        self.certifyEmailView.snp.makeConstraints {
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
    
    
    // MARK: - RractorKit
    
    func bind(reactor: UpdateUserEmailViewReactor) {
        
        // Action
        self.certifyEmailView.email
            .distinctUntilChanged()
            .map { Reactor.Action.checkValidation(email: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.certifyEmailView.authNumber
            .distinctUntilChanged()
            .map { Reactor.Action.checkEnable(authNumber: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.certifyEmailView.certifyButtonDidTap
            .withLatestFrom(self.certifyEmailView.email)
            .map(Reactor.Action.sendAuthNumber)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.confirmButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(self.certifyEmailView.authNumber)
            .map(Reactor.Action.checkAuthNumber)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isEmailValid }
            .distinctUntilChanged()
            .bind(to: self.certifyEmailView.isCertifyButtonEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isEmailEdited }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.serialTimer?.dispose()
                self?.certifyEmailView.clearAuthNumberTextFieldView()
            }).disposed(by: self.disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.isAuthNumberValid }.distinctUntilChanged(),
            self.certifyEmailView.remainExpires,
            resultSelector: { $0 && $1 != "00:00" }
        )
        .bind(to: self.confirmButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        // 만료시간 표시
        reactor.state.map { $0.authNumberExpires }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] expires in
                guard let self = self, let expires = expires else { return }
                
                self.certifyEmailView.authNumberTextFieldBecomeFirstResponse()
                self.certifyEmailView.clearAuthNumberTextFieldView()
                
                // 인증번호 입력 텍스트 필드 표시
                self.certifyEmailView.authNumberTextFieldView.isHidden = false
                // '인증' -> '재인증' 문구 변경
                self.certifyEmailView.emailTextFieldView.innerButton.setTitle(
                    Text.retryCertifyEmailButtonTitle,
                    for: .normal
                )
                
                self.serialTimer?.dispose()
                self.serialTimer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .startWith(0)
                    .map { _ in
                        if expires.timeIntervalSinceNow <= 0.0 {
                            return "00:00"
                        }
                        
                        return expires.timeIntervalSinceNow.toTimeString
                    }
                    .bind(to: self.certifyEmailView.remainExpires)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isUpdateUserEmail }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.certifyEmailView.errorMessage)
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
