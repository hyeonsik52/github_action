//
//  RecipientListCellViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class RecipientListCellViewReactor: Reactor {

    enum Action {
        case setData
    }

    enum Mutation {
        case updateData(RecipientListCellModel)
    }

    let provider: ManagerProviderType
    let recipientInput: User
    let workspaceId: String

    struct State {
        var name: String?
    }

    var initialState: State
    
    init(provider: ManagerProviderType, recipientInput: User, workspaceId: String) {
        self.provider = provider
        self.recipientInput = recipientInput
        self.workspaceId = workspaceId
        
        self.initialState = .init(name: recipientInput.displayName)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setData:
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateData(model):
            state.name = model.name
        }
        return state
    }
}
