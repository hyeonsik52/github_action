//
//  GenericScalar.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation
import Apollo

public typealias DateTime = Date
public typealias JSONString = String
public typealias bpchar = String
public typealias bytea = String
public typealias jsonb = GenericScalar
public typealias bigint = String
public typealias timestamptz = Date
public typealias float8 = Double

public struct GenericScalar: JSONDecodable, JSONEncodable {
    
    let value: Any
    
    public init(jsonValue value: JSONValue) throws {
        if let jsonList = value as? [[String: Any]] {
            self.value = jsonList
        } else if let json = value as? [String: Any] {
            self.value = json
        } else if let array = value as? [Any] {
            self.value = array
        } else if let string = value as? String {
            self.value = string
        } else {
            throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
        }
    }
    
    public var jsonValue: JSONValue {
        return self.value
    }
}

extension GenericScalar {
    
    func toType<T>() -> T? {
        return self.value as? T
    }
    
    var toDictionary: [String: Any]? {
        return self.toType()
    }
    
    var toDictionaries: [[String: Any]]? {
        return self.toType()
    }
    
    var toString: String? {
        return self.toType()
    }
    
    func toArray<T>() -> [T]? {
        return self.toType()
    }
}

extension Date: JSONDecodable, JSONEncodable {
    
    public init(jsonValue value: JSONValue) throws {
        guard let string = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
        
        if let data = string.ISO8601Date {
            self = data
        } else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
    }
    
    public var jsonValue: JSONValue {
        return self.ISO8601Format
    }
}
