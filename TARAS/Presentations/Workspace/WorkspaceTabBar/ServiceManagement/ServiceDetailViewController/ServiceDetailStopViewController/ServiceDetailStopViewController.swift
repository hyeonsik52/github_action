//
//  ServiceDetailStopViewController.swift
//  TARAS
//
//  Created by nexmond on 2022/02/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class ServiceDetailStopViewController: BaseViewController, View {
    
    enum Text {
        static let title = "정차지 정보"
        static let stopTitle = "정차지"
        static let recipientTitle = "수신자"
        static let authCodeTitle = "인증번호"
        static let detailTitle = "요청사항"
        static let closeButtonTitle = "닫기"
    }
    
    private let stopLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .black0F0F0F
        $0.textAlignment = .right
    }
    
    private var recipientContainer: UIView!
    private let recipientLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .black0F0F0F
        $0.textAlignment = .right
    }
    
    private var authNumberContainer: UIView!
    private let authNumberLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .black0F0F0F
        $0.textAlignment = .right
    }
    
    private var detailContainer: UIView!
    private let detailLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .black0F0F0F
        $0.numberOfLines = 0
    }
    
    let closeButton = SRPButton(Text.closeButtonTitle)
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .clear
        
        let navigationContainer = UIView()
        self.view.addSubview(navigationContainer)
        navigationContainer.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        let titleLabel = UILabel().then {
            $0.font = .bold[18]
            $0.textColor = .black0F0F0F
            $0.text = Text.title
        }
        navigationContainer.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        let contentView = UIStackView().then {
            $0.axis = .vertical
        }
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationContainer.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        @discardableResult
        func addContainer(
            title: String?,
            label: UILabel,
            isLabelBottom: Bool = false
        ) -> UIView {
            
            let container = UIView()
            contentView.addArrangedSubview(container)
            
            let titleLabel = UILabel().then {
                $0.font = .regular[14]
                $0.textColor = .gray999999
                $0.text = title
                $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
            }
            container.addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                if !isLabelBottom {
                    $0.bottom.equalToSuperview()
                }
                $0.top.leading.equalToSuperview()
                $0.height.equalTo(48)
            }
            
            label.setContentHuggingPriority(.defaultLow-1, for: .horizontal)
            container.addSubview(label)
            if isLabelBottom {
                label.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom)
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-4)
                }
            } else {
                label.snp.makeConstraints {
                    $0.top.bottom.trailing.equalToSuperview()
                    $0.leading.equalTo(titleLabel.snp.trailing)
                }
            }
            
            container.isHidden = (label.text ?? "").isEmpty
            
            return container
        }
        
        addContainer(title: Text.stopTitle, label: self.stopLabel)
        self.recipientContainer = addContainer(title: Text.recipientTitle, label: self.recipientLabel)
        self.authNumberContainer = addContainer(title: Text.authCodeTitle, label: self.authNumberLabel)
        self.detailContainer = addContainer(title: Text.detailTitle, label: self.detailLabel, isLabelBottom: true)
        
        self.view.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(64)
        }
    }
    
    func bind(reactor: ServiceDetailServiceUnitCellReactor) {
        let serviceUnit = reactor.initialState.serviceUnit
        
        self.stopLabel.text = serviceUnit.stop.name
        self.recipientLabel.text = serviceUnit.recipients.map(\.displayName).joined(separator: ", ")
        self.authNumberLabel.text = serviceUnit.authNumber
        self.detailLabel.text = serviceUnit.detail
    }
}
