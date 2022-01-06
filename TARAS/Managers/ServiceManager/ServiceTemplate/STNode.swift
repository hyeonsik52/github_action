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
    
    ///노드를 매개변수 컨테이너로 변환한다.
    var toArgument: STArgument? {
        return self as? STArgument
    }
}
