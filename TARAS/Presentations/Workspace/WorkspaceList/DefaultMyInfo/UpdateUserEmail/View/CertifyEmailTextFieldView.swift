//
//  CertifyEmailTextFieldView.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/29.
//

import UIKit
import Then
import SnapKit

class CertifyEmailTextFieldView: UIView {
    
    enum ViewType {
        case email
        case authNumber
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
        $0.autocorrectionType = .no
    }
    
    let innerButton = SRPButton("").then {
        $0.titleLabel?.font = .bold[14]
        $0.layer.cornerRadius = 4
        $0.isEnabled = false
    }
    
    let innerLabel = UILabel().then {
        $0.font = .bold[14]
        $0.textColor = .redEB4D39
    }
    
    private let viewType: ViewType
    
    init(_ placeholder: String, buttonTitle: String? = nil, viewType: ViewType = .email) {
        self.viewType = viewType
        super.init(frame: .zero)
        
        self.textField.keyboardType = {
            switch viewType {
            case .email:
                return .emailAddress
            case .authNumber:
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
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-14)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        stackView.addArrangedSubview(self.textField)
        
        if self.viewType == .email {
            let label = UILabel().then {
                $0.font = .bold[14]
                $0.text = self.innerButton.titleLabel?.text
            }

            label.sizeToFit()
            let BUTTON_TITLE_WIDTH_MARGIN: CGFloat = 16*2
            let buttonWidth = label.frame.width + BUTTON_TITLE_WIDTH_MARGIN

            stackView.addArrangedSubview(self.innerButton)

            self.innerButton.snp.makeConstraints {
                $0.width.equalTo(buttonWidth)
                $0.height.equalToSuperview()
            }
        } else {
            // viewType.authNumber
            stackView.addArrangedSubview(self.innerLabel)
            
            innerLabel.sizeToFit()

            self.innerLabel.snp.makeConstraints {
                $0.width.equalTo(48)
                $0.height.equalToSuperview()
            }
        }
    }
}
