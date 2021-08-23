//
//  UpdateNameViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/24.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class UpdateNameViewReactor: Reactor {
    
    enum Text {
        static let UNVR_1 = "1~20자로 입력해주세요."
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    typealias Info = Result<String,NetworkError>
    
    enum Action {
        case update(name: String)
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
        case .update(let name):
            guard 1...20 ~= name.count else { return .just(.updated(.failure(.etc(Text.UNVR_1))))}
            let myUserIdx = self.provider.userManager.userTB.userIdx
            let input = UpdateUserSWSInfoInput(name: name, swsIdx: self.swsIdx, userIdx: myUserIdx.value)
            return .concat([
                .just(.setProcessing(true)),
                self.provider.networkManager
                    .perform(UpdateUserSwsInfoMutationMutation(input: input))
                    .map { $0.updateUserSwsInfoMutation }
                    .map { data -> Info? in
                        if let updatedName = data.asUserSwsInfo?.name {
                            return .success(updatedName)
                        }else if let error = data.asUpdateUserSwsInfoError {
                            return .failure(.etc(error.errorCode.rawValue))
                        }
                        return nil
                }.map { Mutation.updated($0) },
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
