//
//  ServiceUnitSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxDataSources

struct ServiceUnitSection {
    var header: Service
    var items: [Item]
}
extension ServiceUnitSection: SectionModelType {
    typealias Item = ServiceUnitCellReactor
    
    init(original: ServiceUnitSection, items: [ServiceUnitCellReactor]) {
        self = original
        self.items = items
    }
}
