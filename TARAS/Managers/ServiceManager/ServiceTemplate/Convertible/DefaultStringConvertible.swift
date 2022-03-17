//
//  DefaultStringConvertible.swift
//  TARAS
//
//  Created by nexmond on 2022/03/17.
//

import Foundation

protocol DefaultStringConvertible {
    static var defaultValue: Self { get }
    init(string: String)
}

extension DefaultStringConvertible where Self: LosslessStringConvertible {
    
    init(string: String) {
        self = Self(string) ?? Self.defaultValue
    }
}

extension String: DefaultStringConvertible {
    static var defaultValue: String { "" }
}

extension Bool: DefaultStringConvertible {
    static var defaultValue: Bool { false }
}

extension Int: DefaultStringConvertible {
    static var defaultValue: Int { 0 }
}

extension Float: DefaultStringConvertible {
    static var defaultValue: Float { 0 }
}
