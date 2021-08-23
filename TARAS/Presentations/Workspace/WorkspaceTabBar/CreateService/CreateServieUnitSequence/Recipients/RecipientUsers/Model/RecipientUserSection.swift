//
//  RecipientUserSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import RxDataSources

struct RecipientUserSection {
    var items: [Item]
}

extension RecipientUserSection: SectionModelType {
    
    typealias Item = RecipientUserCellReactor

    init(original: RecipientUserSection, items: [Item]) {
        self = original
        self.items = items
    }
}
