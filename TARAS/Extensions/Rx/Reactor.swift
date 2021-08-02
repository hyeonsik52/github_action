//
//  Reactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

extension Reactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return mutation.observeOn(MainScheduler.instance)
    }
}

