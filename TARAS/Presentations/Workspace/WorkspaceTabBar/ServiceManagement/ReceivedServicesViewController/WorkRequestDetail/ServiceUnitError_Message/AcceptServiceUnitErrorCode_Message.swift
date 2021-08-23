//
//  AcceptServiceUnitErrorCode_Message.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/08/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension AcceptServiceUnitErrorCode: ServiceUnitErrorMessage {

    var message: String? {
        switch self {
        case .forbidden:
            return "권한이 없습니다."
        case .serviceUnitNotExist:
            return "서비스가 존재하지 않습니다."
        case .acceptedServiceUnit:
            return "이미 수락된 서비스입니다."
        case .rejectedServiceUnit:
            return "이미 거절된 서비스입니다."
        case .canceledServiceUnit:
            return "요청이 취소된 서비스입니다."
        case .alreadyResponded:
            return "이미 응답한 서비스입니다."
        case .stopIdxRequired:
            return "장소 정보가 필요합니다."
        default:
            return nil
        }
    }
}
