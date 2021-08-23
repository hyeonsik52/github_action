//
//  AddWaypointSection.swift
//  Dev-ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import RxDataSources

struct AddWaypointSection {
    var items: [Item]
}

extension AddWaypointSection: SectionModelType {
    typealias Item = AddWaypointCellViewReactor
    
    init(original: AddWaypointSection, items: [Item]) {
        self = original
        self.items = items
    }
}
