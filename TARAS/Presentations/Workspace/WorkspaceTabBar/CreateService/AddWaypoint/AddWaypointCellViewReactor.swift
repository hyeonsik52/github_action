//
//  AddWaypointCellViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class AddWaypointCellViewReactor: Reactor {

    typealias Action = NoAction

    typealias Mutation = NoMutation
    
    struct State { }

    let provider: ManagerProviderType
    
    let swsIdx: Int
    
    var serviceUnitModel: CreateServiceUnitModel
    
    var initialState: State = State()

    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceUnitModel: CreateServiceUnitModel
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceUnitModel = serviceUnitModel
    }
    
    func reactorForWaypoint(willAppendAt: Int) -> WaypointViewReactor {
        return WaypointViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            waypointInput: nil,
            willAppendAt: willAppendAt
        )
    }

    // manager로 옮기기
    func targetInfo(_ unitInput: CreateServiceUnitInput) -> CreateServiceTargetInfoModel {
        let targetType = unitInput.targetType

        if targetType == .recipient
        {
            if let recipient = unitInput.recipients.compactMap({ $0 }).first {
                if recipient.targetType == .user {
                    return .init(idx: recipient.targetIdx, name: nil, groupName: nil, targetType: .user)
                } else {
                    return .init(idx: recipient.targetIdx, name: nil, groupName: nil, targetType: .group)
                }
            }
        }
        
        let stopIdx = unitInput.stopIdx ?? 0
        return .init(idx: stopIdx ?? 0, name: nil, groupName: nil, targetType: .stop)
    }
}
