//
//  LoginResponseModel.swift
//  TARAS
//
//  Created by nexmond on 2021/10/15.
//

import Foundation

struct LoginResponseModel: RestAPIResponse {
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
        case refreshToken = "refresh_token"
    }
    
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let scope: String
    let expiresIn: Int
}
