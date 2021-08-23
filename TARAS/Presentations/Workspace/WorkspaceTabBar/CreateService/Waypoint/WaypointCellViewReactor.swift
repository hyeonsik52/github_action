//
//  WaypointCellViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Twinny on 2020/07/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class WaypointCellViewReactor: Reactor {
    
    enum Action {
        case updateStopInfo
    }
    
    enum Mutation {
        case setStopInfo
    }
    
    struct State {
        var name: String
    }
    
    let provider: ManagerProviderType
    
    let swsIdx: Int
    
    var cellModel: TargetStopCellModel
    
    var initialState: State = .init(name: "")

    init(provider: ManagerProviderType, swsIdx: Int, cellModel: TargetStopCellModel) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.cellModel = cellModel
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateStopInfo:
            return .just(.setStopInfo)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setStopInfo:
            state.name = "reduce"
        }
        return state
    }
}
