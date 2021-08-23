//
//  FreightListViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

struct freightListViewModel {
    var type: ServiceUnitFreightType
    var list: [CreateServiceUnitFreightInput]
}

class FreightListViewReactor: Reactor {
    typealias Action = NoAction

    let initialState: freightListViewModel

    init(_ model: freightListViewModel) {
      self.initialState = model
    }
}
