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
    var ID: String!
    /// 유저 아이디
    var id: String!
    /// 비밀번호
    var password: String!
    /// 이름
    var name: String!
    /// 이메일
    var email: String?
    /// 전화번호
    var phoneNumber: String?
}

extension Account: FragmentModel {
    
    init(_ fragment: UserFragment) {
        
        self.ID = fragment.id
        self.id = fragment.username
        self.name = fragment.displayName
        self.email = fragment.email
        self.phoneNumber = fragment.phoneNumber
    }
    
    init(option fragment: UserFragment?) {
        
        self.ID = fragment?.id
        self.id = fragment?.username
        self.name = fragment?.displayName
        self.email = fragment?.email
        self.phoneNumber = fragment?.phoneNumber
    }
}

extension Account: Equatable {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.ID == rhs.ID)
    }
}
