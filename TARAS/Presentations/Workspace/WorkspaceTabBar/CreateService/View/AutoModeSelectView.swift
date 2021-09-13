//
//  AutoModeSelectView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/21.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

class AutoModeSelectView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .bold.18
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "자동 경로 모드로 설정하시겠습니까?"
        $0.numberOfLines = 2
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .medium.16
        $0.textColor = .grayA0A0A0
        $0.textAlignment = .center
        $0.text = "자동 경로 모드 설정 시 최적 경로로\n재설정 됩니다."
        $0.numberOfLines = 2
    }
    
    let noButton = SRPButton("아니요").then {
        $0.setBackgroundColor(color: .grayE6E6E6, forState: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let autoModeButton = SRPButton("자동 경로 생성")
    
    init() {
        super.init(frame: .zero)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalTo(self.titleLabel)
        }
        
        self.addSubview(self.noButton)
        self.noButton.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(70)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 102, height: 60))
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        self.addSubview(self.autoModeButton)
        self.autoModeButton.snp.makeConstraints {
            $0.top.bottom.equalTo(self.noButton)
            $0.height.equalTo(60)
            $0.leading.equalTo(self.noButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
