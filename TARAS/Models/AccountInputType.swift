//
//  AccountInputType.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

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
