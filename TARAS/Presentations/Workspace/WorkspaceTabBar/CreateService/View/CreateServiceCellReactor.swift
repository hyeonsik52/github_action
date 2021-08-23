//
//  CreateServiceCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

struct CreateServiceTargetInfoModel {

    enum CreateServiceTargetType {
        case none
        case user
        case group
        case stop
    }

    var idx: Int
    var name: String?
    var groupName: String?
    var targetType: CreateServiceTargetType
}

class CreateServiceCellReactor: Reactor {

    typealias Action = NoAction
    
    typealias Mutation = NoMutation
    
    struct State { }
    
    let provider: ManagerProviderType
    
    let swsIdx: Int
    
    var serviceUnitModel: CreateServiceUnitModel
    
    var initialState: State = .init()

    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceUnitModel: CreateServiceUnitModel
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceUnitModel = serviceUnitModel
    }
}

extension CreateServiceCellReactor {

    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
}
