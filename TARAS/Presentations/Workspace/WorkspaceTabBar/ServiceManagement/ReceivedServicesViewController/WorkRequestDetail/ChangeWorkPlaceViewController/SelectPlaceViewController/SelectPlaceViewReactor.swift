//
//  SelectPlaceViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class SelectPlaceViewReactor: Reactor {
    
    let scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case loaded([ServicePlace])
        case setLoading(Bool)
    }
    
    struct State {
        var places: [ServicePlace]
        var isLoading: Bool
    }
    
    var initialState: State {
        return State(places: [], isLoading: false)
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    let selectedStopIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int, selectedStopIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.selectedStopIdx = selectedStopIdx
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                self.provider.networkManager
                    .fetch(SwsStopsConnectionQuery(swsIdx: self.swsIdx))
                    .map { $0.swsStopsConnection.edges.compactMap{ $0.node } }
                    .map { $0.compactMap { ServicePlace(.none, stop: $0) } }
                    .map { swsPlaces -> Mutation in
                        
                        var selected = false
                        func updateSelection(stopIdx: Int) {
                            for place in swsPlaces {
                                let select = (place.idx == stopIdx)
                                place.isSelected = select
                                if select {
                                    selected = true
                                    break
                                }
                            }
                        }
                        
                        updateSelection(stopIdx: self.selectedStopIdx)
                        
                        return .loaded(swsPlaces)
                },
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loaded(let places):
            state.places = places
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
