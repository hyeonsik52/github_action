//
//  RecipientListViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class RecipientListViewReactor: Reactor {
    typealias Action = NoAction

    let provider: ManagerProviderType
    let workspaceId: String
    let initialState: [User]

    init(provider: ManagerProviderType, workspaceId: String, models: [User]) {
        self.initialState = models
        self.provider = provider
        self.workspaceId = workspaceId
    }
    
    func reactorForCell(_ input: User) -> RecipientListCellViewReactor {
        return RecipientListCellViewReactor(provider: provider, recipientInput: input, workspaceId: workspaceId)
    }
}
