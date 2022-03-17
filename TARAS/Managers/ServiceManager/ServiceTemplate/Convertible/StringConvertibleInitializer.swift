//
//  StringConvertibleInitializer.swift
//  TARAS
//
//  Created by nexmond on 2022/03/17.
//

import Foundation

protocol StringConvertibleInitializer: DefaultStringConvertible, LosslessStringConvertible {
    init()
}

extension StringConvertibleInitializer {
    
    static var defaultValue: Self { .init() }
    
    public init?(_ description: String) {
        return nil
    }
    
    var description: String { .init(self) }
}

extension Array: StringConvertibleInitializer { }
