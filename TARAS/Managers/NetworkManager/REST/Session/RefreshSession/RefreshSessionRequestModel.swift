//
//  RefreshSessionRequestModel.swift
//  TARAS
//
//  Created by nexmond on 2022/02/23.
//

import Foundation

struct RefreshSessionRequestModel: SessionAPIRequest {
    typealias Response = LoginResponseModel
    
    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case refreshToken = "refresh_token"
    }
    
    let grantType: String = "refresh_token"
    let refreshToken: String
    
    let name: SessionAPIName = .refreshSession
}
