//
//  TargetStopCellModel.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import Apollo

struct TargetStopCellModel {
    
    /// 작업 위치(정차지)의 이름입니다.
    var name: String
    
    /// 작업 위치(정차지)의 인덱스입니다.
    var stopId: String
    
    /// 작업 위치(정차지)의 프로필 이미지 URL입니다.
    /// API 미완성 상태이므로 주석 처리 해놓습니다.
    // var profileImageURL: String?
    
    /// 기존 대상-정차지 수정 시에 해당 셀의 선택 유무를 나타냅니다.
    var isSelected: Bool
    
    init(stop: StopFragment, selectedTargetStopId: String? = nil) {
        
        self.name = stop.name
        self.stopId = stop.id
        
        self.isSelected = (stop.id == selectedTargetStopId)
    }
}
