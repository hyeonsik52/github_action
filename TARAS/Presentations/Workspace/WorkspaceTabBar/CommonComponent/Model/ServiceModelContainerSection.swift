//
//  ServiceModelContainerSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxDataSources

struct ServiceModelContainerSection {
    var header: String
    var items: [Item]
}

extension ServiceModelContainerSection: SectionModelType {
    typealias Item = ServiceContainerCellReactor
    
    init(original: ServiceModelContainerSection, items: [ServiceContainerCellReactor]) {
        self = original
        self.items = items
    }
}
