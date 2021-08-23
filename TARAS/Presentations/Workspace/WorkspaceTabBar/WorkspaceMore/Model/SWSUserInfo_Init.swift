//
//  SWSUserInfo_Init.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension SWSUserInfo {
    
    convenience init?(_ swsInfo: SWSInfoType?) {
        guard let swsInfo = swsInfo else { return nil }
        self.init(
            swsInfo.id,
            idx: swsInfo.userIdx,
            name: swsInfo.name,
            profileImageURL: swsInfo.profileImageUrl,
            phoneNumber: swsInfo.phoneNumber?.denationalizePhoneNumber,
            email: swsInfo.email,
            groups: swsInfo.groups.map{
                ServiceUserGroup(
                    UID: $0.id,
                    idx: $0.groupIdx,
                    name: $0.name,
                    profileImageURL: $0.profileImageUrl,
                    place: ServicePlace(.none, stop: $0.stop),
                    stopsInCharge: $0.stopsInCharge.compactMap { ServicePlace(.none, stop: $0) }
                )
            },
            place: ServicePlace(.none, stop: swsInfo.swsStop),
            groupPlace: ServicePlace(.none, stop: swsInfo.groupPlace)
        )
    }
}
