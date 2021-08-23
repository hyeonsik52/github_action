//
//  CSUQuantityViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class CSUQuantityViewReactor: Reactor {
    
    enum Action {
        case updateQuantity(String?)
        case increase
        case decrease
    }
    
    enum Mutation {
        case setQuantity(Int)
        case setIncrease
        case setDecrease
    }
    
    struct State {
        var quantity: Int
        var quantityChangedByButton: Int
    }
    
    var initialState: State {
        return .init(quantity: 1, quantityChangedByButton: 1)
    }
    
    let provider : ManagerProviderType
    
    let swsIdx: Int
    
    var serviceUnitModel: CreateServiceUnitModel
    
    var freightName: String
    
    var freightMode: ServiceUnitFreightType
    
    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceUnitModel: CreateServiceUnitModel,
        freightName: String,
        freightMode: ServiceUnitFreightType
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceUnitModel = serviceUnitModel
        self.freightName = freightName
        self.freightMode = freightMode
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuantity(quantityString):
            let quantity = Int(quantityString ?? "0") ?? 0
            return .just(.setQuantity(quantity))
            
        case .increase:
            guard self.currentState.quantity != 9999 else {
                return .empty()
            }
            return .just(.setIncrease)
            
        case .decrease:
            print(self.currentState.quantity)
            guard self.currentState.quantity != 0 else {
                return .empty()
            }
            return .just(.setDecrease)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setQuantity(quantity):
            state.quantity = quantity
            return state
            
        case .setIncrease:
            let result = state.quantity + 1
            state.quantity = result
            return state
            
        case .setDecrease:
            let result = state.quantity - 1
            state.quantity = result
            return state
        }
    }
    
    func updateCreateServiceUnitInput() -> CreateServiceUnitModel {
        let freightType: ServiceUnitFreightType = (self.freightMode == .load) ? .load: .unload
        let freightInput = CreateServiceUnitFreightInput(
            name: self.freightName,
            quantity: self.currentState.quantity,
            type: freightType
        )
        
        self.serviceUnitModel.serviceUnit.info.freights.append(freightInput)
        return self.serviceUnitModel
    }
    
    func reactorForDetail() -> CSUDetailViewReactor {
        return CSUDetailViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel
            
        )
    }
}
