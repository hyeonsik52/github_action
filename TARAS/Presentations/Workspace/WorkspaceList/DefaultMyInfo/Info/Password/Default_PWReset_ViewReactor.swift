//
//  Default_PWReset_ViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/31.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit

class Default_PWReset_ViewReactor: Reactor {
    
    enum Action {
        case setPW(String)
    }

    enum Mutation {
        case updateIsLoading(Bool)
        case updateErrorMessage(String?)
    }

    struct State {
        var isLoading: Bool
        var errorMessage: String?
    }

    let provider: ManagerProviderType

    var password: String = ""
    
    let authCode: String

    let initialState: State

    init(provider: ManagerProviderType, authCode: String) {
        self.provider = provider
        self.authCode = authCode
        
        self.initialState = .init(isLoading: false, errorMessage: nil)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPW(password):
            self.password = password
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateIsLoading(isLoading):
            state.isLoading = isLoading

        case let .updateErrorMessage(errorMessage):
            state.errorMessage = errorMessage
        }
        return state
    }

    func reactorForConfirmPW() -> Default_PWConfirmed_ViewReactor {
        return Default_PWConfirmed_ViewReactor(
            provider: self.provider,
            password: self.password,
            authCode: self.authCode
        )
    }
}
