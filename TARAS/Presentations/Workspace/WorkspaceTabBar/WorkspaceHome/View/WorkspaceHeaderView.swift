//
//  WorkspaceHeaderView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkspaceHeaderView: UIView {

    private var userNameLabel = UILabel().then{
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.6
        $0.lineBreakMode = .byTruncatingHead
        $0.font = .regular[20]
        $0.textColor = .black0F0F0F
        $0.text = " "
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        let container = UIView()
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        container.addSubview(self.userNameLabel)
        self.userNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        let staticLabel = UILabel().then{
            $0.minimumScaleFactor = 0.8
            $0.adjustsFontSizeToFitWidth = true
            $0.font = .bold[24]
            $0.textColor = .black0F0F0F
            $0.text = "서비스를 생성해보세요"
        }
        container.addSubview(staticLabel)
        staticLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(6)
            make.leading.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func bind(_ user: User) {
        
        self.userNameLabel.text = "\(user.displayName)님!"
    }
}
