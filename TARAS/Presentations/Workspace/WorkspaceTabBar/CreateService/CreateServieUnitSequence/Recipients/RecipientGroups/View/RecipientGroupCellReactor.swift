//
//  RecipientGroupCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/11.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class RecipientGroupCellReactor: Reactor {
    typealias Action = NoAction

    var initialState: RecipientCellModel

    init(_ model: RecipientCellModel) {
        self.initialState = model
    }
}
