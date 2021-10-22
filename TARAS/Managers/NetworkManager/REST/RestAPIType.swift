//
//  RestAPIType.swift
//  TARAS-AL
//
//  Created by nexmond on 2021/10/15.
//

import Foundation

enum RestAPIType<T: RestAPIResponse> {
    
    case login(input: LoginRequestModel)
    case logout(input: LogoutRequestModel)
    
    var url: URL {
        let path: String = {
            switch self {
            case .login:
                return "auth/token/"
            case .logout:
                return "auth/revoke_token/"
            }
        }()
        return URL(string: "http://graass-dev.twinny-tarp.com:8000/")!.appendingPathComponent(path)
    }
    
    var parameters: [String: Any] {
        switch self {
        case .login(let input):
            return input.dictionary
        case .logout(let input):
            return input.dictionary
        }
    }
    
    var responseType: T.Type {
        return T.self
    }
}
