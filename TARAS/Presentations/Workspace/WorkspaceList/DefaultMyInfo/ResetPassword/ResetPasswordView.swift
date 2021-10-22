//
//  ResetPasswordView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class ResetPasswordView: UIView {
    
    enum Text {
        static let RPV_1 = "기존 비밀번호"
        static let RPV_2 = "본인 확인을 위해 비밀번호를 입력해 주세요."
        static let RPV_3 = "비밀번호"
    }
    
    let password = PublishRelay<String>()
    
    weak var passwordTextFieldsDelegate: SignUpTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    private let guideView = SignUpGuideView(Text.RPV_1, guideText: Text.RPV_2)
    
    private lazy var passwordTextFieldView = SignTextFieldView(Text.RPV_3).then {
        $0.textField.delegate = self
        $0.textField.isSecureTextEntry = true
        $0.textField.returnKeyType = .next
        $0.textField.autocapitalizationType = .none
    }
    
    /// 에러 메시지 라벨
    let errorMessageLabel = UILabel().then {
        $0.textColor = .redEB4D39
        $0.font = .bold[14]
        $0.numberOfLines = 0
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupContraints()
        
        self.passwordTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.password)
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constaraints
    
    func setupContraints() {
        self.addSubview(self.guideView)
        self.guideView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        self.addSubview(self.passwordTextFieldView)
        self.passwordTextFieldView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        self.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.passwordTextFieldView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(self.passwordTextFieldView)
            $0.bottom.equalToSuperview()
        }
    }
    
    func passwordTextFieldBecomeFirstResponse() {
        self.passwordTextFieldView.textField.becomeFirstResponder()
    }
}


// MARK: - UITextFieldDelegate

extension ResetPasswordView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.passwordTextFieldsDelegate?.textFieldShouldReturn(textField)
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: .password)
    }
}
