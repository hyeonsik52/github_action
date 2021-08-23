//
//  CreateServiceSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import RxDataSources

struct CreateServiceSection {
    var items: [Item]
}
extension CreateServiceSection: SectionModelType {
    typealias Item = CreateServiceCellReactor

    init(original: CreateServiceSection, items: [Item]) {
        self = original
        self.items = items
    }
}



