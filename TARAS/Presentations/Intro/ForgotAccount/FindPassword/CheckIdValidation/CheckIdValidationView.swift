//
//  CheckIdValidationView.swift
//  TARAS
//
//  Created by 오현식 on 2022/04/05.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class CheckIdValidationView: UIView {
    
    enum Text {
        static let SUVC_1 = "아이디 입력"
        static let SUVC_2 = "비밀번호를 찾을 아이디를 입력해주세요."
        static let SUVC_3 = "아이디"
    }
    
    let id = PublishRelay<String>()
    
    let errorMessage = PublishRelay<String?>()
    
    weak var idTextFieldViewDelegate: ForgotAccountTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    /// 시스템 라지 네비바 형태의 뷰 + "비밀번호를 찾을 아이디를 입력해주세요." 라벨
    private let guideView = ForgotAccountGuideView(Text.SUVC_1, guideText: Text.SUVC_2)
    
    /// 유저 아이디 표시 텍스트 필드
    lazy var idTextFieldView = ForgotAccountTextFieldView(Text.SUVC_3).then {
        $0.textField.delegate = self
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
        
        self.idTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.id)
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
        
        self.addSubview(self.idTextFieldView)
        self.idTextFieldView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.idTextFieldView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(self.idTextFieldView)
            $0.bottom.equalToSuperview()
        }
    }
    
    func idTextFieldBecomeFirstResponse() {
        self.idTextFieldView.textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension CheckIdValidationView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.idTextFieldViewDelegate?.textFieldShouldReturn(textField)
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: .id)
    }
}
