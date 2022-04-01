//
//  ForgotAccountTextFieldView.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/31.
//

import UIKit
import Then
import SnapKit

/// 아이디 · 비밀번호 찾기에서 유저 인풋을 받는 커스텀 텍스트필드 뷰
class ForgotAccountTextFieldView: UIView {
    
    enum ViewType {
        case id
        case pw
        case deliveryRequest
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .lightGrayF6F6F6
        $0.layer.cornerRadius = 4
    }
    
    let textField = UITextField().then {
        $0.font = .bold[18]
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.enablesReturnKeyAutomatically = true
    }
    
    private let viewType: ViewType
    
    init(_ placeholder: String = "", viewType: ViewType = .id) {
        self.viewType = viewType
        super.init(frame: .zero)
        
        // viewType 이 .deliveryRequest 일 때는 text input 목적이 아닌
        // text presentation 용도로 사용하므로 isUserInteractionEnabled 을 false 로 처리
        self.textField.isUserInteractionEnabled = !(viewType == .deliveryRequest)
        self.textField.keyboardType = { return .asciiCapable }()
        self.textField.returnKeyType = (viewType == .pw ? .continue: .done)
        self.textField.autocapitalizationType = .none
        self.textField.placeholder = placeholder
        self.setupConstraints(viewType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(_ viewType: ViewType) {
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
