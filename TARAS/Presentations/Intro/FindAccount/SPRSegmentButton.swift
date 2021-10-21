//
//  SPRSegmentButton.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

class SRPSegmentButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)

        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.isSelected = true
        self.setBackgroundColor(color: .white, forState: .normal)
        self.setBackgroundColor(color: .lightPurpleEDECF5, forState: .selected)
        self.setTitleColor(.grayA0A0A0, for: .normal)
        self.setTitleColor(.purple4A3C9F, for: .selected)
        self.tintColor = .clear
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        self.adjustsImageWhenHighlighted = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
