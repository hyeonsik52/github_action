//
//  ServiceModelSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxDataSources

struct ServiceModelSection {
    var header: String
    var items: [Item]
}
extension ServiceModelSection: SectionModelType {
    typealias Item = ServiceCellReactor
    
    init(original: ServiceModelSection, items: [ServiceCellReactor]) {
        self = original
        self.items = items
    }
}
