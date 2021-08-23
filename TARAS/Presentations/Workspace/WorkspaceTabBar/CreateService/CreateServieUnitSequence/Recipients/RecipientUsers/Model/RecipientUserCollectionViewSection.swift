//
//  RecipientUserCollectionViewSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/14.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import RxDataSources

struct RecipientUserCollectionViewSection {
    var items: [Item]
}

extension RecipientUserCollectionViewSection: SectionModelType {
    
    typealias Item = RecipientUserCollectionViewCellReactor

    init(original: RecipientUserCollectionViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
