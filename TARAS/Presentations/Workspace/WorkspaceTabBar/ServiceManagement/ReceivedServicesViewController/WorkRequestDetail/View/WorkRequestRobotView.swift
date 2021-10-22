//
//  WorkRequestRobotView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/14.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkRequestRobotView: UIView {

    private let titleView = WorkRequestSectionTitleView(title: "로봇 정보")
    private let robotNameLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black0F0F0F
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        let container = UIView().then {
            $0.clipsToBounds = true
            $0.cornerRadius = 8
            $0.backgroundColor = .grayF8F8F8
        }
        self.addSubview(container)
        container.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
            $0.bottom.equalToSuperview()
        }
        
        container.addSubview(self.robotNameLabel)
        self.robotNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-32)
        }
    }
    
    func bind(robotName: String?) {
        
        self.robotNameLabel.text = robotName
    }
}
