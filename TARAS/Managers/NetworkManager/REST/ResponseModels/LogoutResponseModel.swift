//
//  LogoutResponseModel.swift
//  TARAS-AL
//
//  Created by nexmond on 2021/10/17.
//

import Foundation

struct LogoutResponseModel: RestAPIResponse {
    
    enum CodingKeys: String, CodingKey {
        case result
    }
    
    let result: Bool
}
