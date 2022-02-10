//
//  ServiceDetailServiceUnitSection.swift
//  TARAS
//
//  Created by nexmond on 2022/02/08.
//

import RxDataSources

struct ServiceDetailServiceUnitSection {
    var items: [Item]
}

extension ServiceDetailServiceUnitSection: SectionModelType {
    typealias Item = ServiceDetailServiceUnitCellReactor
    
    init(original: ServiceDetailServiceUnitSection, items: [Item]) {
        self = original
        self.items = items
    }
}
