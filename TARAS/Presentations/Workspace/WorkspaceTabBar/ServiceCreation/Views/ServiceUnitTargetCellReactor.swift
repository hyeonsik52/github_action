//
//  ServiceUnitTargetCellReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/01.
//

import ReactorKit

class ServiceUnitTargetCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: ServiceUnitTargetModel
    let selectionType: ServiceUnitTargetSelectionType
    let isEnabled: Bool
    
    init(model: ServiceUnitTargetModel, selectionType: ServiceUnitTargetSelectionType, isEnabled: Bool = true) {
        self.selectionType = selectionType
        self.initialState = model
        self.isEnabled = isEnabled
    }
}
