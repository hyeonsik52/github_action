//
//  Default_PhoneNumber_ViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class Default_PhoneNumber_ViewReactor: Reactor {

    enum Action {
        case setPhoneNumber(String)
        case confirmPhoneNumber
    }

    enum Mutation {
        case updateIsPhoneNumberConfirmed(Bool)
        case updateErrorMessage(String?)
        case updateIsLoading(Bool)
    }

    struct State {
        var errorMessage: String?
        var isPhoneNumberConfirmed: Bool
        var isLoading: Bool
    }

    let provider: ManagerProviderType
    
    let placeholder: String

    var phoneNumber: String = ""

    let initialState: State

    init(provider: ManagerProviderType, placeholder: String) {
        self.provider = provider
        self.placeholder = placeholder

        self.initialState = .init(errorMessage: nil, isPhoneNumberConfirmed: false, isLoading: false)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPhoneNumber(phoneNumber):
            self.phoneNumber = phoneNumber
            return .just(.updateErrorMessage(nil))

        case .confirmPhoneNumber:
            guard self.phoneNumber.count > 0 && self.phoneNumber.count < 22 else {
                return .just(.updateErrorMessage("21자 이하의 숫자만 입력할 수 있습니다."))
            }

            let phoneNumber = self.provider.userManager.nationalizePhoneNumber(self.phoneNumber)
            let input = UpdateUserInfoInput(phoneNumber: phoneNumber)

            return .concat([
                    .just(.updateIsLoading(true)),
                    
                self.provider.networkManager.perform(UpdateUserInfoMutation(input: input))
                    .map { $0.updateUserInfoMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let _ = data.asUser {
                            return .just(.updateIsPhoneNumberConfirmed(true))
                        }
                        if let errorCode = data.asUpdateUserInfoError?.errorCode {
                            var message: String {
                                switch errorCode {
                                case .duplicatedPhoneNumber:
                                    return "이미 사용 중인 전화번호입니다."
                                    
                                default:
                                    return "잘못된 접근입니다. 잠시 후 다시 시도해주세요."
                                }
                            }
                            return .just(.updateErrorMessage(message))
                        }
                        return .empty()
                    }.catchErrorJustReturn(
                        .updateErrorMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)")
                ),
                
                    .just(.updateIsLoading(false))
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateErrorMessage(message):
            state.isPhoneNumberConfirmed = false
            state.errorMessage = message

        case let .updateIsPhoneNumberConfirmed(isPhoneNumberConfirmed):
            state.isPhoneNumberConfirmed = isPhoneNumberConfirmed

        case let .updateIsLoading(isLoading):
            state.isPhoneNumberConfirmed = false
            state.isLoading = isLoading
        }
        return state
    }
}
