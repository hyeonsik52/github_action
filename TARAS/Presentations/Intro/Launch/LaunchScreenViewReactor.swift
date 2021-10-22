//
//  LaunchScreenViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import ReactorKit

class LaunchScreenViewReactor: Reactor {

    enum Action: Equatable {
        case check(isRealmOpened: Bool)
    }

    enum Mutation {
        case updateAutoSignInEnablility(Bool)
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
        case .check(let isRealmOpened):
            return self.check(isRealmOpened)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateAutoSignInEnablility(let isEnabled):
            state.isAutoSignInEnabled = isEnabled
        }
        return state
    }
}


// MARK: - Mutation Methods

extension LaunchScreenViewReactor {

    private func check(_ isRealmOpened: Bool) -> Observable<Mutation> {
        if isRealmOpened {
            // Realm 이 성공적으로 open 되었다면
            // 1. clien info 를 업데이트
            self.provider.userManager.updateClientInfo()
            
            // 2. 최소 버전 확인
            return self.provider.networkManager.tempVersionCheck()
                .map { $0 == nil }
                .flatMapLatest { isValid -> Observable<Mutation> in
                    if isValid {
                        // 3-1. accessToken, refreshToken 이 DB 에 존재하는지로 자동 로그인 가능 여부 판단, 전달
                        let hasToken = self.provider.userManager.hasTokens
                        return .just(.updateAutoSignInEnablility(hasToken))
                    } else {
                        // 3-2. 업데이트 알림 표출 -> AppDelegate 또는 SceneDelegate에서 표시하므로 무시함
                        return .empty()
                    }
                }
        }
        return .empty()
    }
}


// MARK: - Reactor For

extension LaunchScreenViewReactor {
    
    func reactorForSignIn() -> SignInViewReactor {
        return SignInViewReactor(provider: self.provider)
    }

    func reactorForWorkspaceList() -> WorkspaceListViewReactor {
        return WorkspaceListViewReactor(provider: self.provider, isFrom: .launch)
    }
}
