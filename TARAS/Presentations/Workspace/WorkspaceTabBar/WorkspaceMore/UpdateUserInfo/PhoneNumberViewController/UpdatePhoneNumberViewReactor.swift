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
    let workspaceId: String
    
    init(provider: ManagerProviderType, workspaceId: String, placeholder: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.initialState = State(result: .success(placeholder), isProcessing: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .update(let phoneNumber):
            guard InputPolicy.phoneNumber.match(phoneNumber) else { return .just(.updated(.failure(.etc(Text.UPNVR_1))))}
            guard let myUserId = self.provider.userManager.userTB.id else { return .just(.updated(.failure(.etc("사용자 정보가 없습니다.")))) }
            let input = UpdateUserMutationInput(username: myUserId, phoneNumber: phoneNumber)
            return .concat([
                .just(.setProcessing(true)),
//                self.provider.networkManager
//                    .perform(UpdateUserInfoMutation(input: input))
//                    .map { $0.updateUser?.fragments.userFragment }
//                    .map { data -> Info? in
//                        guard let phonenumber = data?.phoneNumber else { return .failure(.etc("전화번호를 변경하지 못했습니다.")) }
//                        return .success(phonenumber)
//                }.map { Mutation.updated($0) },
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
