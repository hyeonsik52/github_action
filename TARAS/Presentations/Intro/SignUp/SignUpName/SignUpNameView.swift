//
//  SignUpNameView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

/// SignUpNameViewController 에서 사용되는 커스텀 뷰 입니다.
class SignUpNameView: UIView {
    
    enum Text {
        static let SUPVC_1 = "회원가입"
        static let SUPVC_2 = "이름을 입력해주세요."
        static let SUPVC_3 = "이름을 입력해주세요."
    }
    
    let name = PublishRelay<String>()
    
    weak var nameTextFieldsDelegate: SignUpTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    /// 시스템 라지 네비바 형태의 뷰 + "이름을 입력해주세요." 라벨
    private let guideView = SignUpGuideView(Text.SUPVC_1, guideText: Text.SUPVC_2)
    
    /// 유저 이름 입력 텍스트 필드
    private lazy var nameTextFieldView = SignTextFieldView(Text.SUPVC_3).then {
        $0.textField.delegate = self
        $0.textField.returnKeyType = .done
        $0.textField.autocapitalizationType = .none
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupContraints()
        
        self.nameTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.name)
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
        self.addSubview(self.nameTextFieldView)
        self.nameTextFieldView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func nameTextFieldBecomeFirstResponse() {
        self.nameTextFieldView.textField.becomeFirstResponder()
    }
}


// MARK: - UITextFieldDelegate

extension SignUpNameView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextFieldsDelegate?.textFieldShouldReturn(textField)
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return textField.shouldChangeCharactersIn(in: range, replacementString: string, policy: .name)
    }
}
