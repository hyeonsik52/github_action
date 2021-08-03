//
//  ThreadSafeReference_BaseObject.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/04/27.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import RealmSwift

extension ThreadSafeReference where Confined: BaseObject {

    // 스레드 간 이동시 레펴런스 언래핑
    // [주의] 트랜잭션 사이에서 사용하면 안됨
    var resolved: Confined? {
        return RealmManager.shared.realm?.resolve(self)
    }
}
