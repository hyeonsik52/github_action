//
//  WorkspaceListCellReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/29.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class WorkspaceListCellReactor: Reactor {
  typealias Action = NoAction

  let initialState: Workspace

  init(_ workspace: Workspace) {
    self.initialState = workspace
  }
}
