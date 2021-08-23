//
//  RecipientListViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

struct RecipientListViewModel {
    var type: ServiceUnitRecipientType
    var list: [CreateRecipientInput]
}

class RecipientListViewReactor: Reactor {
    typealias Action = NoAction

    let provider: ManagerProviderType
    let swsIdx: Int
    let initialState: RecipientListViewModel

    init(provider: ManagerProviderType, swsIdx: Int, model: RecipientListViewModel) {
        self.initialState = model
        self.provider = provider
        self.swsIdx = swsIdx
    }
    
    func reactorForCell(_ input: CreateRecipientInput) -> RecipientListCellViewReactor {
        return RecipientListCellViewReactor(provider: provider, recipientInput: input, swsIdx: swsIdx)
    }
}
