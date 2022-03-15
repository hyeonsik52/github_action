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
    case refreshSession(input: RefreshSessionRequestModel)
    
    var url: URL {
        let path: String = {
            switch self {
            case .login, .refreshSession:
                return "token/"
            case .logout:
                return "revoke_token/"
            }
        }()
        return URL(string: Info.restEndpoint)!.appendingPathComponent(path)
    }
    
    var parameters: [String: Any] {
        switch self {
        case .login(let input):
            return input.dictionary
        case .logout(let input):
            return input.dictionary
        case .refreshSession(let input):
            return input.dictionary
        }
    }
    
    var responseType: T.Type {
        return T.self
    }
}
