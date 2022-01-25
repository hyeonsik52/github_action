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
    let isIconVisibled: Bool
    let highlightRanges: [NSRange]
    
    init(
        model: ServiceUnitTargetModel,
        selectionType: ServiceUnitTargetSelectionType,
        isEnabled: Bool = true,
        isIconVisibled: Bool = true,
        highlightRanges: [NSRange] = []
    ) {
        self.selectionType = selectionType
        self.initialState = model
        self.isEnabled = isEnabled
        self.isIconVisibled = isIconVisibled
        self.highlightRanges = highlightRanges
    }
}
