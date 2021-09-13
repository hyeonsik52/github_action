//
//  Default_EmailAuth_ViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/08/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class Default_EmailAuth_ViewReactor: Reactor {

    enum Text {
        static let SUACVR_1 = "잘못된 인증번호입니다."
    }

    enum Action {
        case setAuthCode(String)
        case setRemainTime
        case confirmAuthCode
        case resendAuthCode
    }

    enum Mutation {
        case updateRemainTime(String)
        case updateTimeOver(Bool)
        case updateErrorMessage(String?)
        case updateIsCodeConfirmed(Bool)
        case updateIsLoading(Bool)
    }

    let provider: ManagerProviderType
    var userIdx: Int
    var expireDate: Date
    var authCode: String?
    var email: String

    struct State {
        var errorMessage: String?
        var remainTimeString: String
        var isTimeOver: Bool
        var isCodeConfirmed: Bool
        var isLoading: Bool
    }

    let initialState: State

    init(
        provider: ManagerProviderType,
        userIdx: Int,
        expireDate: Date?,
        email: String
    ) {
        self.provider = provider
        self.userIdx = userIdx
        self.expireDate = expireDate ?? Date()
        self.email = email

        self.initialState = State(
            errorMessage: nil,
            remainTimeString: "",
            isTimeOver: false,
            isCodeConfirmed: false,
            isLoading: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setAuthCode(code):
            self.authCode = code
            return .just(.updateErrorMessage(nil))

        case .setRemainTime:
            let interval = self.expireDate.timeIntervalSince(Date())
            if interval.isLess(than: 0) {
                return .concat([
                        .just(.updateRemainTime("00:00")),
                        .just(.updateTimeOver(true))
                    ])
            }
            return .just(.updateRemainTime(interval.toTimeString))

        case .confirmAuthCode:
            guard let authCode = self.authCode else {
                return .concat([
                        .just(.updateErrorMessage(Text.SUACVR_1))
                    ])
            }

//            let codeInput = CheckEmailAuthCodeInput(
//                authCode: authCode,
//                email: self.email
//            )
//
//            return .concat([
//                    .just(.updateIsLoading(true)),
//
//                self.provider.networkManager
//                    .perform(CheckEmailAuthCodeMutation(input: codeInput))
//                    .map { $0.checkEmailAuthCodeMutation }
//                    .flatMap { data -> Observable<Mutation> in
//                        if let payload = data.asCheckEmailAuthCodePayload {
//                            if payload.email == self.email
//                            {
//                                let input = UpdateUserInfoInput(
//                                    email: self.email,
//                                    emailToken: payload.emailToken,
//                                    userIdx: self.userIdx
//                                )
//
//                                return self.provider.networkManager
//                                    .perform(UpdateUserInfoMutation(input: input))
//                                    .map { $0.updateUserInfoMutation }
//                                    .flatMap { data -> Observable<Mutation> in
//                                        if let _ = data.asUser?.email {
                                            return .concat([
                                                    .just(.updateIsCodeConfirmed(true)),
                                                    .just(.updateTimeOver(true))
                                                ])
//                                        }
//                                        if let errorCode = data.asUpdateUserInfoError?.errorCode {
//                                            var message: String {
//                                                switch errorCode {
//                                                case .invalidAuthCode:
//                                                    return Text.SUACVR_1
//
//                                                case .invalidEmailToken:
//                                                    return "이메일 인증에 실패하였습니다. 다시 시도해 주세요."
//
//                                                case .duplicatedEmail:
//                                                    return "이미 사용 중인 이메일입니다."
//
//                                                default:
//                                                    return "잘못된 접근입니다. 잠시 후 다시 시도해주세요."
//                                                }
//                                            }
//                                            return .just(.updateErrorMessage(message))
//                                        }
//                                        return .empty()
//                                }
//                            }
//                        }
//
//                        if let _ = data.asCheckEmailAuthCodeError?.errorCode {
//                            return .just(.updateErrorMessage(Text.SUACVR_1))
//                        }
//                        return .empty()
//                    }.catchErrorJustReturn(.updateErrorMessage(Text.SUACVR_1)),
//
//                    .just(.updateIsLoading(false))
//                ])

        case .resendAuthCode:
//            let codeInput = CreateEmailAuthCodeInput(
//                checkExist: "false",
//                email: self.email
//            )
//
//            return .concat([
//                    .just(.updateIsLoading(true)),
//
//                self.provider.networkManager
//                    .perform(CreateEmailAuthCodeMutation(input: codeInput))
//                    .map { $0.createEmailAuthCodeMutation }
//                    .flatMap { result -> Observable<Mutation> in
//                        if let payload = result.asCreateEmailAuthCodePayload,
//                            payload.email == self.email
//                        {
//                            let calendar = Calendar.current
//                            let expireDate = calendar.date(
//                                byAdding: .second,
//                                value: payload.expiresIn,
//                                to: Date()
//                            )
//                            self.expireDate = expireDate ?? Date()
                            
                            return .concat([
                                .just(.updateErrorMessage("이메일로 발송된 인증번호를 입력해주세요.")),
                                .just(.updateTimeOver(false))
                            ])
//                        }
//
//                        if let errorCode = result.asCreateEmailAuthCodeError?.errorCode {
//                            if errorCode == .userNotExist {
//                                return .just(.updateErrorMessage("존재하지 않는 이메일입니다."))
//                            }
//                        }
//                        return .empty()
//                    }.catchErrorJustReturn(
//                        .updateErrorMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)")
//                    ),
//
//                    .just(.updateIsLoading(false))
//                ])

        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateErrorMessage(errorMessage):
            state.isCodeConfirmed = false
            state.errorMessage = errorMessage

        case let .updateIsCodeConfirmed(isCodeConfirmed):
            state.isCodeConfirmed = isCodeConfirmed
            if isCodeConfirmed {
                state.isTimeOver = true
            }

        case let .updateRemainTime(remains):
            state.isCodeConfirmed = false
            state.remainTimeString = remains

        case let .updateTimeOver(isTimeOver):
            state.isCodeConfirmed = false
            state.isTimeOver = isTimeOver

        case let .updateIsLoading(isLoading):
            state.isCodeConfirmed = false
            state.isLoading = isLoading
        }
        return state
    }
}
