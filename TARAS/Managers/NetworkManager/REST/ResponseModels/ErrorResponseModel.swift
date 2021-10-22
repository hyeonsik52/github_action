//
//  ErrorResponseModel.swift
//  TARAS-AL
//
//  Created by nexmond on 2021/10/15.
//

import Foundation

struct ErrorResponseModel: RestAPIResponse {
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
    
    let error: String
    let errorDescription: String
}

extension ErrorResponseModel {
    
    var toRestError: RestError {
        return .init(code: self.error, description: self.errorDescription)
    }
}
