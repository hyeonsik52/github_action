//
//  DefaultMyInfoViewReactor.swift
//
//  Created by Suzy Park on 2020/07/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

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
                        return .just(.updateError(.etc("존재하지 않는 유저입니다.")))
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
//        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return .empty() }
//        let input = DeleteFcmRegistrationIdInput(clientType: "ios", deviceUniqueKey: uuid)
        guard let token = self.provider.userManager.userTB.accessToken else { return .empty() }
        
        let request: RestAPIType<LogoutResponseModel> = .logout(input: .init(
            token: token
        ))
        
        func goSignIn() -> Observable<Mutation> {
            self.provider.userManager.initializeUserTB()
            return .just(.updateIsLogout(true))
        }
//        return self.provider.networkManager.perform(DeleteFcmTokenMutation(input: input))
//            .map { $0.deleteFcmRegistrationIdMutation }
//            .flatMap { [weak self] _ -> Observable<Mutation> in
//                guard let self = self else { return .empty() }
//                return self.provider.networkManager.perform(LogoutMutation())
//                    .map { $0.logoutMutation }
//                    .flatMap { _ in goSignIn() }
//                    .catchError { error -> Observable<Mutation> in
//                        return goSignIn()
//                    }
//            }.catchError({ error -> Observable<Mutation> in
//                return goSignIn()
//            })
        
        return self.provider.networkManager.postByRest(request)
            .flatMap {_ in goSignIn() }
            .catch { error -> Observable<Mutation> in
                return goSignIn()
            }
    }
    
    private func resign() -> Observable<Mutation> {
        return .concat([
            .just(.updateError(nil)),
            .just(.updateIsResign(nil)),
            .just(.updateIsProcessing(true)),

            self.provider.networkManager.perform(WithdrawMutation())
                .map(\.withdrawUser)
                .flatMapLatest { result -> Observable<Mutation> in
                    if result == true {
                        self.provider.userManager.initializeUserTB()
                        return .just(.updateIsResign(true))
                    } else {
                        return .just(.updateError(.etc("존재하지 않는 유저입니다.")))
                    }
                }.catchAndReturn(.updateError(.common(.networkNotConnect))),

            .just(.updateIsProcessing(false))
        ])
    }
    
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


//import Foundation
//import ReactorKit
//import RxSwift
//import FirebaseMessaging
//
//class DefaultMyInfoViewReactor: Reactor {
//
//    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
//
//    enum Action {
//        case refresh
//        case signOut
//        case escapeSockse
//    }
//
//    enum Mutation {
//        case loadedUserInfo(DefaultUserInfoQuery.Data.MyUserInfo.AsUser?)
//        case moveToSignIn(Bool)
//        case updateErrorMessage(String?)
//    }
//
//    struct State {
//        var userInfo: DefaultUserInfoQuery.Data.MyUserInfo.AsUser?
//        var willMoveToSignIn: Bool
//        var errorMessage: String?
//    }
//
//    var initialState: State {
//        return .init(userInfo: nil, willMoveToSignIn: false, errorMessage: nil)
//    }
//
//    let provider: ManagerProviderType
//
//    init(provider: ManagerProviderType) {
//        self.provider = provider
//    }
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .refresh:
//
//            return self.provider.networkManager
//                .fetch(DefaultUserInfoQuery())
//                .map { $0.myUserInfo.asUser }
//                .map { Mutation.loadedUserInfo($0) }
//
//        // 로그아웃 과정
//        // 1. DeleteFcmTokenMutation (토큰 삭제 통신)
//        // 2. SignOutMutation (로그아웃 통신)
//        // 3. reactor `willMoveToSignIn` state 변경
//        case .signOut:
//
//            // 0️⃣ 토큰 업데이트 통신
//            // 0-1. Firebase token 가져오기
//            return self.getFCMToken()
//                .filterNil()
//                .flatMap { token -> Observable<Mutation> in
//
//                    // 0-2. 토큰 업데이트 input
//                    if let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString
//                    {
//                        let updateFCMInput = UpdateFcmRegistrationIdInput(
//                            clientType: "ios",
//                            deviceUniqueKey: deviceUniqueKey,
//                            registrationId: token
//                        )
//
//                        // 0-3. 토큰 업데이트
//                        return self.provider.networkManager
//                            .perform(UpdateFcmTokenMutation(input: updateFCMInput))
//                            .map { $0.updateFcmRegistrationIdMutation }
//                            .flatMap { result -> Observable<Mutation> in
//
//                                // 토큰 업데이트 실패
//                                if let errorCode = result.asUpdateFcmRegistrationIdError?.errorCode {
//                                    var errorMessage: String {
//                                        switch errorCode {
//                                        case .forbidden: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #1)"
//                                        default: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #2)"
//                                        }
//                                    }
//                                    return .just(.updateErrorMessage(errorMessage))
//                                }
//
//                                // 토큰 업데이트 성공
//                                if let payload = result.asUpdateFcmRegistrationIdPayload {
//                                    if payload.result.isTrue {
//
//                                        // 1️⃣ 토큰 삭제 통신
//                                        // 1-1. 토큰 삭제 input
//                                        let deleteFCMInput = DeleteFcmRegistrationIdInput(
//                                            clientType: "ios",
//                                            deviceUniqueKey: deviceUniqueKey
//                                        )
//
//                                        // 1-2. 토큰 삭제
//                                        return self.provider.networkManager
//                                            .perform(DeleteFcmTokenMutation(input: deleteFCMInput))
//                                            .map { $0.deleteFcmRegistrationIdMutation }
//                                            .flatMap { result -> Observable<Mutation> in
//
//                                                // 토큰 삭제 실패
//                                                if let errorCode = result.asDeleteFcmRegistrationIdError?.errorCode {
//                                                    var errorMessage: String {
//                                                        switch errorCode {
//                                                        case .forbidden: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #3)"
//                                                        case .fcmRegistrationIdNotExist: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #4)"
//                                                        default: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #5)"
//                                                        }
//                                                    }
//                                                }
//
//                                                // 토큰 삭제 성공
//                                                if let payload = result.asDeleteFcmRegistrationIdPayload {
//                                                    if payload.result.isTrue {
//
//                                                        // 2️⃣ 로그아웃 통신
//                                                        return self.provider.networkManager.perform(SignOutMutation())
//                                                            .map { $0.logoutMutation.result.isTrue }
//                                                            .flatMap { isSucess -> Observable<Mutation> in
//
//                                                                // 로그아웃 성공
//                                                                if isSucess {
//                                                                    self.provider.userManager.initializeUserTB()
//                                                                    return .just(.moveToSignIn(isSucess))
//                                                                }
//
//                                                                // 로그아웃 실패
//                                                                // 서버 측 케이스 처리 따로 안되어있음
//                                                                return .just(.updateErrorMessage("로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #6)"))
//                                                            }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #7)"))
//                                                    }
//                                                }
//                                                return .empty()
//                                            }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #8)"))
//                                    }
//                                }
//                                return .empty()
//                            }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #9)"))
//                    }
//                    return .empty()
//                }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #10)"))
//
//        case .escapeSockse:
//            return self.provider.networkManager
//                .perform(EscapeSockseMutation())
//                .map { $0.resignMutation.asResignPayload?.result.isTrue ?? false }
//                .do(onNext: { [weak self] _ in self?.provider.userManager.initializeUserTB() })
//                .map { Mutation.moveToSignIn($0) }
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var state = state
//        switch mutation {
//        case let .loadedUserInfo(info):
//            state.errorMessage = nil
//            state.userInfo = info
//
//        case let .moveToSignIn(willMoveToSignIn):
//            state.errorMessage = nil
//            state.willMoveToSignIn = willMoveToSignIn
//
//        case let .updateErrorMessage(message):
//            state.errorMessage = message
//        }
//        return state
//    }
//
//    func getFCMToken() -> Observable<String?> {
//        return .create { observer -> Disposable in
//
//            Messaging.messaging().token { token, error in
//                if let error = error {
//                    observer.onError(error)
//                }
//
//                if let token = token {
//                    observer.onNext(token)
//                    observer.onCompleted()
//                }
//            }
//            return Disposables.create()
//        }
//    }
//
//    // 이름 변경
//    func reactorForNameUpdate() -> Default_Name_ViewReactor {
//        let placeholder = self.currentState.userInfo?.name ?? ""
//        return Default_Name_ViewReactor(provider: self.provider, placeholder: placeholder)
//    }
//
//    // 이메일 변경
//    func reactorForEmailUpdate() -> Default_Email_ViewReactor {
//        let placeholder = self.currentState.userInfo?.email ?? ""
//        return Default_Email_ViewReactor(provider: self.provider, placeholder: placeholder)
//    }
//
//    // 전화번호 변경
//    func reactorForPhoneNumberUpdate() -> Default_PhoneNumber_ViewReactor {
//        let phoneNumber = self.currentState.userInfo?.phoneNumber ?? ""
//        return Default_PhoneNumber_ViewReactor(provider: self.provider, placeholder: phoneNumber)
//    }
//
//    // 로그아웃, SRP 탈퇴: Sock-se(속세)를 떠납니다.
//    func reactorForSignIn() -> SignInViewReactor {
//        return SignInViewReactor(provider: self.provider)
//    }
//
//    // 계정 비밀번호 변경
//    func reactorForChangePassword() -> Default_PW_ViewReactor {
//        return Default_PW_ViewReactor(provider: self.provider)
//    }
//}
