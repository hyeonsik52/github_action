//
//  TargetMemberCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class TargetMemberCellReactor: Reactor {
  typealias Action = NoAction

  let initialState: TargetMemberCellModel

  init(_ workspaceCellModel: TargetMemberCellModel) {
    self.initialState = workspaceCellModel
  }
}
