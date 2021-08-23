//
//  CompleteServiceUnitErrorCode_Message.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/08/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension CompleteServiceUnitErrorCode: ServiceUnitErrorMessage {
    
    var message: String? {
        switch self {
        case .forbidden:
            return "권한이 없습니다."
        case .serviceUnitNotExist:
            return "서비스가 존재하지 않습니다."
        case .unavailableServiceUnitToComplete:
            return "작업 중인 서비스가 아닙니다."
        #if !WIWORLD
        case .unavailableToMoveRobot:
            return "로봇과 통신할 수 없어 서비스를 완료할 수 없습니다. 잠시 후 다시 시도해주세요."
        #endif
        default:
            return nil
        }
    }
}
