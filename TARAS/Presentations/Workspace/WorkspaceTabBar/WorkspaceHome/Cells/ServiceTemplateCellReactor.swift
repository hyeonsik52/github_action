//
//  ServiceTemplateCellReactor.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/29.
//

import ReactorKit
import RxCocoa
import RxSwift

class ServiceTemplateCellReactor: Reactor {
  typealias Action = NoAction

  let initialState: ServiceTemplate

  init(_ template: ServiceTemplate) {
    self.initialState = template
  }
}
