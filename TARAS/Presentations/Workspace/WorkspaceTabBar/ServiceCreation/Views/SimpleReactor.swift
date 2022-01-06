//
//  SimpleReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/17.
//

import ReactorKit
import Foundation

class SimpleReactor<T>: Reactor {
    typealias Action = NoAction
    
    var initialState: T?
    
    let provider: ManagerProviderType
    let workspaceId: String?
    
    init(provider: ManagerProviderType, workspaceId: String? = nil, model: T? = nil) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.initialState = model
    }
}
