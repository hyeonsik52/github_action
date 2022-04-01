//
//  GraphQLSelectionSet.swift
//  TARAS
//
//  Created by nexmond on 2022/03/30.
//

import Foundation
import Apollo

extension GraphQLSelectionSet {
    
    func uniqueDescription() throws -> String {
        let type = (self.resultMap["__typename"] as? String) ?? "unknown"
        let jsonData = try JSONSerialization.data(
            withJSONObject: self.resultMap,
            options: [.fragmentsAllowed, .sortedKeys]
        )
        let description = String(data: jsonData, encoding: .utf8) ?? ""
        return "\(type)_\(description)"
    }
}
