//
//  Default_PWReset_ViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/31.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import RxKeyboard

class Default_PWReset_ViewController: BaseNavigatableViewController, View {
    
    private lazy var pwInputView = SRPInputView(
        description: "8~16자의 영문 대 소문자, 숫자, 특수문자 조합으로 설정해주세요."
    ).then {
        $0.textView.srpClearTextViewDelegate = self
        $0.textView.autocapitalizationType = .none
    }
    
    var originalPasswordText: String?
    
    
    // MARK: - Life cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pwInputView.textView.becomeFirstResponder()
    }
    
    override func setupConstraints() {
        self.view.addSubview(self.pwInputView)
        self.pwInputView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "비밀번호 재설정"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        self.pwInputView.textView.rx.text.orEmpty
            .map { [weak self] _ -> Bool in
                guard let self = self, let pw = self.originalPasswordText else { return false }
                return pw.matches(Regex.password)
        }.bind(to: self.pwInputView.confirmButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        self.pwInputView.textView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.pwInputView.textView.returnKeyType = text.count < 8 ? .default : .done
            self.pwInputView.textView.reloadInputViews()
        }).disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .filter { $0 > 0 }
            .drive(onNext: { [pwInputView] visibleHeight in
                pwInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-visibleHeight)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func bind(reactor: Default_PWReset_ViewReactor) {
        self.pwInputView.textView.rx.text.orEmpty
            .compactMap { [weak self] _ in self?.originalPasswordText }
            .map(Reactor.Action.setPW)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.pwInputView.confirmButton.rx.tap
            .map { reactor.reactorForConfirmPW() }
            .subscribe(onNext: { [weak self] reactor in
                let viewController = Default_PWConfirm_ViewController()
                viewController.reactor = reactor
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.errorMessage }
            .bind(to: self.pwInputView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}


extension Default_PWReset_ViewController: SRPClearTextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        
        if text == "\n" {
            if textView.returnKeyType == .done {
                self.pwInputView.confirmButton.sendActions(for: .touchUpInside)
            }
            return false
        }
        
        // secureTextEntry
        self.originalPasswordText = ((originalPasswordText ?? "") as NSString).replacingCharacters(in: range, with: text)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.pwInputView.textView.text = String(repeating: "•", count: (textView.text ?? "").count)
    }
}
