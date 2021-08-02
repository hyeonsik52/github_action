//
//  Info.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/02.
//

import Foundation

enum Info {
    
    static subscript<T>(key: String) -> T? {
        return Bundle.main.infoDictionary?[key] as? T
    }
    
    static var DBVersion: UInt64 {
        let value: NSString = self["DBVersion"]!
        return .init(bitPattern: value.longLongValue)
    }
    
    static var serverEndpoint: String {
        return self["ServerEndpoint"]!
    }
}
