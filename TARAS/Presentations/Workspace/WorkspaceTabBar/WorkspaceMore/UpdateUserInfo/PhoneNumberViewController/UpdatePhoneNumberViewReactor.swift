//
//  UpdatePhoneNumberViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/24.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class UpdatePhoneNumberViewReactor: Reactor {
    
    enum Text {
        static let UPNVR_1 = "(21자 이하의) 숫자만 입력할 수 있습니다."
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    typealias Info = Result<String,NetworkError>
    
    enum Action {
        case update(phoneNumber: String)
    }
    
    enum Mutation {
        case updated(Info?)
        case setProcessing(Bool)
    }
    
    struct State {
        var result: Info?
        var isProcessing: Bool
    }
    
    let initialState: State
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int, placeholder: String) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.initialState = State(result: .success(placeholder), isProcessing: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .update(let phoneNumber):
            guard phoneNumber.matches(Regex.phoneNumber) else { return .just(.updated(.failure(.etc(Text.UPNVR_1))))}
            
            let transformedPhoneNumber = self.provider.userManager.nationalizePhoneNumber(phoneNumber)
            
            guard let myUserIdx = self.provider.userManager.userTB.userIdx.value else { return .empty() }
            
            let input = UpdateUserSWSInfoInput(phoneNumber: transformedPhoneNumber, swsIdx: self.swsIdx, userIdx: myUserIdx)
            return .concat([
                .just(.setProcessing(true)),
                self.provider.networkManager
                    .perform(UpdateUserSwsInfoMutationMutation(input: input))
                    .map { $0.updateUserSwsInfoMutation }
                    .map { data -> Info? in
                        if let updatedEmail = data.asUserSwsInfo?.email {
                            return .success(updatedEmail)
                        } else if let error = data.asUpdateUserSwsInfoError {
                            return .failure(.etc(error.errorCode.rawValue))
                        }
                        return nil
                }
                .map { Mutation.updated($0) },
                .just(.setProcessing(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updated(let result):
            state.result = result
        case let .setProcessing(isProcessing):
            state.isProcessing = isProcessing
        }
        return state
    }
}
