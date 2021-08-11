//
//  SignInView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import Then
import SnapKit

class SignInView: UIView {
    
    enum Text {
        static let SIVC_1 = "로그인"
        static let SIVC_2 = "아이디"
        static let SIVC_3 = "비밀번호"
    }
    
    /// 라지 네비바 형태의 view
    private let titleView = LargeTitleView(Text.SIVC_1)
    
    /// 유저 아이디 입력 textField
    let idTextFieldView = SignTextFieldView(Text.SIVC_2).then {
        $0.textField.returnKeyType = .next
        $0.textField.autocapitalizationType = .none
        $0.textField.keyboardType = AccountInputType.id.keyboardType
    }
    
    /// 유저 비밀번호 입력 textField
    let passwordTextFieldView = SignTextFieldView(Text.SIVC_3).then {
        $0.textField.isSecureTextEntry = true
        $0.textField.returnKeyType = .done
    }
    
    /// 로그인 에러 메시지 label
    let warningLabel = UILabel().then {
        $0.textColor = .redF80003
        $0.font = .regular.12
        $0.numberOfLines = 2
    }
    
    /// '로그인' 버튼
    let signInButton = TRSButton(Text.SIVC_1).then {
        $0.isEnabled = false
    }
    
    /// '계정찾기' 버튼
    let forgotAccountButton = GostButton("아이디·비밀번호 찾기")
    
    /// '회원가입' 버튼
    let signUpButton = GostButton("회원가입")
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constaraints
    
    func setupContraints() {
        self.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.addSubview(self.idTextFieldView)
        self.idTextFieldView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(36)
        }
        
        self.addSubview(self.passwordTextFieldView)
        self.passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(self.idTextFieldView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(36)
        }
        
        self.addSubview(self.warningLabel)
        self.warningLabel.snp.makeConstraints {
            $0.top.equalTo(self.passwordTextFieldView.snp.bottom).offset(0)
            $0.leading.trailing.equalTo(self.passwordTextFieldView)
        }
        
        self.addSubview(self.signInButton)
        self.signInButton.snp.makeConstraints {
            $0.top.equalTo(self.passwordTextFieldView.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
        let bottomContainer = UIView()
        self.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-22)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        bottomContainer.addSubview(self.signUpButton)
        self.signUpButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(55)
        }
        
        let separator = UIView().then {
            $0.backgroundColor = .black
        }
        bottomContainer.addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.equalTo(self.signUpButton.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }
        
        bottomContainer.addSubview(self.forgotAccountButton)
        self.forgotAccountButton.snp.makeConstraints {
            $0.leading.equalTo(separator.snp.trailing).offset(8)
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(109)
        }
    }
}
