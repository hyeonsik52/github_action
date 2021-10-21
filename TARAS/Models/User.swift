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
    let userName: String
    ///유저 이름
    let displayName: String
    
    ///유저 이메일
    let email: String?
    ///유저 전화번호
    let phonenumber: String?
}

extension User: FragmentModel {
    
    init(_ fragment: UserFragment) {
        
        self.id = fragment.id
        
        self.userName = fragment.username
        self.displayName = fragment.displayName
        
        self.email = fragment.email
        self.phonenumber = fragment.phoneNumber
    }
    
    init(member fragment: MemberFragment) {
        
        self.id = fragment.id
        
        self.userName = ""
        self.displayName = fragment.displayName
        
        self.email = nil
        self.phonenumber = nil
    }
}
