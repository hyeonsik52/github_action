//
//  Default_Name_ViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/31.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class Default_Name_ViewReactor: Reactor {
    
    enum Text {
        static let UNVR_1 = "1~20자로 입력해주세요."
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case setName(String)
    }
    
    enum Mutation {
        case updateName(String)
        case updateErrorMessage(String?)
    }
    
    struct State {
        var updatedName: String
        var errorMessage: String?
    }
    
    let initialState: State
    
    let provider: ManagerProviderType
    
    let placeholder: String
    
    init(provider: ManagerProviderType, placeholder: String) {
        self.provider = provider
        self.placeholder = placeholder
        
        self.initialState = .init(updatedName: "", errorMessage: nil)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setName(name):
            
            //temp
            return .empty()
//            let input = UpdateUserInfoInput(name: name)
//
//            return self.provider.networkManager.perform(UpdateUserInfoMutation(input: input))
//                .map { $0.updateUserInfoMutation }
//                .flatMap { data -> Observable<Mutation> in
//                    if let name = data.asUser?.name {
//                        return .just(.updateName(name))
//                    }
//                    return .just(.updateErrorMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)"))
//            }.catchErrorJustReturn(.updateErrorMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)"))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateName(name):
            state.updatedName = name
            
        case let .updateErrorMessage(message):
            state.errorMessage = message
        }
        return state
    }
}
