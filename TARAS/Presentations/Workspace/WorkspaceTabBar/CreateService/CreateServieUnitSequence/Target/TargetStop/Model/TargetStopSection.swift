//
//  TargetStopSection.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import RxDataSources

struct TargetStopSection {
  var items: [Item]
}
extension TargetStopSection: SectionModelType {
  typealias Item = TargetStopCellReactor

   init(original: TargetStopSection, items: [Item]) {
    self = original
    self.items = items
  }
}
