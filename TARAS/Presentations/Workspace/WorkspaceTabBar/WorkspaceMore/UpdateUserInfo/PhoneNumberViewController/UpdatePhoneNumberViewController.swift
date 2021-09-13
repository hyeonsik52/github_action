//
//  UpdatePhoneNumberViewController.swift
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

class UpdatePhoneNumberViewController: BaseNavigatableViewController, View {
    
    enum Text {
        static let UPN_VC_1 = "전화번호 변경"
        static let UPN_VC_2 = "전화번호를 입력해 주세요."
        static let UPN_VC_3 = "확인"
    }
    
    lazy var phoneNumberInputView = SRPInputView(.defaultView, description: Text.UPN_VC_2).then {
        $0.textView.keyboardType = .numberPad
        $0.textView.srpClearTextViewDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.phoneNumberInputView.textView.becomeFirstResponder()
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.UPN_VC_1
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.phoneNumberInputView)
        self.phoneNumberInputView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: UpdatePhoneNumberViewReactor) {
        
        //placeholder
        self.phoneNumberInputView.textView.placeholder = try? reactor.initialState.result?.get()
        
        //Action
        self.phoneNumberInputView.confirmButton.rx.tap
            .withLatestFrom(self.phoneNumberInputView.textView.rx.text.orEmpty)
            .map { Reactor.Action.update(phoneNumber: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)

        self.phoneNumberInputView.textView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: self.phoneNumberInputView.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        RxKeyboard.instance.visibleHeight.skip(1)
            .drive(onNext: { [phoneNumberInputView] height in
                phoneNumberInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-height)
                }
            })
            .disposed(by: self.disposeBag)

        self.phoneNumberInputView.textView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.phoneNumberInputView.textView.returnKeyType = (text.isEmpty ? .default: .done)
                self?.phoneNumberInputView.textView.reloadInputViews()
                self?.phoneNumberInputView.errorMessageLabel.text = nil
            })
            .disposed(by: self.disposeBag)

        //State
        reactor.state.compactMap {
            guard case .failure(let error) = $0.result else { return nil }
            return error.errorMessage
        }
        .bind(to: self.phoneNumberInputView.errorMessageLabel.rx.text)
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .queueing(2)
            .filter { $0[0] == true && $0[1] == false }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}


extension UpdatePhoneNumberViewController: SRPClearTextViewDelegate { }
