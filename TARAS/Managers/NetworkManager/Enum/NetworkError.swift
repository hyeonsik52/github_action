//
//  GraphQLError.swift
//
//  Created by Suzy Park on 2020/05/12.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    
    case none
    
    // 액세스 토큰 만료 혹은 액세스 토큰 없음
    case unauthorized
    
    // 권한 없음
    case forbidden
    
    // 클라이언트 요청 오류
    case clientSide
    
    // 서버 오류
    case serverSide
    
    // 기타 오류
    case etc(String?)
    
    init(rawValue: Int) {
        switch rawValue {
        case 0: self = .none
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 400: self = .clientSide
        case 500: self = .serverSide
        default: self = .etc(nil)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .none: return 0
        case .etc: return 1
        case .unauthorized: return 401
        case .forbidden: return 403
        case .clientSide: return 400
        case .serverSide: return 500
        }
    }
    
    var errorMessage: String? {
        guard case .etc(let message) = self else { return nil }
        return message
    }
}
