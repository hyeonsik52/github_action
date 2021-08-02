//
//  BaseObject.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import RealmSwift

class BaseObject: Object {

    @objc dynamic var index: Int = 0

    override static func primaryKey() -> String? {
        return "index"
    }

    override static func indexedProperties() -> [String] {
        return ["index"]
    }
}

protocol BaseObjectAutoIncrementProtocol {
    static var lastIndex: Int { get set }
}

extension BaseObject {

    var nextIndex: Int {
        objc_sync_enter(type(of: self))
        defer {objc_sync_exit(type(of: self))}

        if let auto = self as? BaseObjectAutoIncrementProtocol {

            let autoType = type(of: auto)

            if autoType.lastIndex == NSNotFound {
                autoType.lastIndex = (type(of: self).allObjects.max(ofProperty: "index") ?? -1)
            }
            autoType.lastIndex += 1
            return autoType.lastIndex
        }
        return 0
    }

    convenience init(index: Int = NSNotFound) {
        self.init()
        self.index = nextIndex
    }
}
