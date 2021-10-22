//
//  ServiceUnitManagementHeader.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ServiceUnitManagementHeader: UICollectionReusableView {
        
    private let titleLabel = UILabel().then {
        $0.font = .bold[24]
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
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func bind(service: Service) {
        
        let total = service.serviceUnits.count
        self.titleLabel.text = "총 \(total)개의 목적지"
    }
}
