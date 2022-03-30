//
//  CertifyEmailView.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/29.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class CertifyEmailView: UIView {
    
    enum Text {
        static let SUPVC_1 = "이메일 입력"
        static let SUPVC_2 = "계정 찾기, 비밀번호 재설정에 이용할 이메일을 입력해주세요."
        static let SUPVC_3 = "이메일 주소"
        static let SUPVC_4 = "인증"
        static let SUPVC_6 = "인증번호 입력"
    }
    
    let email = PublishRelay<String>()
    
    let authNumber = PublishRelay<String>()
    
    let remainExpires = PublishRelay<String>()
    
    let errorMessage = PublishRelay<String?>()
    
    let isCertifyButtonEnabled = PublishRelay<Bool>()
    
    let isAuthNumberTextFieldHidden = PublishRelay<Bool>()
    
    let certifyButtonDidTap = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    /// 이메일 등록 가이드 뷰
    private let guideView = CertifyEmailGuideView(Text.SUPVC_1, guideText: Text.SUPVC_2)
    
    lazy var emailTextFieldView = CertifyEmailTextFieldView(
        Text.SUPVC_3,
        buttonTitle: Text.SUPVC_4
    ).then {
        $0.textField.keyboardType = AccountInputType.email.keyboardType
        $0.textField.delegate = self
    }
    
    lazy var authNumberTextFieldView = CertifyEmailTextFieldView(
        Text.SUPVC_6,
        viewType: .authNumber
    ).then {
        $0.textField.keyboardType = AccountInputType.phoneNumber.keyboardType
        $0.textField.delegate = self
        $0.isHidden = true
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
        
        self.emailTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.email)
            .disposed(by: self.disposeBag)
        
        self.emailTextFieldView.innerButton.rx.throttleTap(.seconds(3))
            .bind(to: self.certifyButtonDidTap)
            .disposed(by: self.disposeBag)
        
        self.authNumberTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.authNumber)
            .disposed(by: disposeBag)
        
        isCertifyButtonEnabled
            .bind(to: self.emailTextFieldView.innerButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        isAuthNumberTextFieldHidden
            .bind(to: self.authNumberTextFieldView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        // 만료시간 라벨에 표시
        remainExpires
            .bind(to: self.authNumberTextFieldView.innerLabel.rx.text)
            .disposed(by: self.disposeBag)
            
        errorMessage
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
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        stackView.addArrangedSubview(self.emailTextFieldView)
        self.emailTextFieldView.snp.makeConstraints { $0.height.equalTo(60) }
        stackView.addArrangedSubview(self.authNumberTextFieldView)
        self.authNumberTextFieldView.snp.makeConstraints { $0.height.equalTo(60) }
        
        self.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(self.emailTextFieldView)
        }
    }
    
    func emailTextFieldBecomeFirstResponse() {
        self.emailTextFieldView.textField.becomeFirstResponder()
    }
}


// MARK: - UITextFieldDelegate

extension CertifyEmailView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextFieldView.textField {
            if self.emailTextFieldView.innerButton.isEnabled {
                self.emailTextFieldView.innerButton.sendActions(for: .touchUpInside)
            }
        }
        
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let policy: InputPolicy = (textField == self.emailTextFieldView.textField ? .email: .authNumber)
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: policy)
    }
}

