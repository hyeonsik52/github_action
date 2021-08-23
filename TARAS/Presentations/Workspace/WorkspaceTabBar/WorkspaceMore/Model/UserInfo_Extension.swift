//
//  UserInfo_Extension.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/08/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension UserInfo {
    
    ///유효한 유저 이름 (워크스페이스 정보가 없으면 기본 정보에서 가져옴)
    var validName: String {
        if let name = self.swsUserInfo?.name, !name.isEmpty {
            return name
        }else if !self.name.isEmpty {
            return self.name
        }
        return "-"
    }
    
    ///유효한 이메일 (워크스페이스 정보가 없으면 기본 정보에서 가져옴)
    var validEmail: String {
        if let email = self.swsUserInfo?.email, !email.isEmpty {
            return email
        }else if let email = self.email, !email.isEmpty {
            return email
        }
        return "-"
    }
    
    ///유효한 전화번호 (워크스페이스 정보가 없으면 기본 정보에서 가져옴)
    var validPhoneNumber: String {
        if let phoneNumber = self.swsUserInfo?.phoneNumber, !phoneNumber.isEmpty {
            return phoneNumber
        }else if let phoneNumber = self.phoneNumber, !phoneNumber.isEmpty {
            return phoneNumber
        }
        return "-"
    }
    
    ///유효한 프로필 이미지 (워크스페이스 정보가 없으면 기본 정보에서 가져옴)
    var validProfileImageUrl: String {
        if let profileImageURL = self.swsUserInfo?.profileImageURL, !profileImageURL.isEmpty {
            return profileImageURL
        }else if let profileImageURL = self.profileImageURL, !profileImageURL.isEmpty {
            return profileImageURL
        }
        return "-"
    }
}

