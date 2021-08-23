//
//  StartServiceUnitErrorCode_Message.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/08/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension StartServiceUnitErrorCode: ServiceUnitErrorMessage {
    
    var message: String? {
        switch self {
        case .forbidden:
            return "권한이 없습니다."
        case .serviceUnitNotExist:
            return "서비스가 존재하지 않습니다."
        default:
            return nil
        }
    }
}
