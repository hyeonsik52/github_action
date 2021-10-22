//
//  CSUMessageViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxKeyboard

class CSUMessageViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var csuDelegate: CSUDelegate?
    
    
    // MARK: - UI
    
    lazy var closeButton = UIBarButtonItem(
        image: UIImage(named: "navi-close"),
        style: .done,
        target: self,
        action: nil
    )
    
    lazy var messageInputView = SRPInputView(
        description: "추가 요청 사항을 입력해주세요.",
        buttonTitle: "확인"
    ).then {
        $0.textView.placeholder = "ex) 조심히 실어주세요."
        $0.textView.srpClearTextViewDelegate = self
    }

    
    // MARK: - Life cycles

    override func setupConstraints() {
        self.view.addSubview(self.messageInputView)
        self.messageInputView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.messageInputView.textView.becomeFirstResponder()
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = "요청사항 입력"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.setLeftBarButton(self.closeButton, animated: true)
    }


    // MARK: - ReactorKit

    func bind(reactor: CSUMessageViewReactor) {
        self.messageInputView.textView.text = reactor.serviceUnitModel.serviceUnit.message ?? ""
        
        self.messageInputView.textView.rx.text.orEmpty
            .map { Reactor.Action.setMessage($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.messageInputView.confirmButton.rx.tap
            .map { _ in self.messageInputView.textView.text }
            .subscribe(onNext: { [weak self] message in
                reactor.serviceUnitModel.serviceUnit.message = message
                
                self?.csuDelegate?.didUpdate(reactor.serviceUnitModel)
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .filter { $0 > 0 }
            .drive(onNext: { [messageInputView] visibleHeight in
                messageInputView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-visibleHeight)
                }
            }).disposed(by: self.disposeBag)
    }
}

extension CSUMessageViewController: SRPClearTextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        
        if textView.text.count >= 10000 {
            return false
        }
        return true
    }
}
