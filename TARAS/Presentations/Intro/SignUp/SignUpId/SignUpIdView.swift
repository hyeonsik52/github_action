//
//  SignUpIdView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

protocol SignUpTextFieldDelegate: class {
    func textFieldShouldReturn(_ sender: UITextField)
}

/// SignUpIdViewController 에서 사용되는 커스텀 뷰 입니다.
class SignUpIdView: UIView {
    
    enum Text {
        static let SUVC_1 = "회원가입"
        static let SUVC_2 = "사용하실 아이디를 입력해주세요."
        static let SUVC_3 = "아이디를 입력해주세요."
        static let SUVC_4 = "중복 확인"
        static let SUVC_5 = "5~20자의 알파벳과 숫자, 일부 특수문자(-,_)만 사용해주세요."
    }
    
    let id = PublishRelay<String>()
    
    let errorMessage = PublishRelay<String?>()
    
    let isDuplicateCheckButtonEnabled = PublishRelay<Bool>()
    
    let duplicateCheckButtonDidTap = PublishRelay<Void>()
    
    weak var idTextFieldDelegate: SignUpTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    /// 시스템 라지 네비바 형태의 뷰 + "아이디를 입력해주세요." 라벨
    private let guideView = SignUpGuideView(Text.SUVC_1, guideText: Text.SUVC_2)
    
    /// 유저 아이디 입력 텍스트 필드
    lazy var idTextFieldView = SignUpTextFieldView(
        Text.SUVC_3,
        buttonTitle: Text.SUVC_4
    ).then {
        $0.textField.keyboardType = AccountInputType.id.keyboardType
        $0.textField.delegate = self
    }
    
    /// "5~20자의 알파벳과 숫자, 일부 특수문자(-,_)만 사용해주세요." 라벨
    private let inputGuideLabel = UILabel().then {
        $0.text = Text.SUVC_5
        $0.textColor = .grayA0A0A0
        $0.font = .medium.14
        $0.numberOfLines = 0
    }
    
    /// 에러 메시지 라벨
    let errorMessageLabel = UILabel().then {
        $0.textColor = .redF80003
        $0.font = .bold.14
        $0.numberOfLines = 0
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupContraints()
        
        self.idTextFieldView.textField.rx.text.orEmpty
            .bind(to: self.id)
            .disposed(by: self.disposeBag)
        
        self.idTextFieldView.innerButton.rx.throttleTap(.seconds(3))
            .bind(to: self.duplicateCheckButtonDidTap)
            .disposed(by: self.disposeBag)
        
        isDuplicateCheckButtonEnabled
            .bind(to: self.idTextFieldView.innerButton.rx.isEnabled)
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
        self.addSubview(self.idTextFieldView)
        self.idTextFieldView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(self.guideView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        self.addSubview(self.inputGuideLabel)
        self.inputGuideLabel.snp.makeConstraints {
            $0.top.equalTo(self.idTextFieldView.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(self.idTextFieldView)
        }
        self.addSubview(self.errorMessageLabel)
        self.errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(self.inputGuideLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.idTextFieldView)
            $0.bottom.equalToSuperview()
        }
    }
    
    func textFieldBecomeFirstResponse() {
        self.idTextFieldView.textField.becomeFirstResponder()
    }
}


// MARK: - UITextFieldDelegate

extension SignUpIdView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.idTextFieldDelegate?.textFieldShouldReturn(textField)
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

