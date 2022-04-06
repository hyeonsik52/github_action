//
//  ResetPasswordView.swift
//  TARAS
//
//  Created by 오현식 on 2022/04/05.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class ResetPasswordView: UIView {
    
    enum Text {
        static let SUVC_1 = "비밀번호 재설정"
        static let SUVC_2 = "새롭게 설정할 비밀번호를 입력해주세요."
        static let SUVC_3 = "비밀번호"
        static let SUVC_4 = "비밀번호 확인"
    }
    
    let password = PublishRelay<String>()
    
    let passwordConfirmed = BehaviorRelay<String>(value: "")
    
    let errorMessage = PublishRelay<String?>()
    
    weak var passwordTextFieldsDelegate: ForgotAccountTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    /// 시스템 라지 네비바 형태의 뷰 + "새롭게 설정할 비밀번호를 입력해주세요." 라벨
    private let guideView = ForgotAccountGuideView(Text.SUVC_1, guideText: Text.SUVC_2)
    
    /// 유저 비밀번호 입력 텍스트 필드
    lazy var passwordTextFieldView = ForgotAccountTextFieldView(Text.SUVC_3, viewType: .password).then {
        $0.textField.delegate = self
    }
    
    /// 유저 비밀번호 확인 입력 텍스트 필드
    lazy var passwordConfirmTextFieldView = ForgotAccountTextFieldView(Text.SUVC_4, viewType: .password).then {
        $0.textField.delegate = self
        $0.textField.returnKeyType = .done
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
        
        self.errorMessage
            .bind(to: self.errorMessageLabel.rx.text)
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
        
        self.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.passwordConfirmTextFieldView.snp.bottom).offset(14)
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
