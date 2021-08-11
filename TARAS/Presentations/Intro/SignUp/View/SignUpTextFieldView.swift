//
//  SignUpTextFieldView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import Then
import SnapKit

/// 회원가입 단에서 아이디(중복확인), 전화번호(인증) 입력에 사용되는 버튼이 있는 커스텀 인풋 뷰
class SignUpTextFieldView: UIView {
    
    enum ViewType {
        case id
        case email
        case emailAuth
        case deliveryRequest
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .lightGrayF6F6F6
        $0.layer.cornerRadius = 4
    }
    
    let textField = UITextField().then {
        $0.font = .bold.18
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.enablesReturnKeyAutomatically = true
    }
    
    let innerButton = TRSButton("").then {
        $0.titleLabel?.font = .bold.14
        $0.isEnabled = false
    }
    
    lazy var remainTimeLabel = UILabel().then {
        $0.font = .bold.14
        $0.textColor = .redF80003
        $0.textAlignment = .center
    }
    
    private let viewType: ViewType
    
    init(_ placeholder: String, buttonTitle: String? = nil, viewType: ViewType = .id) {
        self.viewType = viewType
        super.init(frame: .zero)
        
        // viewType 이 .deliveryRequest 일 때는 text input 목적이 아닌
        // text presentation 용도로 사용하므로 isUserInteractionEnabled 을 false 로 처리
        self.textField.isUserInteractionEnabled = !(viewType == .deliveryRequest)
        self.textField.keyboardType = {
            switch viewType {
            case .id, .deliveryRequest:
                return .asciiCapable
            case .email:
                return .emailAddress
            case .emailAuth:
                return .numberPad
            }
        }()
        self.textField.returnKeyType = (viewType == .email ? .continue: .done)
        self.textField.autocapitalizationType = .none
        self.textField.placeholder = placeholder
        self.innerButton.setTitle(buttonTitle, for: .normal)
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
        
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.spacing = 8
        }
        
        self.backgroundView.addSubview(stackView)
        
        if self.viewType != .deliveryRequest {
            stackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.equalToSuperview().offset(-14)
                $0.bottom.equalToSuperview().offset(-10)
            }
        } else {
            stackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(14)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.bottom.equalToSuperview().offset(-14)
            }
        }
        
        stackView.addArrangedSubview(self.textField)
        
        // viewType.id
        // viewType.email
        if self.viewType != .emailAuth {
            let label = UILabel().then {
                $0.font = .bold.14
                $0.text = self.innerButton.titleLabel?.text
            }
            
            label.sizeToFit()
            let BUTTON_TITLE_WIDTH_MARGIN: CGFloat = (viewType == .deliveryRequest) ? 22*2: 16*2
            let buttonWidth = label.frame.width + BUTTON_TITLE_WIDTH_MARGIN
            
            stackView.addArrangedSubview(self.innerButton)
            
            self.innerButton.snp.makeConstraints {
                $0.width.equalTo(buttonWidth)
                $0.height.equalToSuperview()
            }
        } else {
            
            // viewType.emailAuth
            stackView.addArrangedSubview(self.remainTimeLabel)
            self.remainTimeLabel.snp.makeConstraints {
                $0.width.equalTo(64)
                $0.height.equalToSuperview()
            }
        }
    }
    
    func innerButtonLayoutIfNeeded() {
        
        let label = UILabel().then {
            $0.font = .bold.14
            $0.text = self.innerButton.titleLabel?.text
        }
        label.sizeToFit()
        
        let BUTTON_TITLE_WIDTH_MARGIN: CGFloat = (self.viewType == .deliveryRequest) ? 22*2: 16*2
        let buttonWidth = label.frame.width + BUTTON_TITLE_WIDTH_MARGIN
        
        self.innerButton.snp.updateConstraints {
            $0.width.equalTo(buttonWidth)
        }
    }
}
