//
//  RecipientUserCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

final class RecipientUserCell: BaseTableViewCell, ReactorKit.View {
    
    /// 수신자의 이름을 표출합니다.
    let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .medium[16]
        $0.numberOfLines = 2
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
        
        let onImage = UIImage(named: "recipient-checkbox-on")
        let offImage = UIImage(named: "recipient-checkbox-off")
        self.checkBoxImageView.image = recipientInfo.isSelected ? onImage: offImage
    }
    
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(self.checkBoxImageView)
        self.checkBoxImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.equalTo(self.nameLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
        }
    }
}
