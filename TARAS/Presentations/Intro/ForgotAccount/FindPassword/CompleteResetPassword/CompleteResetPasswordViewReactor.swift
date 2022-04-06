//
//  CompleteResetPasswordViewReactor.swift
//  TARAS
//
//  Created by 오현식 on 2022/04/05.
//

import ReactorKit
import RxSwift

class CompleteResetPasswordViewReactor: Reactor {
    
    enum Action {
        case logIn
    }
    
    enum Mutation {
        case updateIsLogIn(Bool)
        case updateIsProcessing(Bool)
    }
    
    struct State {
        var isLogIn: Bool
        var isProcessing: Bool
    }
    
    let initialState: State = .init(
        isLogIn: false,
        isProcessing: false
    )
    
    let provider: ManagerProviderType
    let id: String
    let password: String
    
    init(provider: ManagerProviderType, id: String, password: String) {
        self.provider = provider
        self.id = id
        self.password = password
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .logIn:
            let request = LoginRequestModel(
                grantType: "password",
                username: self.id,
                password: self.password
            )
            
            return .concat([
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.rest.call(.api(request))
                    .flatMapLatest { [weak self] result -> Observable<Mutation> in
                        guard let self = self else { return .empty() }
                        
                        switch result {
                        case .success(let payload):
                            
                            // 1. 토큰 업데이트
                            self.provider.userManager.updateTokens(
                                access: payload.accessToken,
                                refresh: payload.refreshToken
                            )
                            
                            // 2. 웹소켓 정보 업데이트
                            self.provider.networkManager.updateWebSocketTransportConnectingPayload()
                            
                            return .concat([
                                // 3. FCM 토큰 업로드
                                self.provider.networkManager.fcm.register(auto: #function),
                                // 4. 유저 정보 불러오기
                                self.loadUserInfo()
                            ])
                        case .failure(_):
                            return .just(.updateIsLogIn(false))
                        }
                    },
                
                .just(.updateIsProcessing(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsLogIn(let isLogIn):
            state.isLogIn = isLogIn
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        }
        return state
    }
    
    func reactorForWorkspaceList() -> WorkspaceListViewReactor {
        return WorkspaceListViewReactor(provider: self.provider, isFrom: .signIn)
    }
}

extension CompleteResetPasswordViewReactor {
    
    func loadUserInfo() -> Observable<Mutation> {
        return self.provider.networkManager.fetch(MyUserInfoQuery())
            .map { $0.signedUser?.fragments.userFragment }
            .flatMapLatest { [weak self] data -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                
                if let user = data {
                    self.provider.userManager.updateUserInfo(user)
                    return .just(.updateIsLogIn(true))
                } else {
                    return .just(.updateIsLogIn(false))
                }
            }
    }
}
