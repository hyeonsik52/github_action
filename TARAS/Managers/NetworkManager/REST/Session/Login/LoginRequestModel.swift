//
//  LoginRequestModel.swift
//  TARAS
//
//  Created by nexmond on 2021/10/15.
//

import Foundation

struct LoginRequestModel: SessionAPIRequest {
    typealias Response = LoginResponseModel
    
    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case username
        case password
    }
    
    let grantType: String
    let username: String
    let password: String
    
    let name: SessionAPIName = .login
}
