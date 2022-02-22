//
//  Identifiable.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

protocol Identifiable: Equatable {
    associatedtype ID : Hashable
    var id: Self.ID { get }
}

extension Identifiable {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.id == rhs.id)
    }
}

extension Identifiable where ID: StringProtocol {
    
    static var unknownId: String { "-1" }
    static var unknownName: String { "unknown" }
    
    var isUnknown: Bool {
        return (self.id == Self.unknownId)
    }
    
    var isValid: Bool {
        return !self.isUnknown
    }
}
