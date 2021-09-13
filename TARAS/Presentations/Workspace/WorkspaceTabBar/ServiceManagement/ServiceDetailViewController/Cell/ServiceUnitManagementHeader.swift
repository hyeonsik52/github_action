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
        $0.font = .bold.24
        $0.textColor = .black
    }
    
    private let answerState = SRPStateView().then {
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
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
            $0.leading.equalToSuperview().offset(22)
        }
        
        self.addSubview(self.answerState)
        self.answerState.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(22)
        }
    }
    
    func bind(mode: ServiceDetailViewReactor.Mode, service: ServiceModel) {
        
        let total = service.serviceUnitList.count
        self.titleLabel.text = (mode == .preview ? "총 \(total)개의 목적지": service.statusString)
        
        if mode != .preview,
        service.status == .waitingResponse || service.status == .canceledOnWaiting {
            let total = service.serviceUnitList.count
            let accepted = service.serviceUnitList.filter{ $0.isAcceptorExisted }.count
            self.answerState.setWaitingAnswer(count: accepted, total: total)
            self.answerState.isHidden = false
        }else{
            self.answerState.isHidden = true
        }
    }
}
