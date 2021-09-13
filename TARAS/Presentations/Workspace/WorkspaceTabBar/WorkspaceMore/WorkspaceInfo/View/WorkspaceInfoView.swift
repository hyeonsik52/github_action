//
//  WorkspaceInfoView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkspaceInfoView: UIView {

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 14
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .bold.22
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private let createLabel = UILabel().then {
        $0.font = .bold.14
        $0.textAlignment = .center
        $0.textColor = .grayA0A0A0
    }
    
    private let memberCountLabel = UILabel().then {
        $0.font = .bold.13
        $0.textAlignment = .center
        $0.textColor = .purple4A3C9F
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(90)
            $0.width.height.equalTo(86)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(self.createLabel)
        self.createLabel.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        let memberCountContainer = UIView().then {
            $0.clipsToBounds = true
            $0.cornerRadius = 10
            $0.backgroundColor = .LIGHT_PUPLE_EBEAF4
        }
        self.addSubview(memberCountContainer)
        memberCountContainer.snp.makeConstraints {
            $0.top.equalTo(self.createLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().offset(-45)
            $0.height.equalTo(30)
        }
        
        memberCountContainer.addSubview(self.memberCountLabel)
        self.memberCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
    }
    
    func bind(_ workspace: Workspace) {
         
        self.profileImageView.setImage(strUrl: workspace.profileImageURL)

        self.nameLabel.text = workspace.name
        
        if let date = workspace.createAt {
            let formatted = Formatter.YYMMDD.string(from: date)
            self.createLabel.text = "\(formatted) 생성"
        }else{
            //TODO: ??
            self.createLabel.text = "00.00.00 생성"
        }
        
        self.memberCountLabel.text = "회원 \(workspace.memberCount)명"
    }
}
