//
//  LogoutRequestModel.swift
//  TARAS
//
//  Created by nexmond on 2021/10/16.
//

import Foundation

struct LogoutRequestModel: SessionAPIRequest {
    typealias Response = LogoutResponseModel
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    let token: String
    
    let name: SessionAPIName = .logout
}
