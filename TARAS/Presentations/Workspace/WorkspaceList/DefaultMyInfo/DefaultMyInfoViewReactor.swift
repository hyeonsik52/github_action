//
//  DefaultMyInfoViewReactor.swift
//
//  Created by Suzy Park on 2020/07/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import FirebaseMessaging

class DefaultMyInfoViewReactor: Reactor {
    
    typealias Version = (currentVersion: String, isThisLatest: Bool)
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case reload
        case logout
        case resign
    }
    
    enum Mutation {
        case updateAccount(Account?)
        case updateVersion(Version?)
        case updateIsLogout(Bool?)
        case updateIsResign(Bool?)
        case updateIsLoading(Bool?)
        case updateIsProcessing(Bool)
        case updateError(TRSError?)
    }
    
    struct State {
        var account: Account?
        var version: Version?
        var isLogout: Bool?
        var isResign: Bool?
        var isLoading: Bool?
        var isProcessing: Bool
        var errorMessage: String?
    }
    
    let initialState: State = .init(
        account: nil,
        version: nil,
        isLogout: nil,
        isResign: nil,
        isLoading: nil,
        isProcessing: false,
        errorMessage: nil
    )
    
    let provider: ManagerProviderType
    
    init(provider: ManagerProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reload:
            return self.reload()
        case .logout:
            return self.logout()
        case .resign:
            return self.resign()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateAccount(let account):
            state.account = account
        case .updateVersion(let version):
            state.version = version
        case .updateIsLogout(let isLogout):
            state.isLogout = isLogout
        case .updateIsResign(let isResign):
            state.isResign = isResign
        case .updateIsLoading(let isLoading):
            state.isLoading = isLoading
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateError(let error):
            state.errorMessage = error?.description
        }
        return state
    }
    
    private func reload() -> Observable<Mutation> {
        return .concat([
            .just(.updateError(nil)),
            .just(.updateIsLoading(true)),
            
            self.provider.networkManager
                .fetch(MyUserInfoQuery())
                .flatMapLatest { result -> Observable<Mutation> in
                    if let fragment = result.signedUser?.fragments.userFragment {
                        return .just(.updateAccount(.init(fragment)))
                    } else {
                        return .empty()
                    }
                }
                .catchAndReturn(.updateError(.common(.networkNotConnect))),
            
            self.provider.networkManager
                .clientVersionCheck()
                .map {
                    let thisVersionName = Info.appVersion
                    guard let versionCheck = $0 else {
                        return .updateVersion((thisVersionName, true))
                    }
                    let version = (thisVersionName, versionCheck.isLatest)
                    return .updateVersion(version)
                },
            
            .just(.updateIsLoading(false))
        ])
    }
    
    private func logout() -> Observable<Mutation> {
        guard let accessToken = self.provider.userManager.userTB.accessToken,
              let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString
        else { return .empty() }
        
        func goSignIn() -> Observable<Mutation> {
            self.provider.userManager.initializeUserTB()
            return .just(.updateIsLogout(true))
        }
        
        return self.getFCMToken()
            .filterNil()
            .flatMapLatest { token -> Observable<Mutation> in
                let mutation = UnregisterFcmMutation(input: .init(
                    deviceUniqueKey: deviceUniqueKey,
                    clientType: "ios",
                    fcmToken: token
                ))
                return self.provider.networkManager.perform(mutation)
                    .flatMapLatest { payload -> Observable<Mutation> in
                        if payload.unregisterFcm == true {
                            let request: RestAPIType<LogoutResponseModel> = .logout(input: .init(
                                token: accessToken
                            ))
                            return self.provider.networkManager.postByRest(request)
                                .flatMap {_ in goSignIn() }
                                .catch { error -> Observable<Mutation> in
                                    return goSignIn()
                                }
                        } else {
                            return goSignIn()
                        }
                    }
            }.catch { _ in
                return goSignIn()
            }
    }
    
    private func resign() -> Observable<Mutation> {
        guard let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString else {
            return .empty()
        }
        return .concat([
            .just(.updateError(nil)),
            .just(.updateIsResign(nil)),
            .just(.updateIsProcessing(true)),
            
            self.getFCMToken().filterNil()
                .flatMapLatest { token -> Observable<Mutation> in
                    let mutation = UnregisterFcmMutation(input: .init(
                        deviceUniqueKey: deviceUniqueKey,
                        clientType: "ios",
                        fcmToken: token
                    ))
                    return self.provider.networkManager.perform(mutation)
                        .flatMapLatest { payload -> Observable<Mutation> in
                            return self.provider.networkManager.perform(WithdrawMutation())
                                .map { $0.withdrawUser ?? false }
                                .do(onNext: { [weak self] _ in self?.provider.userManager.initializeUserTB() })
                                .map { .updateIsResign($0) }
                        }
                }.catchAndReturn(.updateError(.common(.networkNotConnect))),

            .just(.updateIsProcessing(false))
        ])
    }
    
    func getFCMToken() -> Observable<String?> {
        return .create { observer -> Disposable in
            
            Messaging.messaging().token { token, error in
                if let error = error {
                    observer.onError(error)
                }
                
                if let token = token {
                    observer.onNext(token)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

extension DefaultMyInfoViewReactor {
    
    func reactorForResetPassword() -> ResetPasswordViewReactor {
        return ResetPasswordViewReactor(provider: self.provider)
    }
    
    func reactorForUpdateUserInfo(_ inputType: AccountInputType) -> UpdateUserInfoViewReactor? {
        guard let account = self.currentState.account else { return nil }
        let prevValue: String? = {
            switch inputType {
            case .id: return account.id
            case .password: return account.password
            case .name: return account.name
            case .email: return account.email
            case .phoneNumber: return account.phoneNumber
            }
        }()
        return UpdateUserInfoViewReactor(
            provider: self.provider,
            userID: account.id,
            inputType: inputType,
            prevValue: prevValue
        )
    }
}
