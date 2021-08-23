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
        case deleteFreight(type: ServiceUnitFreightType, index: Int)
    }

    enum Mutation {
        case updateHeaderView(DetailHeaderCellModel)
        case updateFreights
        case updateMessage
    }

    struct State {
        var headerCellModel: DetailHeaderCellModel?
        var loadFreights: FreightListViewReactor?
        var unloadFreights: FreightListViewReactor?
        var message: String?
    }

    var initialState: State {
        return .init(
            headerCellModel: nil,
            loadFreights: nil,
            unloadFreights: nil,
            message: nil
        )
    }

    let provider: ManagerProviderType

    let swsIdx: Int

    var serviceUnitModel: CreateServiceUnitModel

    var isEditing: Bool

    var indexOfEditingRow: Int?

    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceUnitModel: CreateServiceUnitModel,
        isEditing: Bool = false,
        indexOfEditingRow: Int? = nil
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
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
                .just(.updateFreights),
                .just(.updateMessage)
            ])

        case let .deleteFreight(type, index):
            let otherTypeList = self.serviceUnitModel.serviceUnit.info.freights.filter { $0?.type != type }.compactMap { $0 }
            var list = self.serviceUnitModel.serviceUnit.info.freights.filter { $0?.type == type }.compactMap { $0 }
            list.remove(at: index)
            list.append(contentsOf: otherTypeList)
            self.serviceUnitModel.serviceUnit.info.freights = list
            return .just(.updateFreights)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateHeaderView(model):
            state.headerCellModel = model
            
        case .updateFreights:
            state.loadFreights = self.reactorForFreightList(.load)
            state.unloadFreights = self.reactorForFreightList(.unload)
            
        case .updateMessage:
            if let message = self.serviceUnitModel.serviceUnit.info.message {
                state.message = message
            }
        }
        return state
    }

    func headerCellModel() -> DetailHeaderCellModel {
        return DetailHeaderCellModel(
            type: self.serviceUnitModel.serviceUnit.info.targetType,
            name: self.serviceUnitModel.serviceUnit.targetName,
            groupName: self.serviceUnitModel.serviceUnit.targetGroupName
        )
    }

    func reactorForRecipientList() -> RecipientListViewReactor {
        let list = self.serviceUnitModel.serviceUnit.info.recipients.compactMap { $0 }
        let type: ServiceUnitRecipientType = list.first?.targetType ?? .group
        let model = RecipientListViewModel(type: type, list: list)
        return RecipientListViewReactor(provider: self.provider, swsIdx: self.swsIdx, model: model)
    }

    func reactorForFreightList(_ type: ServiceUnitFreightType) -> FreightListViewReactor {
        let list = self.serviceUnitModel.serviceUnit.info.freights.filter { $0?.type == type }.compactMap { $0 }
        let model = freightListViewModel(type: type, list: list)
        return FreightListViewReactor(model)
    }

    func reactorForTarget() -> CSUTargetViewReactor {
        return CSUTargetViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel
        )
    }
    
    func reactorForFreight(_ type: ServiceUnitFreightType) -> CSUFreightsViewReactor {
        return CSUFreightsViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel,
            freightType: type
        )
    }
    
    func reactorForMessage() -> CSUMessageViewReactor {
        return CSUMessageViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel
        )
    }
}
