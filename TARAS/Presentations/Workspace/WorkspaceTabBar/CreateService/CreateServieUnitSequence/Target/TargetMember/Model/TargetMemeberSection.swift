//
//  TargetMemeberSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import RxDataSources

struct TargetMemeberSection {
  var header: String
  var items: [Item]
}

extension TargetMemeberSection: SectionModelType {
  typealias Item = TargetMemberCellReactor

   init(original: TargetMemeberSection, items: [Item]) {
    self = original
    self.items = items
  }
}
