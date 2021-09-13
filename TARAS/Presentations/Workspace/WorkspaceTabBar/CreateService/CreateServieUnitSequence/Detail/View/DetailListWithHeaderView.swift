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
        $0.font = .bold.16
        $0.textColor = .purple4A3C9F
    }
    
    let addButton = QuantityButton(type: .plusPurple)
    
    
    // MARK: - Init
    
    /// DetailStackView -> LoadList/UnloadList 전용 Init
    init(type: ServiceUnitFreightType) {
        super.init(frame: .zero)
        
        self.setupConstraintsForFreights()
        self.titleLabel.text = (type == .load) ? "실을 물품": "내릴 물품"
    }
    
    /// DetailStackView -> RecipientListView 전용 Init
    init() {
        super.init(frame: .zero)
        
        self.setupConstraintsForRecipients()
        self.titleLabel.text = "수신 대상"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraintsForFreights() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        self.addSubview(self.addButton)
        self.addButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.trailing.equalToSuperview().offset(-22)
            $0.bottom.equalToSuperview().offset(-10)
        }
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
