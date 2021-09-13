//
//  WaypointCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Twinny on 2020/07/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class WaypointCell: BaseTableViewCell, ReactorKit.View {
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .grayE6E6E6
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .medium.16
    }

    override func initial() {
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(22)
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.bottom.equalToSuperview().offset(-11)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-22)
        }
    }

    func bind(reactor: WaypointCellViewReactor) {
        self.nameLabel.text = reactor.cellModel.name
    }
}
