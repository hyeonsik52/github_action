//
//  Default_PhoneNumber_ViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import RxKeyboard
import ReactorKit

class Default_PhoneNumber_ViewController: BaseNavigatableViewController, ReactorKit.View {
    
    enum Text {
        static let SU_ID_VC_1 = "전화번호 입력"
        static let SU_ID_VC_2 = "SMS 수신이 가능한 번호로만 아이디·비밀번호 찾기를 할 수 있습니다."
        static let SU_ID_VC_3 = "확인"
    }
    
    lazy var phoneNumberInputView = SRPInputView(description: Text.SU_ID_VC_2).then {
        $0.textView.keyboardType = .numberPad
        $0.textView.srpClearTextViewDelegate = self
    }
    
    
    // MARK: - Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.phoneNumberInputView.textView.becomeFirstResponder()
    }
    
    override func setupConstraints() {
        self.view.addSubview(self.phoneNumberInputView)
        self.phoneNumberInputView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(38)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [phoneNumberInputView] keyboardHeight in
                let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
                let margin = (keyboardHeight == 0) ? -(keyboardHeight + tabBarHeight): -(keyboardHeight)
                
                phoneNumberInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(margin)
                }
            }).disposed(by: self.disposeBag)
    }
    
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.SU_ID_VC_1
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: - ReactorKit
    
    func bind(reactor: Default_PhoneNumber_ViewReactor) {
        self.phoneNumberInputView.textView.placeholder = reactor.placeholder
        
        self.phoneNumberInputView.textView.rx.text.orEmpty
            .map(Reactor.Action.setPhoneNumber)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.phoneNumberInputView.confirmButton.rx.tap
            .map { Reactor.Action.confirmPhoneNumber }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.phoneNumberInputView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isPhoneNumberConfirmed }
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                let toastMessage = "전화번호가 재설정 되었습니다."
                toastMessage.sek.showToast()
                
                if let viewControllers = self?.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if let targetViewController = viewController as? DefaultMyInfoViewController {
                            self?.navigationController?.popToViewController(targetViewController, animated: true)
                        }
                    }
                }
            }).disposed(by: self.disposeBag)
    } 
}


extension Default_PhoneNumber_ViewController: SRPClearTextViewDelegate { }
