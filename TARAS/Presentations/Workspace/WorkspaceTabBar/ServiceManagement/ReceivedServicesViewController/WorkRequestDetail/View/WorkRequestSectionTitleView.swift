//
//  WorkRequestSectionTitleView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkRequestSectionTitleView: UIView {

    private var titleLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .purple4A3C9F
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
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
        }
    }
}
