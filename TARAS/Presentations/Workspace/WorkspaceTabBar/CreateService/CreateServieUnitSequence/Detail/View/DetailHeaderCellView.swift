//
//  DetailHeaderCellView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class DetailHeaderCellView: UIView, ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    let nameLabel = UILabel().then {
        $0.text = "-에게 요청"
        $0.font = Font.BOLD_18
        $0.textColor = Color.BLACK_0F0F0F
    }
    
    let arrowImageView = UIImageView(image: UIImage(named: "service-arrow-down"))
    
    let recipientChangeButton = UIButton()
    
    let groupNameLabel = UILabel().then {
        $0.text = "-"
        $0.font = Font.BOLD_14
        $0.textColor = Color.GRAY_999999
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: DetailHeaderCellViewReactor) {
        
        let state = reactor.initialState
        
        if state.type == .recipient {
            self.nameLabel.text = state.name + "에게 요청"
            self.groupNameLabel.text = state.groupName
        } else {
            self.nameLabel.text = state.name
            self.groupNameLabel.text = nil
        }
    }
    
    func setupConstraints() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(26)
        }
        
        let nameAndButtonStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalCentering
            $0.spacing = 10
        }
        
        nameAndButtonStackView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        nameAndButtonStackView.addArrangedSubview(self.nameLabel)
        nameAndButtonStackView.addArrangedSubview(self.arrowImageView)
        
        self.arrowImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
        }
        
        nameAndButtonStackView.addSubview(self.recipientChangeButton)

        self.recipientChangeButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .equalSpacing
        }
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(self.profileImageView)
            $0.trailing.lessThanOrEqualToSuperview().offset(-24)
        }
        
        stackView.addArrangedSubview(nameAndButtonStackView)
        stackView.addArrangedSubview(self.groupNameLabel)
    }
}
