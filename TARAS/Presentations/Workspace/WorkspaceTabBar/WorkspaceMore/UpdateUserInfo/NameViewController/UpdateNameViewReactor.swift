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
    let workspaceId: String
    
    init(provider: ManagerProviderType, workspaceId: String, placeholder: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.initialState = State(result: .success(placeholder), isProcessing: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .update(let name):
            guard 1...20 ~= name.count else { return .just(.updated(.failure(.etc(Text.UNVR_1))))}
            guard let myUserId = self.provider.userManager.userTB.ID else { return .just(.updated(.failure(.etc("사용자 정보가 없습니다.")))) }
            let input = UpdateUserMutationInput(username: myUserId, displayName: name)
            return .concat([
                .just(.setProcessing(true)),
                self.provider.networkManager
                    .perform(UpdateUserInfoMutation(input: input))
                    .map { $0.updateUser?.fragments.userFragment }
                    .map { data -> Info? in
                        guard let user = data else { return .failure(.etc("이름을 변경하지 못했습니다.")) }
                        return .success(user.displayName)
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
