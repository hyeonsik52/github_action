//
//  ServiceLogSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxDataSources

struct ServiceLogSection {
    var items: [Item]
}
extension ServiceLogSection: SectionModelType {
    typealias Item = ServiceLogCellReactor
    
    init(original: ServiceLogSection, items: [ServiceLogCellReactor]) {
        self = original
        self.items = items
    }
}
