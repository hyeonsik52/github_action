//
//  GroupModelSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxDataSources

struct GroupModelSection {
    var header: String
    var items: [Item]
}

extension GroupModelSection: SectionModelType {
    typealias Item = ServiceUserGroup
    
    init(original: GroupModelSection, items: [ServiceUserGroup]) {
        self = original
        self.items = items
    }
}
