//
//  SignUpNameViewReactor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/13.
//

import ReactorKit
import RxSwift

class SignUpNameViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)

    enum Action: Equatable {
        case checkValidation(name: String)
        case signUp(name: String)
        case login(withAuth: Bool)
    }
    
    enum Mutation {
        case updateIsValid(Bool)
        case updateIsSignUp(Bool?)
        case updateIsLogin((Bool, Bool)?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var isValid: Bool
        var isSignUp: Bool?
        var isLogin: (Bool, Bool)?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let provider: ManagerProviderType
    
    /// 회원가입 정보
    var accountInfo: Account
    
    let initialState: State = .init(
        isValid: false,
        isSignUp: nil,
        isLogin: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    init(provider: ManagerProviderType, accountInfo: Account) {
        self.provider = provider
        self.accountInfo = accountInfo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkValidation(let name):
            let isValid = InputPolicy.name.matchRange(name)
            return .just(.updateIsValid(isValid))
        case .signUp(let name):
            return self.signUp(name)
        case .login(let withAuth):
            return self.login(withAuth)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateIsValid(let isValid):
            state.isValid = isValid
            state.errorMessage = nil
        case .updateIsSignUp(let isSignUp):
            state.isSignUp = isSignUp
        case .updateIsLogin(let isLogin):
            state.isLogin = isLogin
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    private func signUp(_ name: String) -> Observable<Mutation> {
        guard let clientInfo = self.provider.userManager.userTB.clientInfo else {
            return .empty()
        }
        
        let input = CreateUserMutationInput(
            username: self.accountInfo.id,
            password: self.accountInfo.password,
            displayName: name
        )
        
        return self.signUp(input: input)
    }
        
    private func signUp(input: CreateUserMutationInput) -> Observable<Mutation> {

        let mutation = SignUpMutation(input: input)

        let prevIsValid = self.currentState.isValid
        return .concat([
            .just(.updateIsValid(false)),
            .just(.updateIsProcessing(true)),

            self.provider.networkManager.perform(mutation)
                .map { $0.createUser }
                .flatMap { result -> Observable<Mutation> in
                    if let _ = result?.id {
                        return .just(.updateIsSignUp(true))
                    } else {
                        return .concat([
                            .just(.updateIsValid(prevIsValid)),
                            .just(.updateError(.etc("가입하지 못했습니다.")))
                        ])
                    }
                }
                .catchAndReturn(.updateError(.common(.networkNotConnect))),

            .just(.updateIsProcessing(false))
        ])
    }
        
    private func login(_ withAuth: Bool) -> Observable<Mutation> {
        
        let request: RestAPIType<LoginResponseModel> = .login(input: .init(
            grantType: "password",
            username: self.accountInfo.id,
            password: self.accountInfo.password
        ))
        
        return .concat([
            .just(.updateIsProcessing(true)),
            
            self.provider.networkManager.postByRest(request)
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
                            self.uploadFcmToken(),
                            // 4. 유저 정보 불러오기
                            self.loadUserInfo(withAuth)
                        ])
                    case .failure(let error):
                        
                        return .just(.updateError(.account(.idPasswordNotMatch)))
                    }
                }.catchAndReturn(.updateIsLogin((false, withAuth))),

            .just(.updateIsProcessing(false))
        ])
    }
}

extension SignUpNameViewReactor {
    
    func loadUserInfo(_ withAuth: Bool) -> Observable<Mutation> {
        return self.provider.networkManager.fetch(MyUserInfoQuery())
            .map { $0.signedUser?.fragments.userFragment }
            .flatMapLatest { [weak self] data -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                
                if let user = data {
                    self.provider.userManager.updateUserInfo(user)
                    return .just(.updateIsLogin((true, withAuth)))
                } else {
                    return .just(.updateError(.etc("존재하지 않는 유저입니다.")))
                }
            }
    }

    func uploadFcmToken() -> Observable<Mutation> {
//        guard let token = Messaging.messaging().fcmToken, let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString else {
//            return .empty()
//        }
//
//        let input = UpdateFcmRegistrationIdInput(
//            clientType: "ios",
//            deviceUniqueKey: deviceUniqueKey,
//            registrationId: token
//        )
//
//        Log.info("\(input)")
//
//
//
//        return self.provider.networkManager
//            .perform(UpdateFcmTokenMutation(input: input))
//            .map { $0.updateFcmRegistrationIdMutation }
//            .flatMapLatest { result -> Observable<Mutation> in
//                if let payload = result.asUpdateFcmRegistrationIdPayload {
//                    if payload.result.isTrue {
//                        Log.complete("updated FCM token to server")
//                    }else{
//                        Log.complete("Failed FCM token updated to server")
//                    }
//                }else if let error = result.asUpdateFcmRegistrationIdError {
//                    Log.err("Failed to update FCM token to server: \(error.errorCode)")
//                }
//                return .empty()
//            }
        return .empty()
    }
}


extension SignUpNameViewReactor {
    
    func reactorForWorkspaceList() -> WorkspaceListViewReactor {
        return .init(provider: self.provider, isFrom: .signIn)
    }
    
    func reactorForSetting() -> DefaultMyInfoViewReactor {
        return .init(provider: self.provider)
    }
}
