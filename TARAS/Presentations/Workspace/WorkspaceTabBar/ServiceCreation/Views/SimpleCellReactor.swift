//
//  SimpleCellReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/17.
//

import ReactorKit

class SimpleCellReactor<T>: Reactor {
    typealias Action = NoAction
    
    let initialState: T
    
    init(model: T) {
        self.initialState = model
    }
}
