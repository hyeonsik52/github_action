//
//  FreightListCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class FreightListCellReactor: Reactor {
    typealias Action = NoAction

    let initialState: FreightListCellModel

    init(_ model: FreightListCellModel) {
      self.initialState = model
    }
}
