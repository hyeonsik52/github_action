//
//  RecipientUserCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class RecipientUserCell: BaseTableViewCell, ReactorKit.View {
    
    /// 수신자의 프로필 이미지를 표출합니다.
    let profileImageView = UIImageView().then {
        $0.backgroundColor = Color.GRAY_E6E6E6
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    /// 수신자의 이름을 표출합니다.
    let nameLabel = UILabel().then {
        $0.textColor = Color.BLACK_0F0F0F
        $0.font = Font.MEDIUM_16
        $0.numberOfLines = 2
    }
    
    /// 수신자가 속한 그룹의 이름을 표출합니다.
    /// 수신자가 복수의 그룹에 소속되어 있을 경우, 하나의 그룹 이름만을 표출합니다.
    let groupNameLabel = UILabel().then {
        $0.textColor = Color.GRAY_9A9A9A
        $0.font = Font.MEDIUM_12
    }
    
    /// 현재 선택 유무를 나타내는 체크박스입니다.
    let checkBoxImageView = UIImageView().then {
        $0.image = UIImage(named: "recipient-checkbox-off")
        $0.layer.cornerRadius = 18/2
        $0.clipsToBounds = true
    }
    
    
    // MARK: - Init
    
    override func initial() {
        super.initial()
        
        self.setupConstraints()
    }
    
    
    // MARK: Binding

    func bind(reactor: RecipientUserCellReactor) {
        let recipientInfo = reactor.initialState
        
        self.nameLabel.text = recipientInfo.name
        self.groupNameLabel.text = recipientInfo.groupName
        
        let onImage = UIImage(named: "recipient-checkbox-on")
        let offImage = UIImage(named: "recipient-checkbox-off")
        self.checkBoxImageView.image = recipientInfo.isSelected ? onImage: offImage
    }
    
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.leading.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-11)
        }
        
        self.addSubview(self.checkBoxImageView)
        self.checkBoxImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 18, height: 18))
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
        }
        
        let stackView = UIStackView().then{
            $0.axis = .vertical
            $0.distribution = .fillProportionally
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.trailing.equalTo(self.checkBoxImageView.snp.leading).offset(-10)
            $0.centerY.equalTo(self.profileImageView.snp.centerY)
        }
        
        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.groupNameLabel)
    }
}
