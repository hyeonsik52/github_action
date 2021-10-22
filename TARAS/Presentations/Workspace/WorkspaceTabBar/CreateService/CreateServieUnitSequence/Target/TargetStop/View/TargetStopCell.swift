//
//  TargetLocationCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class TargetStopCell: BaseTableViewCell, ReactorKit.View {
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .black0F0F0F
        $0.font = .medium[16]
        $0.numberOfLines = 2
    }
    
    
    // MARK: - Init
    
    override func initial() {
        super.initial()
        
        self.setupConstraints()
    }
    
    
    // MARK: Binding

    func bind(reactor: TargetStopCellReactor) {
        let targetInfo = reactor.currentState
        
        self.nameLabel.text = targetInfo.name
        self.backgroundColor = targetInfo.isSelected ? .lightGrayF6F6F6: .white
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
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-22)
        }
    }
}
