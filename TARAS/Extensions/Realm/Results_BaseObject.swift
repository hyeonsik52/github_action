//
//  Results_BaseObject.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/04/27.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import RealmSwift

extension Results where Element: BaseObject {

    var getFirst: Element? {
        return first
    }

    func getFirst(_ query: String) -> Element? {
        return filter(query).first
    }

    func getFirst(property: String, value: Any) -> Element? {
        if value is String {
            return getFirst("\(property) == '\(value)'")
        } else {
            return getFirst("\(property) == \(value)")
        }
    }

    func update(_ closure:@escaping (Results) -> Void) {
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
