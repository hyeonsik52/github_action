//
//  SessionAPI.swift
//  TARAS
//
//  Created by nexmond on 2022/03/24.
//

import Foundation

struct SessionAPI<T: SessionAPIRequest>: RestAPI {
    
    let request: T
    
    var url: URL {
        let path: String = {
            switch self.request.name {
            case .login, .refreshSession:
                return "token/"
            case .logout:
                return "revoke_token/"
            }
        }()
        return URL(string: Info.restEndpoint)!.appendingPathComponent(path)
    }
    
    var parameters: [String: Any] {
        return self.request.dictionary
    }
    
    static func api(_ request: T) -> Self {
        return .init(request: request)
    }
}
