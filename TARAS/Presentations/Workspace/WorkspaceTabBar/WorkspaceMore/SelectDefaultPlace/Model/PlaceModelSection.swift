//
//  PlaceModelSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxDataSources

struct PlaceModelSection {
    var header: String
    var items: [Item]
}

extension PlaceModelSection: SectionModelType {
    typealias Item = ServicePlace
    
    init(original: PlaceModelSection, items: [ServicePlace]) {
        self = original
        self.items = items
    }
}
