//
//  SignTextFieldView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import Then
import SnapKit

/// 로그인 화면 등에서 유저 인풋을 받는 커스텀 텍스트필드 뷰
class SignTextFieldView: UIView {
    
    let TEXT_INSET: CGFloat = 24
    
    let ZERO: CGFloat = 0
    
    let textField = UITextField().then {
        $0.font = .bold.18
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.enablesReturnKeyAutomatically = true
    }
    
    
    // MARK: - Init
    
    init(_ placeholder: String) {
        super.init(frame: .zero)
        
//        self.backgroundColor = .lightGrayF6F6F6
//        self.layer.cornerRadius = 4
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray787878,
            NSAttributedString.Key.font: UIFont.regular.16
        ]
        let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
        self.textField.attributedPlaceholder = attributedString
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.becomeFirstResponder()
    }
    
    // MARK: - Methods
    
    private func setupConstraints() {
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        let underline = UIView().then {
            $0.backgroundColor = .grayC9C9C9
        }
        self.addSubview(underline)
        underline.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.textField)
            $0.height.equalTo(1)
        }
    }
}
