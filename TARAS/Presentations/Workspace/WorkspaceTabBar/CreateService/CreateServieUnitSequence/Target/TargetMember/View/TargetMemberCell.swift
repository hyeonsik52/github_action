//
//  TargetMemberCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class TargetMemberCell: BaseTableViewCell, ReactorKit.View {
    
    /// 대상의 프로필 이미지를 표출합니다.
    let profileImageView = UIImageView().then {
        $0.backgroundColor = Color.GRAY_E6E6E6
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    /// 대상의 이름을 표출합니다.
    let nameLabel = UILabel().then {
        $0.textColor = Color.BLACK_0F0F0F
        $0.font = Font.MEDIUM_16
        $0.numberOfLines = 2
    }
    
    /// 대상이 속한 그룹의 이름을
    /// 대상이 복수의 그룹에 소속되어 있을 경우, 하나의 그룹 이름만을 표출합니다.
    /// - 대상-정차지의 경우: 대상이 속한 그룹이 없으므로 label이 숨김 처리됩니다.
    let groupNameLabel = UILabel().then {
        $0.textColor = Color.GRAY_9A9A9A
        $0.font = Font.MEDIUM_16
    }
    
    
    // MARK: - Init
    
    override func initial() {
        super.initial()
        
        self.setupConstraints()
    }
    
    
    // MARK: Binding

    func bind(reactor: TargetMemberCellReactor) {
        let targetInfo = reactor.currentState
        
        self.nameLabel.text = targetInfo.name
        self.groupNameLabel.text = targetInfo.groupName
        self.backgroundColor = targetInfo.isSelected ? Color.LIGHT_GRAY_F6F6F6: .white
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
        
        let stackView = UIStackView().then{
            $0.axis = .vertical
            $0.distribution = .fillProportionally
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(self.profileImageView.snp.centerY)
        }
        
        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.groupNameLabel)
    }
}
