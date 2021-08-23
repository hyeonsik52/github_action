//
//  DetailHeaderCellViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

struct DetailHeaderCellModel {
    
    var type: ServiceUnitTargetType
    
    /// '수신자 우선 선택'의 경우 수신자 이름. '정차지 우선 선택'의 경우 정차지 이름.
    var name: String
    
    /// '수신자 우선 선택'의 경우 수신자의 그룹 이름. '정차지 우선 선택'의 경우에는 nil.
    var groupName: String?
}

class DetailHeaderCellViewReactor: Reactor {
    typealias Action = NoAction
    typealias Mutation = NoMutation

    let initialState: DetailHeaderCellModel

    init(_ model: DetailHeaderCellModel) {
      self.initialState = model
    }
}
