//
//  ServiceTemplateListSection.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/29.
//

import Foundation
import RxDataSources

struct ServiceTemplateListSection {
  var header: String
  var items: [Item]
}

extension ServiceTemplateListSection: SectionModelType {
  typealias Item = ServiceTemplateCellReactor

   init(original: ServiceTemplateListSection, items: [Item]) {
    self = original
    self.items = items
  }
}
