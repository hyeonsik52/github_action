//
//  ServiceUnitTargetModelSection.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/01.
//

import Foundation
import RxDataSources

struct ServiceUnitTargetModelSection {
    var header: String
    var items: [Item]
}

extension ServiceUnitTargetModelSection: SectionModelType {
    typealias Item = ServiceUnitTargetCellReactor
    
    init(original: ServiceUnitTargetModelSection, items: [ServiceUnitTargetCellReactor]) {
        self = original
        self.items = items
    }
}
