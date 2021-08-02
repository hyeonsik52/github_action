//
//  Optional.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

infix operator ??= : AssignmentPrecedence

extension Optional {
    
    /// 우항이 nil이 아닐때 좌항에 대입
    static func ??= (lhs: inout Wrapped, rhs: Optional) {
        guard let rhs = rhs else { return }
        lhs = rhs
    }
}
