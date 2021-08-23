//
//  WaypointSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Twinny on 2020/07/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import RxDataSources

struct WaypointSection {
    var items: [Item]
}

extension WaypointSection: SectionModelType {
    typealias Item = WaypointCellViewReactor
    
    init(original: WaypointSection, items: [Item]) {
        self = original
        self.items = items
    }
}
