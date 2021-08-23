//
//  SRPStateView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SRPStateView: UIView {

    private let container = UIView().then {
        $0.clipsToBounds = true
        $0.cornerRadius = 6
    }
    
    private let label = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.container)
        self.container.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.height.equalTo(22)
        }
        
        self.container.addSubview(self.label)
        self.label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func bind(title: String, titleColor: UIColor, backgroundColor: UIColor) {
        
        self.label.text = title
        self.label.textColor = titleColor
        
        self.container.backgroundColor = backgroundColor
    }
}

extension SRPStateView {
        
    func setAllow() {
        self.bind(
            title: "수락",
            titleColor: Color.SKY_BLUE_85AEFF,
            backgroundColor: Color.LIGHT_SKY_BLUE_F0F5FF
        )
    }
    
    func setReject() {
        self.bind(
            title: "거절",
            titleColor: Color.RED_EB4D39,
            backgroundColor: Color.LIGHT_RED_FFE8E6
        )
    }
    
    func setProcessing() {
        self.bind(
            title: "진행중",
            titleColor: Color.RED_EB4D39,
            backgroundColor: Color.LIGHT_RED_FFE8E6
        )
    }
    
    func setWaitingAnswer(count: Int, total: Int) {
        self.bind(
            title: "\(count)/\(total)",
            titleColor: Color.PURPLE_4A3C9F,
            backgroundColor: Color.LIGHT_GRAY_F2F2F2
        )
    }
}
