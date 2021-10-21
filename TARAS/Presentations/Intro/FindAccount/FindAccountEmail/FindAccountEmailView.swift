//
//  FindAccountEmailView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class FindAccountEmailView: UIView {
    
    enum Text {
        static let FAEV_1 = "이메일 인증"
        static let FAEV_2 = "가입 시 등록한 이메일로 인증을 진행해주세요."
        static let FAEV_3 = "이메일 주소"
        static let FAEV_4 = "인증"
        static let FAEV_5 = "재인증"
        static let FAEV_6 = "인증번호 입력"
    }
    
    let email = PublishRelay<String>()
    let authNumber = BehaviorRelay<String>(value: "")
    let remainTime = PublishRelay<String?>()
    
    weak var emailTextFieldsDelegate: SignUpTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    private let guideView = SignUpGuideView(Text.FAEV_1, guideText: Text.FAEV_2)
    
    lazy var emailTextFieldView = SignUpTextFieldView(
        Text.FAEV_3,
        buttonTitle: Text.FAEV_4,
        viewType: .email
    ).then {
        $0.textField.delegate = self
    }
    lazy var authNumberTextFieldView = SignUpTextFieldView(
        Text.FAEV_6,
        viewType: .emailAuth
    ).then {
        $0.textField.delegate = self
        $0.isHidden = true
    }
    
    private let textFieldsStackView = UIStackView()
    
    /// 에러 메시지 라벨
    let errorMessageLabel = UILabel().then {
        $0.textColor = .redF80003
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
        
        self.authNumberTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.authNumber)
            .disposed(by: self.disposeBag)
        
        self.remainTime
            .bind(to: self.authNumberTextFieldView.remainTimeLabel.rx.text)
            .disposed(by:self.disposeBag)
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
            $0.spacing = 12
        }
        
        stackView.addArrangedSubview(self.emailTextFieldView)
        stackView.addArrangedSubview(self.authNumberTextFieldView)
        
        self.emailTextFieldView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.authNumberTextFieldView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(stackView)
            $0.bottom.equalToSuperview()
        }
    }
    
    func emailTextFieldBecomeFirstResponse() {
        self.emailTextFieldView.textField.becomeFirstResponder()
    }
    
    func authCodeTextFieldBecomeFirstResponse() {
        self.authNumberTextFieldView.textField.becomeFirstResponder()
    }
    
    func toggleAuthButtonTitle() {
        self.emailTextFieldView.innerButton.setTitle(Text.FAEV_5, for: .normal)
        self.emailTextFieldView.innerButtonLayoutIfNeeded()
    }
    
    /// 이메일과 유효성 관련 버튼을 제외한 나머지 폼 초기화
    func resetInputsWithoutEmail() {
        
        self.authNumberTextFieldView.textField.text = nil
        self.authNumberTextFieldView.remainTimeLabel.text = nil
        
        self.authNumberTextFieldView.isHidden = true
    }
}


// MARK: - UITextFieldDelegate

extension FindAccountEmailView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextFieldsDelegate?.textFieldShouldReturn(textField)
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
