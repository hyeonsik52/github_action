//
//  MultipleError.swift
//  TARAS
//
//  Created by nexmond on 2022/03/24.
//

import Foundation
import Apollo

struct MultipleError: Error {
    let graphQLErrors: [GraphQLError]?
    
    var isUnauthorized: Bool {
        return self.graphQLErrors?.contains { $0.message?.lowercased().contains("unauthorized") ?? false } ?? false
    }
}
