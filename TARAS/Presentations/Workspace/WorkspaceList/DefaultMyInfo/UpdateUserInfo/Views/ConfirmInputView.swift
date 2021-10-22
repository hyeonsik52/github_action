//
//  ConfirmInputView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/21.
//

import UIKit
import Then
import SnapKit

class ConfirmInputView: UIView {
    
    let textField = UITextField().then {
        $0.font = .bold[18]
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.enablesReturnKeyAutomatically = true
        $0.returnKeyType = .done
    }
    
    let confirmButton = SRPButton("")
    
    weak var delegate: UITextFieldDelegate?
    
    init(placeholder: String, buttonTitle: String) {
        super.init(frame: .zero)
        
        self.setupConstraints(placeholder, buttonTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ placeholder: String, _ buttonTitle: String) {
        
        self.textField.placeholder = placeholder
        self.textField.delegate = self
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        self.confirmButton.setTitle(buttonTitle, for: .normal)
        self.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.leading.equalTo(self.textField.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(64)
            $0.height.equalTo(40)
        }
        
        let separator = UIView().then {
            $0.backgroundColor = .grayF8F8F8
        }
        self.addSubview(separator)
        separator.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension ConfirmInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
