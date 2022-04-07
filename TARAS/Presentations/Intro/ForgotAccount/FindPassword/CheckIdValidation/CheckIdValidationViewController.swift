//
//  CheckIdValidationViewController.swift
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

class CheckIdValidationViewController: BaseNavigationViewController, ReactorKit.View {
    
    enum Text {
        static let SUVC_1 = "다음"
    }
    
    lazy var checkIdValidationView = CheckIdValidationView().then {
        $0.idTextFieldViewDelegate = self
    }
    
    let toCertifyEmailButton = SRPButton(Text.SUVC_1).then {
        $0.isEnabled = false
    }
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.checkIdValidationView.idTextFieldBecomeFirstResponse()
        
        self.checkIdValidationView.idTextFieldView.textField.text = reactor?.id
    }
    
    override func bind() {
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    override func setupConstraints() {

        self.view.addSubview(self.checkIdValidationView)
        self.checkIdValidationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.toCertifyEmailButton)
        self.toCertifyEmailButton.snp.makeConstraints {
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
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    // MARK: - ReactorKit
    
    func bind(reactor: CheckIdValidationViewReactor) {
        
        // Action
        self.checkIdValidationView.id
            .distinctUntilChanged()
            .map { Reactor.Action.checkValidation(id: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.toCertifyEmailButton.rx.throttleTap(.seconds(3))
            .withLatestFrom(self.checkIdValidationView.id)
            .map(Reactor.Action.checkRegistration)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValid }
            .distinctUntilChanged()
            .bind(to: self.toCertifyEmailButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isAvailable}
            .distinctUntilChanged()
            .filter { $0 == true }
            .withLatestFrom(self.checkIdValidationView.id)
            .map { reactor.reactorForCertifyEmail($0) }
            .subscribe(onNext: { [weak self] reactor in
                let viewController = ForgotAccountCertifyEmailViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.checkIdValidationView.errorMessage)
            .disposed(by: self.disposeBag)
    }
    
    override func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        super.updatedKeyboard(withoutBottomSafeInset: height)
        
        let margin = height+12
        self.toCertifyEmailButton.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-margin)
        }
    }
}

extension CheckIdValidationViewController: ForgotAccountTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {
        
        if self.toCertifyEmailButton.isEnabled {
            self.toCertifyEmailButton.sendActions(for: .touchUpInside)
        }
    }
}
