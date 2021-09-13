//
//  CSUFreightsViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class CSUFreightsViewReactor: Reactor {
    
    enum Action {
        case setFreightType
//        case toggleFreightMode
        case setName(String)
    }
    
    enum Mutation {
        case updateFreightType
//        case updateFreightMode(ServiceUnitFreightType)
        case updateName(String)
    }
    
    struct State {
//        var freightType: ServiceUnitFreightType
        var freightName: String
    }
    
    var initialState: State {
//        return .init(freightType: .unload, freightName: "")
        return .init(freightName: "")
    }
    
    let provider : ManagerProviderType
    
    let swsIdx: Int
    
    var serviceUnitModel: CreateServiceUnitModel
    
//    var freightType: ServiceUnitFreightType
    
    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceUnitModel: CreateServiceUnitModel//,
//        freightType: ServiceUnitFreightType
        
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceUnitModel = serviceUnitModel
//        self.freightType = freightType
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case .toggleFreightMode:
//            return .just(.updateFreightMode(self.currentState.freightType))
            
        case let .setName(name):
            return .just(.updateName(name))
            
        case .setFreightType:
            return .just(.updateFreightType)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateFreightType:
//            state.freightType = self.freightType
            return state
            
//        case let .updateFreightMode(mode):
//            state.freightType = (mode == .load) ? .unload: .load
//            return state
            
        case let .updateName(name):
            state.freightName = name
            return state
        }
    }
    
    func reactorForQuantitiy() -> CSUQuantityViewReactor {
        return CSUQuantityViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel,
            freightName: self.currentState.freightName,
//            freightMode: self.currentState.freightType
        )
    }
}
