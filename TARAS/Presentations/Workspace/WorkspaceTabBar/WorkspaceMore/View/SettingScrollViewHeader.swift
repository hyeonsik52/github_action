//
//  SettingScrollViewHeader.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SettingScrollViewHeader: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .gray888888
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        self.titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.lessThanOrEqualToSuperview().offset(-22)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }
}
