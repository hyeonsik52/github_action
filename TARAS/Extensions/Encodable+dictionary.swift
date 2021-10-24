//
//  Encodable+dictionary.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/10/22.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments),
              let dictionary = jsonObject as? [String: Any]
        else { return [:] }
        return dictionary
    }
}
