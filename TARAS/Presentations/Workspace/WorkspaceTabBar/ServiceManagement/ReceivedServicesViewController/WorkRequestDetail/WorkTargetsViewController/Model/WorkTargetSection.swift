//
//  WorkTargetSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxDataSources

struct WorkTargetSection {
    var header: String
    var items: [Item]
}

extension WorkTargetSection: SectionModelType {
    typealias Item = ServiceTargetCellReactor
    
    init(original: WorkTargetSection, items: [Item]) {
        self = original
        self.items = items
    }
}
