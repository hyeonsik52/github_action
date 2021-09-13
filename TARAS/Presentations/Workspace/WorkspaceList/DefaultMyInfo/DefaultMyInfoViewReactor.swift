//
//  DefaultMyInfoViewReactor.swift
//
//  Created by Suzy Park on 2020/07/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import FirebaseMessaging

class DefaultMyInfoViewReactor: Reactor {

    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)

    enum Action {
        case refresh
        case signOut
        case escapeSockse
    }

    enum Mutation {
        case loadedUserInfo(DefaultUserInfoQuery.Data.MyUserInfo.AsUser?)
        case moveToSignIn(Bool)
        case updateErrorMessage(String?)
    }

    struct State {
        var userInfo: DefaultUserInfoQuery.Data.MyUserInfo.AsUser?
        var willMoveToSignIn: Bool
        var errorMessage: String?
    }

    var initialState: State {
        return .init(userInfo: nil, willMoveToSignIn: false, errorMessage: nil)
    }

    let provider: ManagerProviderType

    init(provider: ManagerProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            
            return self.provider.networkManager
                .fetch(DefaultUserInfoQuery())
                .map { $0.myUserInfo.asUser }
                .map { Mutation.loadedUserInfo($0) }
            
        // 로그아웃 과정
        // 1. DeleteFcmTokenMutation (토큰 삭제 통신)
        // 2. SignOutMutation (로그아웃 통신)
        // 3. reactor `willMoveToSignIn` state 변경
        case .signOut:
            
            // 0️⃣ 토큰 업데이트 통신
            // 0-1. Firebase token 가져오기
            return self.getFCMToken()
                .filterNil()
                .flatMap { token -> Observable<Mutation> in
                    
                    // 0-2. 토큰 업데이트 input
                    if let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString
                    {
                        let updateFCMInput = UpdateFcmRegistrationIdInput(
                            clientType: "ios",
                            deviceUniqueKey: deviceUniqueKey,
                            registrationId: token
                        )
                        
                        // 0-3. 토큰 업데이트
                        return self.provider.networkManager
                            .perform(UpdateFcmTokenMutation(input: updateFCMInput))
                            .map { $0.updateFcmRegistrationIdMutation }
                            .flatMap { result -> Observable<Mutation> in
                                
                                // 토큰 업데이트 실패
                                if let errorCode = result.asUpdateFcmRegistrationIdError?.errorCode {
                                    var errorMessage: String {
                                        switch errorCode {
                                        case .forbidden: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #1)"
                                        default: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #2)"
                                        }
                                    }
                                    return .just(.updateErrorMessage(errorMessage))
                                }
                                
                                // 토큰 업데이트 성공
                                if let payload = result.asUpdateFcmRegistrationIdPayload {
                                    if payload.result.isTrue {
                                        
                                        // 1️⃣ 토큰 삭제 통신
                                        // 1-1. 토큰 삭제 input
                                        let deleteFCMInput = DeleteFcmRegistrationIdInput(
                                            clientType: "ios",
                                            deviceUniqueKey: deviceUniqueKey
                                        )
                                        
                                        // 1-2. 토큰 삭제
                                        return self.provider.networkManager
                                            .perform(DeleteFcmTokenMutation(input: deleteFCMInput))
                                            .map { $0.deleteFcmRegistrationIdMutation }
                                            .flatMap { result -> Observable<Mutation> in
                                                
                                                // 토큰 삭제 실패
                                                if let errorCode = result.asDeleteFcmRegistrationIdError?.errorCode {
                                                    var errorMessage: String {
                                                        switch errorCode {
                                                        case .forbidden: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #3)"
                                                        case .fcmRegistrationIdNotExist: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #4)"
                                                        default: return "로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #5)"
                                                        }
                                                    }
                                                }
                                                
                                                // 토큰 삭제 성공
                                                if let payload = result.asDeleteFcmRegistrationIdPayload {
                                                    if payload.result.isTrue {
                                                        
                                                        // 2️⃣ 로그아웃 통신
                                                        return self.provider.networkManager.perform(SignOutMutation())
                                                            .map { $0.logoutMutation.result.isTrue }
                                                            .flatMap { isSucess -> Observable<Mutation> in
                                                                
                                                                // 로그아웃 성공
                                                                if isSucess {
                                                                    self.provider.userManager.initializeUserTB()
                                                                    return .just(.moveToSignIn(isSucess))
                                                                }
                                                                
                                                                // 로그아웃 실패
                                                                // 서버 측 케이스 처리 따로 안되어있음
                                                                return .just(.updateErrorMessage("로그아웃을 할 수 없습니다. 잠시 후에 다시 시도해 주세요. (error #6)"))
                                                            }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #7)"))
                                                    }
                                                }
                                                return .empty()
                                            }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #8)"))
                                    }
                                }
                                return .empty()
                            }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #9)"))
                    }
                    return .empty()
                }.catchAndReturn(.updateErrorMessage("네트워크/서버 상태가 원활하지 않습니다. 잠시 후에 다시 시도해 주세요. (error #10)"))

        case .escapeSockse:
            return self.provider.networkManager
                .perform(EscapeSockseMutation())
                .map { $0.resignMutation.asResignPayload?.result.isTrue ?? false }
                .do(onNext: { [weak self] _ in self?.provider.userManager.initializeUserTB() })
                .map { Mutation.moveToSignIn($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedUserInfo(info):
            state.errorMessage = nil
            state.userInfo = info

        case let .moveToSignIn(willMoveToSignIn):
            state.errorMessage = nil
            state.willMoveToSignIn = willMoveToSignIn
            
        case let .updateErrorMessage(message):
            state.errorMessage = message
        }
        return state
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

    // 프로필 이미지 변경
//    func reactorForProfileImageUpdate() -> WorkspaceMoreViewReactor {
//        return WorkspaceMoreViewReactor(provider: self.provider, swsIdx: self.swsIdx)
//    }

    // 이름 변경
    func reactorForNameUpdate() -> Default_Name_ViewReactor {
        let placeholder = self.currentState.userInfo?.name ?? ""
        return Default_Name_ViewReactor(provider: self.provider, placeholder: placeholder)
    }

    // 이메일 변경
    func reactorForEmailUpdate() -> Default_Email_ViewReactor {
        let placeholder = self.currentState.userInfo?.email ?? ""
        return Default_Email_ViewReactor(provider: self.provider, placeholder: placeholder)
    }

    // 전화번호 변경
    func reactorForPhoneNumberUpdate() -> Default_PhoneNumber_ViewReactor {
        let phoneNumber = self.currentState.userInfo?.phoneNumber ?? ""
        let placeholder = self.provider.userManager.denationalizePhoneNumber(phoneNumber)
        return Default_PhoneNumber_ViewReactor(provider: self.provider, placeholder: placeholder)
    }

    // 로그아웃, SRP 탈퇴: Sock-se(속세)를 떠납니다.
    func reactorForSignIn() -> SignInViewReactor {
        return SignInViewReactor(provider: self.provider)
    }

    // 계정 비밀번호 변경
    func reactorForChangePassword() -> Default_PW_ViewReactor {
        return Default_PW_ViewReactor(provider: self.provider)
    }
}
