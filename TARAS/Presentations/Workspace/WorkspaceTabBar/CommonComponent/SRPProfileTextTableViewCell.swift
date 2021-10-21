//
//  SRPProfileTextTableViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SRPProfileTextTableViewCell: UITableViewCell {

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 22
        $0.backgroundColor = .lightGrayF1F1F1
    }
    
    private let label = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .black
    }
    
    var usingSelection = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(44)
        }
        
        self.contentView.addSubview(self.label)
        self.label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.trailing.lessThanOrEqualToSuperview().offset(-22)
        }
    }
    
    func bind(text: String?, profileImage: String?, isSelected: Bool = false) {
        
        self.profileImageView.setImage(strUrl: profileImage)
        
        self.label.text = text
        
        self.contentView.backgroundColor = (isSelected ? .lightGrayF1F1F1: .clear)
    }
}
