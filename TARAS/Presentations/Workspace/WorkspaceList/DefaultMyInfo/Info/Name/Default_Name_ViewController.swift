//
//  Default_Name_ViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/31.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import RxKeyboard

class Default_Name_ViewController: BaseNavigationViewController, View {

    enum Text {
        static let UN_VC_1 = "사용자 이름 설정"
        static let UN_VC_2 = "이름을 입력해주세요. (1~20자)"
        static let UN_VC_3 = "확인"
    }
    
    private lazy var nameInputView = SRPInputView(.defaultView, description: Text.UN_VC_2).then {
        $0.textView.srpClearTextViewDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.nameInputView.textView.becomeFirstResponder()
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = Text.UN_VC_1

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }

    override func setupConstraints() {
        super.setupConstraints()

        self.view.addSubview(self.nameInputView)
        self.nameInputView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func bind() {
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        self.nameInputView.textView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: self.nameInputView.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        RxKeyboard.instance.visibleHeight.skip(1)
            .drive(onNext: { [nameInputView] height in
                nameInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-height)
                }
            })
            .disposed(by: self.disposeBag)
    }

    func bind(reactor: Default_Name_ViewReactor) {

        //placeholder
        self.nameInputView.textView.placeholder = reactor.placeholder

        //Action
        self.nameInputView.confirmButton.rx.tap
            .withLatestFrom(self.nameInputView.textView.rx.text.orEmpty)
            .map(Reactor.Action.setName)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nameInputView.textView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.nameInputView.textView.returnKeyType = (text.isEmpty ? .default : .done)
                self?.nameInputView.textView.reloadInputViews()
                self?.nameInputView.errorMessageLabel.text = nil
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.nameInputView.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.updatedName }
            .filter { $0.count > 0}
            .subscribe(onNext: { [weak self] name in
                // 변경된 이름이 표출되어야하는 탭바 내 타 화면 갱신
                if let navigationController = self?.tabBarController?.viewControllers?.first as? UINavigationController,
                   let homeViewController = navigationController.viewControllers.first as? WorkspaceHomeViewController {
                    homeViewController.reactor?.action.onNext(.loadMyInfo)
                }
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
}

extension Default_Name_ViewController: SRPClearTextViewDelegate {

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        
        if text == "\n" {
            if textView.returnKeyType == .done {
                self.nameInputView.confirmButton.sendActions(for: .touchUpInside)
            }
            return false
        }
        return true
    }
}
