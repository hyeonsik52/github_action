//
//  LaunchScreenViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import ReactorKit

class LaunchScreenViewReactor: Reactor {

    enum Action: Equatable {
        case checkRealm(isOpened: Bool)
    }

    enum Mutation {
        case updateAutoSignInEnablility(isEnabled: Bool)
    }

    struct State {
        var isAutoSignInEnabled: Bool?
    }

    let provider: ManagerProviderType
    
    let initialState: State = .init(
        isAutoSignInEnabled: nil
    )
    
    init(provider: ManagerProviderType) {
        self.provider = provider
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .checkRealm(isOpened):
            return self.checkRealm(isOpened)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateAutoSignInEnablility(isEnabled):
            state.isAutoSignInEnabled = isEnabled
        }
        return state
    }
}


// MARK: - Mutation Methods

extension LaunchScreenViewReactor {

    private func checkRealm(_ isOpened: Bool) -> Observable<Mutation> {
        if isOpened {
            // Realm 이 성공적으로 open 되었다면
            // 1. clien info 를 업데이트
            self.provider.userManager.updateClientInfo()
            
            // 2. accessToken, refreshToken 이 DB 에 존재하는지로 자동 로그인 가능 여부 판단, 전달
            let hasToken = self.provider.userManager.hasTokens
            return .just(.updateAutoSignInEnablility(isEnabled: hasToken))
        }
        return .empty()
    }
}


// MARK: - Reactor For

extension LaunchScreenViewReactor {
    
//    func reactorForSignIn() -> SignInViewReactor {
//        return SignInViewReactor(provider: self.provider)
//    }
//
//    func reactorForWorkspaceList() -> WorkspaceListViewReactor {
//        return WorkspaceListViewReactor(provider: self.provider, isFrom: .launch)
//    }
}
