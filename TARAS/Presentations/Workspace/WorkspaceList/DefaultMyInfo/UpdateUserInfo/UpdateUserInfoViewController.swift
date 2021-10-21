//
//  UpdateUserInfoViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/21.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class UpdateUserInfoViewController: BaseNavigatableViewController, ReactorKit.View {
    
    enum Text {
        static let UUIVC_1 = "확인"
        static let UpdatedRear = "변경 완료"
    }
    
    private lazy var userInputView = ConfirmInputView(
        placeholder: "",
        buttonTitle: Text.UUIVC_1
    ).then {
        $0.delegate = self
    }
    
    /// 에러 메시지 라벨
    let errorMessageLabel = UILabel().then {
        $0.textColor = .lightGrayF1F1F1
        $0.font = .bold[14]
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userInputView.textField.becomeFirstResponder()
    }
    
    override func setupConstraints() {
        
        self.userInputView.textField.keyboardType = self.reactor?.inputType.keyboardType ?? .default
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.userInputView)
        self.userInputView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(78)
        }
        
        self.view.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.userInputView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        let line = UIView().then {
            $0.backgroundColor = .lightGrayF1F1F1
        }
        self.view.addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        if let inputType = self.reactor?.inputType {
            self.title = "\(inputType.rawValue) 수정"
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: UpdateUserInfoViewReactor) {
        
        self.userInputView.textField.placeholder = reactor.prevValue ?? self.reactor?.inputType.rawValue
        
        let code = self.userInputView.textField.rx.text.orEmpty.distinctUntilChanged()
        
        // Action
        code
            .map(Reactor.Action.checkValidation)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.userInputView.confirmButton.rx.throttleTap
            .withLatestFrom(code)
            .map(Reactor.Action.update)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state.map { $0.isValid }
            .distinctUntilChanged()
            .bind(to: self.userInputView.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isUpdated }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                "\(reactor.inputType.rawValue) \(Text.UpdatedRear)".sek.showToast()
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .bind(to: self.errorMessageLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}

extension UpdateUserInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.userInputView.confirmButton.isEnabled {
            self.userInputView.confirmButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let inputType = self.reactor?.inputType else { return false }
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: inputType.policy)
    }
}
