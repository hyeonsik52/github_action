//
//  CompleteFindIdViewReactor.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/31.
//

import ReactorKit
import RxSwift

class CompleteFindIdViewReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State { }
    
    var initialState: State {
        return .init()
    }
    
    let provider: ManagerProviderType
    let id: String
    
    init(provider: ManagerProviderType, id: String) {
        self.provider = provider
        self.id = id
    }
}

extension CompleteFindIdViewReactor {
    
    func reactorForSignIn(_ id: String) -> SignInViewReactor {
        return SignInViewReactor(provider: self.provider, id: self.id)
    }
    
    func reactorForResetPasswordWithId(_ id: String) -> CheckIdValidationViewReactor {
        return CheckIdValidationViewReactor(provider: self.provider, id: self.id)
    }
}
