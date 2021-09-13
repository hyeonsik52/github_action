//
//  FindAccountIdViewController.swift
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

class FindAccountIdViewController: BaseNavigatableViewController, ReactorKit.View {

    enum Text {
        static let FAIVC_1 = "다음"
    }
    
    lazy var findAccountView = FindAccountIdView().then {
        $0.idTextFieldsDelegate = self
    }
    
    let nextButton = SRPButton(Text.FAIVC_1).then {
        $0.isEnabled = false
    }
    

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findAccountView.idTextFieldBecomeFirstResponse()
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
    
    func bind(reactor: FindAccountIdViewReactor) {
        
        // Action
        self.findAccountView.id
            .distinctUntilChanged()
            .map(Reactor.Action.checkValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.tap
            .withLatestFrom(self.findAccountView.id)
            .map(Reactor.Action.checkRegister)
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
            .bind(to: self.findAccountView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isRegister }
            .distinctUntilChanged()
            .filter { $0 == true }
            .withLatestFrom(self.findAccountView.id)
            .map(reactor.reactorForEmail)
            .subscribe(onNext: { [weak self] reactorForEmail in
                let viewController = FindAccountEmailViewController()
                viewController.reactor = reactorForEmail
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

extension FindAccountIdViewController: SignUpTextFieldDelegate {
    
    func textFieldShouldReturn(_ sender: UITextField) {
        
        if self.nextButton.isEnabled {
            self.nextButton.sendActions(for: .touchUpInside)
        }
    }
}
