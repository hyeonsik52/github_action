//
//  WorkspaceListPlaceholderView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/25.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

class WorkspaceListPlaceholderView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "common-workspacePlaceholder-unhappy"))
    
    let label = UILabel().then {
        $0.text = "가입한 워크스페이스가 없습니다.\n'+' 버튼을 눌러 가입해주세요."
        $0.textColor = .gray9A9A9A
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = .medium[16]
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 86, height: 86))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY).offset(-40)
        }
        
        self.addSubview(self.label)
        self.label.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
