//
//  Convertibles.swift
//  TARAS
//
//  Created by nexmond on 2022/03/17.
//

import Foundation

struct ConvertibleArgument: StringConvertibleInitializer { }

struct ConvertibleReceiver: StringConvertibleInitializer { }

struct ConvertibleDestination: StringConvertibleInitializer { }

struct ConvertibleLoadingDestination: StringConvertibleInitializer { }

struct ConvertibleUnknown: StringConvertibleInitializer { }

struct JSON: StringConvertibleInitializer {
    var data: [String: Any] = [:]
}
