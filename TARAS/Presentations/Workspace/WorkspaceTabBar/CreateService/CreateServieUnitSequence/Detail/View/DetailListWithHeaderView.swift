//
//  FreightListHeaderView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

class DetailListWithHeaderView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .purple4A3C9F
    }
    
    
    // MARK: - Init
    
    /// DetailStackView -> RecipientListView 전용 Init
    init() {
        super.init(frame: .zero)
        
        self.setupConstraintsForRecipients()
        self.titleLabel.text = "수신 대상"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraintsForRecipients() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
