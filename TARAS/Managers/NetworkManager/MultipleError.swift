//
//  MultipleError.swift
//  TARAS
//
//  Created by nexmond on 2022/03/24.
//

import Foundation
import Apollo

struct MultipleError: Error, LocalizedError {
    let graphQLErrors: [GraphQLError]?
    
    var isUnauthorized: Bool {
        return self.graphQLErrors?.contains { $0.message?.lowercased().contains("unauthorized") ?? false } ?? false
    }
    
    var errorDescription: String? {
        return self.graphQLErrors?.compactMap { $0.message }.joined(separator: " / ")
    }
}
