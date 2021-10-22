//
//  FindAccountIdView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class FindAccountIdView: UIView {
    
    enum Text {
        static let FAIV_1 = "아이디 입력"
        static let FAIV_2 = "비밀번호를 찾을 아이디를 입력해주세요."
        static let FAIV_3 = "아이디"
    }
    
    let id = PublishRelay<String>()
    
    weak var idTextFieldsDelegate: SignUpTextFieldDelegate?
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    private let guideView = SignUpGuideView(Text.FAIV_1, guideText: Text.FAIV_2)
    
    private lazy var idTextFieldView = SignTextFieldView(Text.FAIV_3).then {
        $0.textField.delegate = self
        $0.textField.returnKeyType = .done
        $0.textField.autocapitalizationType = .none
        $0.textField.keyboardType = AccountInputType.id.keyboardType
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

extension FindAccountIdView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.idTextFieldsDelegate?.textFieldShouldReturn(textField)
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
