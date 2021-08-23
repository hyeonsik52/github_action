//
//  ServiceContainerCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class ServiceContainerCellReactor: Reactor {
    typealias Action = NoAction
    
    var initialState: [ServiceModelSection]
    
    init(models: [ServiceModelSection]) {
        self.initialState = models
    }
}
