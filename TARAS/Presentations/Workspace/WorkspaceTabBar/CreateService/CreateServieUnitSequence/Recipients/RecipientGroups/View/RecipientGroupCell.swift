//
//  RecipientGroupCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/11.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class RecipientGroupCell: BaseTableViewCell, ReactorKit.View {
    
    /// 수신자-그룹의 프로필 이미지를 표출합니다.
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .grayE6E6E6
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    /// 수신자-그룹의 이름을 표출합니다.
    let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .medium.16
        $0.numberOfLines = 2
    }
    
    
    // MARK: - Init
    
    override func initial() {
        super.initial()
        
        self.setupConstraints()
    }
    
    
    // MARK: Binding

    func bind(reactor: RecipientGroupCellReactor) {
        let recipientInfo = reactor.currentState
        
        self.nameLabel.text = recipientInfo.name
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
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().offset(-14)
        }
    }
}
