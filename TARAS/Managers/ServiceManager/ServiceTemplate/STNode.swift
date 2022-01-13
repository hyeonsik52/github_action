//
//  STNode.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

protocol STNode {
    var key: String { get }
    var subNodes: [STNode]? { get }
}

extension STNode {
    var key: String {
        return ""
    }
    var subNodes: [STNode]? {
        return nil
    }
    subscript(key: String) -> STNode? {
        return self.subNodes?.first { $0.key == key }
    }
}

extension String: STNode {}
extension NSString: STNode {}
extension Bool: STNode {}
extension Int: STNode {}
extension JSON: STNode {
    var key: String {
        return self.keys.first ?? ""
    }
}

extension STNode {
    
    func `as`<T>() -> T? {
        return self as? T
    }
    
    ///노드를 매개변수 컨테이너로서 가져온다
    var asArgument: STArgument? { self.as() }
    
    var asString: String? { self.as() }
    var asBool: Bool? { self.as() }
    var asInt: Int? { self.as() }
    var asJSON: JSON? { self.as() }
}
