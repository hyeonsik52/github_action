//
//  Account.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit

/// 계정 정보
struct Account {
    
    /// 식별 아이디
    var id: String!
    /// 유저 아이디
    var ID: String!
    /// 비밀번호
    var password: String!
    /// 이름
    var name: String!
    /// 이메일
    var email: String?
    /// 인증토큰 (계정 찾기)
    var authToken: String?
    /// 전화번호
    var phoneNumber: String?
}

extension Account: FragmentModel {
    
    init(_ fragmnet: UserFragment) {
        
        self.id = fragmnet.id
        self.ID = fragmnet.username
        self.name = fragmnet.displayName
        self.email = fragmnet.email
        self.phoneNumber = fragmnet.phoneNumber
    }
}

/// 계정 입력 유형
enum AccountInputType: String {
    /// 아이디
    case id = "아이디"
    /// 비밀번호
    case password = "비밀번호"
    /// 이름
    case name = "이름"
    /// 이메일
    case email = "이메일"
    /// 전화번호
    case phoneNumber = "전화번호"
}

extension AccountInputType {
    
    var policy: InputPolicy {
        switch self {
        case .id: return .id
        case .password: return .password
        case .name: return .name
        case .email: return .email
        case .phoneNumber: return .phoneNumber
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .name: return .default
        case .email: return .emailAddress
        case .phoneNumber: return .numberPad
        default: return .asciiCapable
        }
    }
}
