//
//  SelectDefaultPlaceViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class SelectDefaultPlaceViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
        case update(stopIdx: Int)
    }
    
    enum Mutation {
        case loadedSwsPlaces([ServicePlace])
        case placeUpdate(ServicePlace?)
        case setLoading(Bool?)
        case setProcessing(Bool)
    }
    
    struct State {
        var swsPlaces: [ServicePlace]
        var placeUpdated: ServicePlace?
        var isLoading: Bool?
        var isProcessing: Bool
    }
    
    var initialState: State {
        return .init(swsPlaces: [], placeUpdated: nil, isLoading: nil, isProcessing: false)
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        func refresh() -> Observable<Mutation> {
            return .zip(
                self.provider.networkManager
                    .fetch(SwsStopsToSetMyStopConnectionQuery(swsIdx: self.swsIdx))
                    .map { $0.swsStopsToSetMyStopConnection.edges.compactMap{ $0.node } }
                    .map { $0.compactMap { ServicePlace(.none, stop: $0) } },
                self.provider.networkManager
                    .fetch(MyUserInfoQuery(swsIdx: self.swsIdx))
                    .map { UserInfo($0.myUserInfo.asUser)?.swsUserInfo }) { swsPlaces, swsInfo -> Mutation in
                        
                        var list = swsPlaces
                        if let existedPlace = swsInfo?.place {
                            existedPlace.isSelected = true
                            list.insert(existedPlace, at: 0)
                        }
                        
                        return .loadedSwsPlaces(list)
            }
        }
        
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                
                refresh(),
                
                .just(.setLoading(false))
            ])
        case let .update(stopIdx):
            return .concat([
                .just(.setProcessing(true)),
                
                self.provider.networkManager
                    .fetch(MyUserInfoQuery(swsIdx: self.swsIdx))
                    .compactMap { UserInfo($0.myUserInfo.asUser) }
                    .map { UpdateUserSWSInfoStopInput(stopIdx: stopIdx, swsIdx: self.swsIdx, userIdx: $0.idx) }
                    .flatMapLatest {
                        self.provider.networkManager.perform(UpdateUserSwsInfoStopMutationMutation(input: $0))
                            .compactMap { $0.updateUserSwsInfoStopMutation.asUserSwsInfo?.stop?.asStop }
                            .compactMap{ ServicePlace(.none, stop: $0) }.map { Mutation.placeUpdate($0) }
                },
                refresh(),
                
                .just(.setProcessing(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedSwsPlaces(places):
            state.swsPlaces = places
            print(places.compactMap{$0.name}.reduce("", {$0 + " / " + $1}))
        case let .placeUpdate(place):
            print(place?.name ?? "")
            state.placeUpdated = place
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setProcessing(isProcessing):
            state.isProcessing = isProcessing
        }
        return state
    }
}
