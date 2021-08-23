//
//  ServiceTargetCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class ServiceTargetCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: ServiceUnitUserResponse
    
    init(response: ServiceUnitUserResponse) {
        self.initialState = response
    }
}
