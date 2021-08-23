//
//  SWSUserInfo.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

///워크스페이스 유저 정보
class SWSUserInfo {
    
    ///유니크 아이디
    let UID: String
    ///유저 인덱스
    let idx: Int
    
    ///이름
    let name: String?
    ///프로필 이미지 주소
    let profileImageURL: String?
    ///전화번호
    let phoneNumber: String?
    ///이메일
    let email: String?
    
    ///소속된 그룹 목록
    let groups: [ServiceUserGroup]
    ///기본 위치
    let place: ServicePlace?
    
    ///유효한 그룹 기본 위치
    let groupPlace: ServicePlace?
    
    init(
        _ UID: String,
        idx: Int,
        name: String?,
        profileImageURL: String? = nil,
        phoneNumber: String?,
        email: String?,
        groups: [ServiceUserGroup],
        place: ServicePlace?,
        groupPlace: ServicePlace?
    ) {
        self.UID = UID
        self.idx = idx
        self.name = name
        self.profileImageURL = profileImageURL
        
        self.phoneNumber = phoneNumber
        self.email = email
        
        self.groups = groups
        self.place = place
        self.groupPlace = groupPlace
    }
}
