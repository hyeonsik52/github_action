//
//  TEST_TB.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import RealmSwift

class TEST_TB: BaseObject {
    
    @objc dynamic var content: String?
    
    let list = List<TEST_TB>()
}

extension TEST_TB: BaseObjectAutoIncrementProtocol {
    
    static var lastIndex: Int = NSNotFound
}
