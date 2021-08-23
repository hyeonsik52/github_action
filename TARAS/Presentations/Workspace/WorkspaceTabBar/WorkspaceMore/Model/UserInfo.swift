//
//  UserInfo.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/08.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

///유저의 기본 정보
class UserInfo: TargetBase {
    
    ///유저 아이디 (유니크 아이디가 아님)
    private(set) var userId: String!
    ///전화번호 82~
    private(set) var phoneNumber: String?
    ///이메일
    private(set) var email: String!
    ///워크스페이스 유저 정보
    private(set) var swsUserInfo: SWSUserInfo?
    
    convenience init(
        _ UID: String,
        idx: Int,
        name: String,
        profileImageURL: String? = nil,
        userId: String,
        phoneNumber: String?,
        email: String,
        swsUserInfo: SWSUserInfo? = nil
    ) {
        self.init(UID, idx: idx, name: name, profileImageURL: profileImageURL)
        
        self.userId = userId
        self.phoneNumber = phoneNumber
        self.email = email
        self.swsUserInfo = swsUserInfo
    }
}
