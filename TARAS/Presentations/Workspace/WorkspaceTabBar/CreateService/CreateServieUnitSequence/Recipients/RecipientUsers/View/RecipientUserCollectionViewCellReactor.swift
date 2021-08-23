//
//  RecipientUserCollectionViewCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class RecipientUserCollectionViewCellReactor: Reactor {
    typealias Action = NoAction

    let initialState: RecipientCellModel

    init(_ model: RecipientCellModel) {
        self.initialState = model
    }
}
