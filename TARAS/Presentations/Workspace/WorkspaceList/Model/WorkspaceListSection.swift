//
//  WorkspaceListSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/29.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import RxDataSources

struct WorkspaceListSection {
  var header: String
  var items: [Item]
}
extension WorkspaceListSection: SectionModelType {
  typealias Item = WorkspaceListCellReactor

   init(original: WorkspaceListSection, items: [Item]) {
    self = original
    self.items = items
  }
}
