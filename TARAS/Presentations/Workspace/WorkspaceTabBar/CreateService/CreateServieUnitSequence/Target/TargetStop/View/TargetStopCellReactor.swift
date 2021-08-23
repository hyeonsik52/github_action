//
//  TargetLocationCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class TargetStopCellReactor: Reactor {
  typealias Action = NoAction

  let initialState: TargetStopCellModel

  init(_ model: TargetStopCellModel) {
    self.initialState = model
  }
}
