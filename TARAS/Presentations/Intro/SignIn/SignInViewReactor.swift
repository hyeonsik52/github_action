//
//  SignInViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import ReactorKit
import RxSwift

class SignInViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case checkValidation(id: String, password: String)
        case signIn(id: String, password: String)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsSignIn(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isSignIn: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    let initialState: State = .init(
        isValid: false,
        isSignIn: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .checkValidation(id, password):
            let isValid = id.count > 0 && password.count > 0
            return .just(.updateIsValid(isValid))
        case let .signIn(id, password):
            
            // 로그인 시도 전, 아이디와 비밀번호 포맷 검사
            guard InputPolicy.id.matchFormat(id) else {
                return .just(.updateError(.common(.invalidInputFormat(.id))))
            }
            guard InputPolicy.password.matchFormat(password) else {
                return .just(.updateError(.common(.invalidInputFormat(.password))))
            }
            guard let clientInfo = self.provider.userManager.userTB.clientInfo else {
                return .empty()
            }
            
            let request = LoginRequestModel(
                grantType: "password",
                username: id,
                password: password
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
                        case .failure(let error):
                            
                            return .just(.updateError(.account(.idPasswordNotMatch)))
                        }
                    }.catchAndReturn(.updateError(.common(.networkNotConnect))),

                .just(.updateIsProcessing(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
        case .updateIsSignIn(let isSignIn):
            state.isSignIn = isSignIn
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    func reactorForSignUp() -> SignUpIdViewReactor {
        return SignUpIdViewReactor(provider: self.provider)
    }

    func reactorForWorkspaceList() -> WorkspaceListViewReactor {
        return WorkspaceListViewReactor(provider: self.provider, isFrom: .signIn)
    }

    func reactorForForgotAccount() -> SignInViewReactor {
        return SignInViewReactor(provider: self.provider)
    }
}

extension SignInViewReactor {
    
    func loadUserInfo() -> Observable<Mutation> {
        return self.provider.networkManager.fetch(MyUserInfoQuery())
            .map { $0.signedUser?.fragments.userFragment }
            .flatMapLatest { [weak self] data -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                
                if let user = data {
                    self.provider.userManager.updateUserInfo(user)
                    return .just(.updateIsSignIn(true))
                } else {
                    return .just(.updateError(.etc("존재하지 않는 유저입니다.")))
                }
            }.catchAndReturn(.updateError(.common(.networkNotConnect)))
    }
}
