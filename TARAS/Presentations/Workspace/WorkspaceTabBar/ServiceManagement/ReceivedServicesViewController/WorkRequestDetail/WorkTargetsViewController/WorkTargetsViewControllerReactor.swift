//
//  WorkTargetsViewControllerReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class WorkTargetsViewControllerReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: ServiceUnitModel
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int, serviceUnit: ServiceUnitModel) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.initialState = serviceUnit
    }
    
    func reactorForSwsUserInfo(userIdx: Int) -> SWSUserInfoViewReactor {
        return SWSUserInfoViewReactor(provider: self.provider, swsIdx: self.swsIdx, userIdx: userIdx)
    }
}

