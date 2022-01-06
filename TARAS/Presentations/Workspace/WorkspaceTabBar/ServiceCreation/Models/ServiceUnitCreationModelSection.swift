//
//  ServiceUnitCreationModelSection.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import Foundation
import RxDataSources

struct ServiceUnitCreationModelSection {
    var header: String
    var items: [Item]
}

extension ServiceUnitCreationModelSection: SectionModelType {
    typealias Item = ServiceCreationCellReactor
    
    init(original: ServiceUnitCreationModelSection, items: [ServiceCreationCellReactor]) {
        self = original
        self.items = items
    }
}
