//
//  RecipientGroupSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/11.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import RxDataSources

struct RecipientGroupSection {
    var items: [Item]
}

extension RecipientGroupSection: SectionModelType {
    typealias Item = RecipientGroupCellReactor

    init(original: RecipientGroupSection, items: [Item]) {
        self = original
        self.items = items
    }
}
