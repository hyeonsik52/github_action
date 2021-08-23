//
//  WaypointViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Twinny on 2020/07/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit

class WaypointViewReactor: Reactor {

    enum Action {
        case setSection
    }

    enum Mutation {
        case updateSection(WaypointSection)
    }

    struct State {
        var section: [WaypointSection]
    }

    var initialState: State {
        return .init(section: [])
    }

    let provider: ManagerProviderType
    
    let swsIdx: Int
    
    let willAppendAt: Int?
    
    var waypointInput: CreateServiceUnitInput?
    
    
    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        waypointInput: CreateServiceUnitInput?,
        willAppendAt: Int? = nil
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.waypointInput = waypointInput
        self.willAppendAt = willAppendAt
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setSection:
            return self.provider.networkManager
                .fetch(StopsListQuery(first: .max32, swsIdx: self.swsIdx))
                .map { $0.swsStopsConnection.edges }
                .flatMap { edges -> Observable<Mutation> in
                    let items = edges
                        .compactMap { TargetStopCellModel(stop: $0.node) }
                        .sorted(by: { $0.name < $1.name })
                        .map { WaypointCellViewReactor.init(
                            provider: self.provider,
                            swsIdx: self.swsIdx,
                            cellModel: $0
                        )}

                    let section = WaypointSection(items: items)
                    return .just(.updateSection(section))
            }
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
}
