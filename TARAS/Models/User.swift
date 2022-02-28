//
//  User.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/09.
//

import Foundation

struct User: Identifiable {
    
    ///식별 아이디
    let id: String
    
    ///유저 아이디
    let username: String
    ///유저 이름
    let displayName: String
    
    ///유저 이메일
    let email: String?
    ///유저 전화번호
    let phonenumber: String?
    
    let role: UserRole? = nil
}

extension User: FragmentModel {
    
    init(_ fragment: UserFragment) {
        
        self.id = fragment.id
        
        self.username = fragment.username
        self.displayName = fragment.displayName
        
        self.email = fragment.email
        self.phonenumber = fragment.phoneNumber
        
//        self.role = fragment.role
    }
    
    init?(member fragment: MemberFragment) {
        guard let displayName = fragment.displayName else { return nil }
        
        self.id = fragment.id
        
        self.username = ""
        self.displayName = displayName
        
        self.email = nil
        self.phonenumber = nil
        
//        self.role = fragment.role
    }
    
    init(option fragment: UserFragment?) {
        
        self.id = fragment?.id ?? Self.unknownId

        self.username = fragment?.username ?? Self.unknownName
        self.displayName = fragment?.displayName ?? "알 수 없는 사용자"

        self.email = fragment?.email
        self.phonenumber = fragment?.phoneNumber
        
//        self.role = fragment?.role
    }
}

extension User {
    
    init(_ fragment: UserRawFragment) {
        
        self.id = fragment.id
        
        self.username = fragment.username
        self.displayName = fragment.displayName
        
        self.email = fragment.email
        self.phonenumber = fragment.phoneNumber
        
//        self.role = fragment.role
    }
}

extension User: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.username)
        hasher.combine(self.displayName)
        hasher.combine(self.email)
        hasher.combine(self.phonenumber)
    }
}
