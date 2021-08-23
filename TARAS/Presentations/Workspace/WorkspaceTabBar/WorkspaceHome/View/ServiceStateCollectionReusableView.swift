//
//  ServiceStateCollectionReusableView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ServiceStateCollectionReusableView: UICollectionReusableView {
        
    private var titleLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = Color.BLACK_0F0F0F
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
    }
    
    func bind(_ title: String) {
        
        self.titleLabel.text = title
    }
}
