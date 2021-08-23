//
//  UpdateEmailViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/24.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class UpdateEmailViewReactor: Reactor {
    
    enum Text {
        static let SUEVR_1 = "형식에 맞지 않는 이메일입니다."
        static let SUEVR_2 = "존재하지 않는 이메일입니다."
    }

    enum Action {
        case setEmail(String)
        case confirmEmail
    }
    
    enum Mutation {
        case updateErrorMessage(String?)
        case updateIsEmailConfirmed(Bool)
        case updateLoading(Bool)
    }
    
    struct State {
        var errorMessage: String?
        var isEmailConfirmed: Bool
        var isLoading: Bool
    }
    
    let provider: ManagerProviderType
    let swsIdx: Int
    let placeholder: String
    var email: String = ""
    var expireDate: Date?
    
    let initialState: State
    
    init(provider: ManagerProviderType, swsIdx: Int, placeholder: String) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.placeholder = placeholder
        
        self.initialState = State(
            errorMessage: nil,
            isEmailConfirmed: false,
            isLoading: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setEmail(email):
            self.email = email
            return .just(.updateErrorMessage(nil))
            
            
        case .confirmEmail:
            guard self.email.matches(Regex.email) else {
                return .just(.updateErrorMessage(Text.SUEVR_1))
            }
            
            let emailAuthInput = CreateEmailAuthCodeInput(checkExist: "false", email: self.email)
            
            return .concat([
                .just(.updateLoading(true)),

                self.provider.networkManager
                    .perform(CreateEmailAuthCodeMutation(input: emailAuthInput))
                    .map { $0.createEmailAuthCodeMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let payload = data.asCreateEmailAuthCodePayload,
                            payload.email == self.email
                        {
                            let calendar = Calendar.current
                            let expireDate = calendar.date(
                                byAdding: .second,
                                value: payload.expiresIn,
                                to: Date()
                            )
                            self.expireDate = expireDate ?? Date()
                            
                            return .just(.updateIsEmailConfirmed(true))
                        }
                        // 현재 asCreateEmailAuthCodeError 에 정의된 errorCode 중 해당 사항 없음
                        return .just(.updateErrorMessage("고객센터로 문의해주세요."))
                    }.catchErrorJustReturn(
                            .updateErrorMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)")
                    ),

                .just(.updateLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateErrorMessage(message):
            state.isEmailConfirmed = false
            state.errorMessage = message
            
        case let .updateLoading(isLoading):
            state.isEmailConfirmed = false
            state.isLoading = isLoading
            
        case let .updateIsEmailConfirmed(isEmailConfirmed):
            state.isEmailConfirmed = isEmailConfirmed
        }
        return state
    }
    
    func reactorForEmailAuth() -> UpdateEmailAuthViewReactor {
        let myUserIdx = self.provider.userManager.userTB.userIdx.value ?? 0
        return UpdateEmailAuthViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            userIdx: myUserIdx,
            expireDate: self.expireDate ?? Date(),
            email: self.email
        )
    }
}
