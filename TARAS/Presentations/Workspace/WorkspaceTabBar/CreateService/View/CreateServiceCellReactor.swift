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

class CreateServiceCellReactor: Reactor {

    typealias Action = NoAction
    
    typealias Mutation = NoMutation
    
    struct State { }
    
    let provider: ManagerProviderType
    
    let workspaceId: String
    
    var serviceUnitModel: CreateServiceUnitModel
    
    var initialState: State = .init()

    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceUnitModel: CreateServiceUnitModel
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceUnitModel = serviceUnitModel
    }
}

extension CreateServiceCellReactor {

    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
}
