//
//  SimpleDataSourcesSection.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/17.
//

import Foundation
import RxDataSources

struct SimpleDataSourcesSection<T> {
    var header: String
    var items: [Item]
}

extension SimpleDataSourcesSection: SectionModelType {
    typealias Item = SimpleCellReactor<T>
    
    init(original: SimpleDataSourcesSection, items: [Item]) {
        self = original
        self.items = items
    }
}
