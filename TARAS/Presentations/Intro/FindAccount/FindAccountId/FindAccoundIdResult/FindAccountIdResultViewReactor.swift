//
//  FindAccountIdResultViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit

class FindAccountIdResultViewReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: [String]
    
    let provider: ManagerProviderType
    
    init(provider: ManagerProviderType, ids: [String]) {
        self.provider = provider
        self.initialState = ids
    }
    
    func reactorForFindPassword() -> FindAccountIdViewReactor {
        return FindAccountIdViewReactor(provider: self.provider)
    }
}
