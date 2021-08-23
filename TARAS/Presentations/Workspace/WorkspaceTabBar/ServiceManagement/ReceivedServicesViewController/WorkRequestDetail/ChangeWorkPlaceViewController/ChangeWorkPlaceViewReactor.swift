//
//  ChangeWorkPlaceViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/15.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class ChangeWorkPlaceViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
        case update(ServicePlace)
        case accept
    }
    
    enum Mutation {
        case setPlace(ServicePlace?)
        case accepted(Bool?)
        case isProcessing(Bool?)
        case setAlertMessage(String?)
    }
    
    struct State {
        var place: ServicePlace?
        var isAccepted: Bool?
        var isProcessing: Bool?
        var alertMessage: String?
    }
    
    let initialState: State
    
    let provider : ManagerProviderType
    let swsIdx: Int
    let serviceUnitIdx: Int
    let acceptType: ServiceUnitResponseType
    
    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceUnitIdx: Int,
        acceptType: ServiceUnitResponseType,
        place: ServicePlace?
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceUnitIdx = serviceUnitIdx
        self.acceptType = acceptType
        self.initialState = State(place: place, isAccepted: nil, isProcessing: nil, alertMessage: nil)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let stopIdx = self.currentState.place?.idx ?? -1
            return self.provider.networkManager.fetch(SwsStopsConnectionQuery(swsIdx: self.swsIdx))
                .map { $0.swsStopsConnection.edges.compactMap{$0.node}.first{ $0.stopIdx == stopIdx } }
                .map { ServicePlace(.none, stop: $0) }
                .map { Mutation.setPlace($0) }
        case .update(let place):
            return .just(.setPlace(place))
        case .accept:
            let input = AcceptServiceUnitInput(responseType: self.acceptType, serviceUnitIdx: self.serviceUnitIdx, stopIdx: self.currentState.place?.idx)
            return .concat([
                .just(.isProcessing(true)),
                self.provider.networkManager
                    .perform(AcceptServiceUnitMutationMutation(input: input))
                    .map { $0.acceptServiceUnitMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let payload = data.asAcceptServiceUnitPayload {
                            let result = (payload.result == "1")
                            return .just(.accepted(result))
                        }else if let error = data.asAcceptServiceUnitError {
                            return .concat([
                                .just(.accepted(false)),
                                .just(.setAlertMessage(error.errorCode.message)),
                                .just(.setAlertMessage(nil))
                            ])
                        }
                        return .just(.accepted(false))
                },
                .just(.isProcessing(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPlace(let place):
            state.place = place
        case .accepted(let isSuccess):
            state.isAccepted = isSuccess
        case .isProcessing(let processing):
            state.isProcessing = processing
        case .setAlertMessage(let message):
            state.alertMessage = message
        }
        return state
    }
    
    func reactorForSelectPlace() -> SelectPlaceViewReactor {
        let stopIdx = self.currentState.place?.idx ?? -1
        return SelectPlaceViewReactor(provider: self.provider, swsIdx: self.swsIdx, selectedStopIdx: stopIdx)
    }
}
