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
    let recipientInput: CreateRecipientInput
    let swsIdx: Int

    struct State {
        var name: String?
        var groupName: String?
    }

    var initialState: State {
            .init(name: nil, groupName: nil)
    }

    init(provider: ManagerProviderType, recipientInput: CreateRecipientInput, swsIdx: Int) {
        self.provider = provider
        self.recipientInput = recipientInput
        self.swsIdx = swsIdx
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setData:
            if self.recipientInput.targetType == .user
            {
                return self.provider.networkManager
                    .fetch(UserInfoes(userIdx: self.recipientInput.targetIdx, swsIdx: self.swsIdx))
                    .compactMap { $0.userByUserIdx.asUser }
                    .map { RecipientListCellModel(type: .user, name: $0.userSwsInfo?.asUserSwsInfo?.name ?? $0.name, groupName: $0.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name ?? "") }
                    .map(Mutation.updateData)
            }
            else if self.recipientInput.targetType == .group
            {
                return self.provider.networkManager
                    .fetch(GroupByGroupIdxQuery(groupIdx: self.recipientInput.targetIdx))
                    .map { $0.groupByGroupIdx.asGroup?.name ?? "" }
                    .map { RecipientListCellModel(type: .group, name: $0, groupName: nil) }
                    .map(Mutation.updateData)
            }
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateData(model):
            state.name = model.name
            state.groupName = model.groupName
            return state
        }
    }
}
