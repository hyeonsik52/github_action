//
//  RestError.swift
//  TARAS
//
//  Created by nexmond on 2022/03/24.
//

import Foundation

struct RestError: Error {
    
    var code: String
    var description: String?
    
    var logDescription: String {
        return "\(self.code)\(self.description == nil ? "": ": \(self.description!)")"
    }
}
