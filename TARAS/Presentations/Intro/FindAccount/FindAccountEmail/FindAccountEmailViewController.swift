//
//  FindAccountEmailViewController.swift
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

class FindAccountEmailViewController: BaseNavigationViewController, ReactorKit.View {

    enum Text {
        static let FAEVC_1 = "확인"
        static let ReAuthMessage = "인증번호 재전송 완료"
    }
    
    lazy var findAccountView = FindAccountEmailView().then {
        $0.emailTextFieldsDelegate = self
    }
    
    let nextButton = SRPButton(Text.FAEVC_1).then {
        $0.isEnabled = false
    }
    
    let timer: Observable<Int>
    
    
    // MARK: - Init
    
    // Reactor.Action 의 unit test 목적으로 init 을 작성해놓았습니다.
    init(_ timer: Observable<Int> = .interval(.seconds(1), scheduler: MainScheduler.instance)) {
        self.timer = timer
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findAccountView.emailTextFieldBecomeFirstResponse()
    }
    
    override func setupConstraints() {

        self.view.addSubview(self.findAccountView)
        self.findAccountView.snp.makeConstraints {
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
    
    func bind(reactor: FindAccountEmailViewReactor) {
        
        self.timer
            .map {_ in}
            .map { Reactor.Action.tickTime }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // Action
        let email = self.findAccountView.email.distinctUntilChanged()
        let authCode = self.findAccountView.authNumber.distinctUntilChanged()
        let innerButtonTap = self.findAccountView.emailTextFieldView.innerButton.rx.throttleTap(.seconds(3))
        
        email
            .map(Reactor.Action.checkEmailValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        email
            .map {_ in true }
            .bind(to: self.findAccountView.authNumberTextFieldView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        authCode
            .map(Reactor.Action.checkAuthCodeValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        let authReset = Observable.merge(email.map{_ in}, innerButtonTap).share()
        
        authReset
            .map {_ in "" }
            .bind(to: self.findAccountView.authNumberTextFieldView.textField.rx.text)
            .disposed(by: self.disposeBag)
        
        innerButtonTap
            .withLatestFrom(email)
            .map(Reactor.Action.requestAuthNumber)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(Observable.combineLatest(email, authCode))
            .map(Reactor.Action.checkAuthNumber)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValidEmail }
            .distinctUntilChanged()
            .bind(to: self.findAccountView.emailTextFieldView.innerButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.filter { $0.isFirst == false }
            .map { $0.isRequested }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { _ in
                Text.ReAuthMessage.sek.showToast()
            }).disposed(by: self.disposeBag)
        
        let request = reactor.state.map { $0.isRequested }
            .distinctUntilChanged()
            .share()
        
        request
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.findAccountView.toggleAuthButtonTitle()
                self?.findAccountView.authCodeTextFieldBecomeFirstResponse()
            }).disposed(by: self.disposeBag)
        request
            .filter { $0 == true }
            .map { !($0 ?? false) }
            .bind(to: self.findAccountView.authNumberTextFieldView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.remainTime }
            .distinctUntilChanged()
            .map { $0 != nil ? TimeInterval($0!).toTimeString: nil }
            .bind(to: self.findAccountView.remainTime)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isAvailable && $0.remainTime != 0 }
            .distinctUntilChanged()
            .bind(to: self.nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        let authComplete = reactor.state.filter { $0.type == .password }
            .map { $0.isAuthComplete }
            .distinctUntilChanged()
            .filter { $0 == true }
            .share()
            
        authComplete
            .withLatestFrom(email)
            .map(reactor.reactorForPassword)
            .subscribe(onNext: { [weak self] reactorForPassword in
                let viewController = FindAccountPasswordViewController()
                viewController.reactor = reactorForPassword
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    self?.findAccountView.resetInputsWithoutEmail()
                }
                self?.navigationController?.pushViewController(viewController, animated: true)
                CATransaction.commit()
            }).disposed(by: self.disposeBag)
        
        authComplete
            .map {_ in Reactor.Action.resetStates }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.filter { $0.type == .id }
            .map { $0.isAuthComplete }
            .distinctUntilChanged()
            .filter { $0 == true }
            .withLatestFrom(email)
            .map(Reactor.Action.findId)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.filter { $0.type == .id }
            .compactMap { $0.findIds }
            .distinctUntilChanged()
            .map(reactor.reactorForIdResult)
            .subscribe(onNext: { [weak self] reactor in
                let viewController = FindAccountIdResultViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.findAccountView.errorMessageLabel.rx.text)
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

extension FindAccountEmailViewController: SignUpTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {
        let text = sender.text ?? ""
        if sender == self.findAccountView.emailTextFieldView.textField {
            // email이 5자 이상일 때만 '인증' 버튼 탭
            if InputPolicy.email.matchFormat(text) {
                guard let reactor = self.reactor else { return }
                if let _ = reactor.currentState.isRequested {
                    self.findAccountView.authCodeTextFieldBecomeFirstResponse()
                }else{
                    self.findAccountView.emailTextFieldView.innerButton.sendActions(for: .touchUpInside)
                }
            }
        }
    }
}

