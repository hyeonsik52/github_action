//
//  AddWaypointViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit

class AddWaypointViewReactor: Reactor {

    enum Action {
        case setSection
    }

    enum Mutation {
        case updateSection(AddWaypointSection)
    }

    struct State {
        var section: [AddWaypointSection]
    }

    var initialState: State {
        return .init(section: [])
    }

    let provider: ManagerProviderType
    
    let swsIdx: Int
    
    var section: [CreateServiceSection]
    
    init(provider: ManagerProviderType, swsIdx: Int, section: [CreateServiceSection]) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.section = section
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setSection:
            if let items = self.section.first?.items {
                let convertedItems = items.compactMap {
                    AddWaypointCellViewReactor(
                        provider: $0.provider,
                        swsIdx: $0.swsIdx,
                        serviceUnitModel: $0.serviceUnitModel
                    )
                }
                
                let section = AddWaypointSection(items: convertedItems)
                return .just(.updateSection(section))
            }
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateSection(section):
            state.section = [section]
            return state
        }
    }
    
    func reactorForWaypoint(_ willAppendAt: Int) -> WaypointViewReactor {
        return WaypointViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            waypointInput: nil,
            willAppendAt: willAppendAt
        )
    }
}
