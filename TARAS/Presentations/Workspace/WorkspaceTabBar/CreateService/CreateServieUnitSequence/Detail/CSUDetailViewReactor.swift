//
//  CSUDetailViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit

class CSUDetailViewReactor: Reactor {

    enum Action {
        case setServiceUnit
    }

    enum Mutation {
        case updateHeaderView(DetailHeaderCellModel)
        case updateMessage
    }

    struct State {
        var headerCellModel: DetailHeaderCellModel?
        var message: String?
    }

    var initialState: State {
        return .init(
            headerCellModel: nil,
            message: nil
        )
    }

    let provider: ManagerProviderType

    let workspaceId: String

    var serviceUnitModel: CreateServiceUnitModel

    var isEditing: Bool

    var indexOfEditingRow: Int?

    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceUnitModel: CreateServiceUnitModel,
        isEditing: Bool = false,
        indexOfEditingRow: Int? = nil
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceUnitModel = serviceUnitModel
        
        self.isEditing = isEditing
        self.indexOfEditingRow = indexOfEditingRow
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setServiceUnit:
            let headerCellModel = self.headerCellModel()
            return .concat([
                .just(.updateHeaderView(headerCellModel)),
                .just(.updateMessage)
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateHeaderView(model):
            state.headerCellModel = model
            
        case .updateMessage:
            if let message = self.serviceUnitModel.serviceUnit.message {
                state.message = message
            }
        }
        return state
    }

    func headerCellModel() -> DetailHeaderCellModel {
        return DetailHeaderCellModel(
            name: self.serviceUnitModel.serviceUnit.targetName
        )
    }

    func reactorForRecipientList() -> RecipientListViewReactor {
        let list = self.serviceUnitModel.serviceUnit.recipients.compactMap { $0 }
        return RecipientListViewReactor(provider: self.provider, workspaceId: self.workspaceId, models: list)
    }

    func reactorForTarget() -> CSUTargetViewReactor {
        return CSUTargetViewReactor(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnitModel: self.serviceUnitModel
        )
    }
    
    func reactorForMessage() -> CSUMessageViewReactor {
        return CSUMessageViewReactor(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnitModel: self.serviceUnitModel
        )
    }
}
