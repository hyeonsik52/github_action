//
//  ThreadConfined_BaseObject.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/04/27.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import RealmSwift

extension ThreadConfined where Self: BaseObject {

    // 스레드 간 이동시 레퍼런스 래핑
    // [주의] 레퍼런스를 만드는 순간 램의 상태가 고정됨
    var threadSafeReference: ThreadSafeReference<Self> {
        return ThreadSafeReference(to: self)
    }

    static var allObjects: Results<Self> {
        return RealmManager.shared.allObjects(self)
    }

    static func allObjects(_ query: String?) -> Results<Self> {
        guard let query = query else { return allObjects }
        return allObjects.filter(query)
    }

    static func allObjects(property: String, value: Any) -> Results<Self> {
        if value is String {
            return allObjects("\(property) == '\(value)'")
        } else {
            return allObjects("\(property) == \(value)")
        }
    }

    static var getFirst: Self? {
        return allObjects.first
    }

    static func getFirst(_ query: String) -> Self? {
        return allObjects(query).first
    }

    static func getFirst(property: String, value: Any?) -> Self? {
        guard let value = value else { return nil }
        return allObjects(property: property, value: value).first
    }

    @discardableResult
    func add() -> Self {
        RealmManager.shared.realmWrite { realm in
            realm.add(self)
        }
        Log.debug("[Realm] Added \(self)")
        return self
    }

    func update(_ closure: @escaping (Self) -> Void) {
        RealmManager.shared.realmWrite { _ in
            closure(self)
        }
        Log.debug("[Realm] Modified \(self)")
    }
    
    func delete() {
        RealmManager.shared.realmWrite { realm in
            realm.delete(self)
        }
        Log.debug("[Realm] Deleted \(self)")
    }
}
