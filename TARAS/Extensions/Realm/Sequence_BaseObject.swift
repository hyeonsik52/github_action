//
//  Sequence_BaseObject.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/04/27.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension Sequence where Element: BaseObject {
    
    var getFirst: Element? {
        return first(where: {_ in true})
    }

    func getFirst(_ query: String) -> Element? {
        let predicate = NSPredicate(format: query)
        return filter{predicate.evaluate(with: $0)}.first
    }

    func getFirst(property: String, value: Any) -> Element? {
        if value is String {
            return getFirst("\(property) == '\(value)'")
        } else {
            return getFirst("\(property) == \(value)")
        }
    }
    
    @discardableResult
    func add() -> Self {
        RealmManager.shared.realmWrite { realm in
            realm.add(self)
        }
        return self
    }

    func update(_ closure:@escaping (Self) -> Void) {
        RealmManager.shared.realmWrite { _ in
            closure(self)
        }
    }

    func delete() {
        RealmManager.shared.realmWrite { realm in
            realm.delete(self)
        }
    }
}
