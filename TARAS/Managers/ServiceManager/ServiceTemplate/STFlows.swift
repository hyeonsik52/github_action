//
//  STFlows.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

struct STFlows {

    var flows: [STFlow]

    private var current: STFlow?

    init(_ flows: [STFlow]) {
        self.flows = flows
    }

    @discardableResult
    mutating func next() -> STFlow? {
        if let current = self.current, let index = flows.firstIndex(where: { $0 == current }), index+1 < flows.count {
            let flow = flows[index+1]
            self.current = flow
            return flow
        } else {
            return flows.first
        }
    }

    func show(on: UIViewController?) {
        guard let viewController = current?.view as? UIViewController else { return }
        on?.navigationPush(viewController, animated: true, bottomBarHidden: true)
    }
}
