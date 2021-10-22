//
//  SignUpPasswordView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

/// SignUpPasswordViewController 에서 사용되는 커스텀 뷰 입니다.
class SignUpPasswordView: UIView {
    
    enum Text {
        static let SUPVC_1 = "비밀번호 설정"
        static let SUPVC_2 = "사용하실 비밀번호를 입력해주세요."
        static let SUPVC_3 = "비밀번호를 입력해주세요."
        static let SUPVC_4 = "한번 더 비밀번호를 입력해주세요."
        static let SUPVC_5 = "비밀번호는 8~32자로 설정해 주세요."
    }
    
    let password = PublishRelay<String>()
    let passwordConfirmed = BehaviorRelay<String>(value: "")
    
    weak var passwordTextFieldsDelegate: SignUpTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    /// 시스템 라지 네비바 형태의 뷰 + "비밀번호를 설정해주세요." 라벨
    private let guideView = SignUpGuideView(Text.SUPVC_1, guideText: Text.SUPVC_2)
    
    /// 유저 비밀번호 입력 텍스트 필드
    private lazy var passwordTextFieldView = SignTextFieldView(Text.SUPVC_3).then {
        $0.textField.delegate = self
        $0.textField.isSecureTextEntry = true
        $0.textField.returnKeyType = .next
        $0.textField.autocapitalizationType = .none
    }
    
    /// 유저 비밀번호 재입력 텍스트 필드
    private lazy var passwordConfirmTextFieldView = SignTextFieldView(Text.SUPVC_4).then {
        $0.textField.delegate = self
        $0.textField.isSecureTextEntry = true
        $0.textField.returnKeyType = .done
        $0.textField.autocapitalizationType = .none
    }
    
    /// "비밀번호는 8~32자로 설정해 주세요." 라벨
    private let inputGuideLabel = UILabel().then {
        $0.text = Text.SUPVC_5
        $0.textColor = .gray9A9A9A
        $0.font = .medium[14]
        $0.numberOfLines = 0
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
        
        self.passwordConfirmTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.passwordConfirmed)
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
        self.addSubview(self.passwordConfirmTextFieldView)
        self.passwordConfirmTextFieldView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.passwordTextFieldView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(self.passwordTextFieldView)
        }
        self.addSubview(self.inputGuideLabel)
        self.inputGuideLabel.snp.makeConstraints {
            $0.top.equalTo(self.passwordConfirmTextFieldView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(self.passwordConfirmTextFieldView)
        }
        self.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.inputGuideLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(self.passwordTextFieldView)
            $0.bottom.equalToSuperview()
        }
    }
    
    func passwordTextFieldBecomeFirstResponse() {
        self.passwordTextFieldView.textField.becomeFirstResponder()
    }
    
    func passwordConfirmTextFieldBecomeFirstResponse() {
        self.passwordConfirmTextFieldView.textField.becomeFirstResponder()
    }
}


// MARK: - UITextFieldDelegate

extension SignUpPasswordView: UITextFieldDelegate {
    
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
