//
//  GraphQLOperation.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/21.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Apollo

extension GraphQLOperation {
    
    var key: String {
        let variableString = self.variables?
            .sorted(by: {$0.key < $1.key})
            .map { "\($0.key):\($0.value ?? "nil")" }
            .joined(separator: "-") ?? "none"
        return "\(self.operationName)-\(variableString)"
    }
}
