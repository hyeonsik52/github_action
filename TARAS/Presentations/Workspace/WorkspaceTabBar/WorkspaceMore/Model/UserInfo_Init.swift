//
//  UserInfo_Init.swift
//  Dev-ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension UserInfo {
    
    convenience init?(_ user: UserInfoType?) {
        guard let user = user else { return nil }
        self.init(
            user.id,
            idx: user.userIdx,
            name: user.name,
            profileImageURL: user.profileImageUrl,
            userId: user.userId,
            phoneNumber: user.phoneNumber?.denationalizePhoneNumber,
            email: user.email,
            swsUserInfo: SWSUserInfo(user.swsInfo)
        )
    }
}
