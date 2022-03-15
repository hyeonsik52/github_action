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
    
    static func serverEndpoint(scheme: String) -> String {
        return scheme + "://" + self["ServerEndpoint"]!
    }
    
    static var restEndpoint: String {
        return self.serverEndpoint(scheme: "https") + "/auth"
    }
    
    static var graphEndpoint: String {
        return self.serverEndpoint(scheme: "https") + "/v1/graphql"
    }
    
    static var graphWSEndpoint: String {
        return self.serverEndpoint(scheme: "wss") + "/v1/graphql"
    }
    
    static var serverRestClientId: String {
        return self["ServerRestClientId"]!
    }
    
    static var serverRestClientSecret: String {
        return self["ServerRestClientSecret"]!
    }
    
    static var appVersion: String {
        return self["CFBundleShortVersionString"]!
    }
    
    static var appBuild: String {
        return self[kCFBundleVersionKey as String]!
    }
}
