//
//  CreateServiceUnitModel.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/10/08.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

struct CSUInfo {
    
    /// 목적지의 대상의 이름입니다.
    /// - '정차지' 일 경우: "플랫폼본부 입구"
    var targetName: String
    
    var targetId: String
    
    var recipients: [User]
    
    var message: String?
}

/// 단위서비스 모델입니다.
struct CreateServiceUnitModel {
    
    /// 단위서비스의 정보입니다.
    var serviceUnit: CSUInfo
    
    init(targetId: String, serviceUnitTargetName: String) {
        
        self.serviceUnit = .init(
            targetName: serviceUnitTargetName,
            targetId: targetId,
            recipients: [],
            message: nil
        )
    }
}
