//
//  SRPServiceUnitDetailView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SRPServiceUnitDetailView: UIView {

    private let textLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = Color.BLACK_0F0F0F
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.backgroundColor = Color.LIGHT_GRAY_F6F6F6
        self.clipsToBounds = true
        self.cornerRadius = 8
        
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
        }
    }
    
    func bind(text: String) {
        self.textLabel.text = text
    }
}
