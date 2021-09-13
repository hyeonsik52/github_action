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
    /// - '회원-개인' 일 경우: "박수지"
    /// - '회원-그룹' 일 경우: "플랫폼본부 iOS팀"
    /// - '정차지' 일 경우: "플랫폼본부 입구"
    var targetName: String
    
    /// 목적지의 대상이 속한 첫번째 그룹 이름입니다.
    /// - '회원-개인' 일 경우: "플랫폼본부 iOS팀"
    /// - '회원-그룹' 일 경우: nil
    /// - '정차지' 일 경우: nil
    var targetGroupName: String?
    
    /// 목적지의 정보입니다.
//    var info: CreateServiceUnitInput
}

/// 단위서비스 모델입니다.
struct CreateServiceUnitModel {
    
    /// 단위서비스의 정보입니다.
    var serviceUnit: CSUInfo
    
    /// 경유지 입니다.
    var bypass: CSUInfo?
    
    init(
        serviceUnitTargetName: String,
        serviceUnitTargetGroupName: String? = nil//,
//        serviceUnitInfo: CreateServiceUnitInput
    ) {
        self.serviceUnit = .init(
            targetName: serviceUnitTargetName,
            targetGroupName: serviceUnitTargetGroupName//,
//            info: serviceUnitInfo
        )
    }
    
    /// 경유지 포함 여부를 반환합니다.
    var hasBypass: Bool {
        return self.bypass != nil
    }
}
