//
//  LogoutRequestModel.swift
//  TARAS-AL
//
//  Created by nexmond on 2021/10/16.
//

import Foundation

struct LogoutRequestModel: RestAPIRequest {
    typealias Response = LogoutResponseModel
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    let token: String
}
