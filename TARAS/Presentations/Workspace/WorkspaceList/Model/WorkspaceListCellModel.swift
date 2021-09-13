//
//  WorkspaceListCellModel.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/29.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import Apollo

struct WorkspaceListCellModel {
    var swsIdx: Int
    var name: String
    var memberCount: Int?
    var creatAt: String?
    var profileImageURL: String?
//    var joinState: JoinStateType
    
//    init(requested: WorkspaceRequested) {
//        self.swsIdx = requested.node?.swsIdx ?? 0
//        self.name = requested.node?.sws.asSws?.name ?? ""
//        self.memberCount = requested.node?.sws.asSws?.memberCount ?? 0
//        self.creatAt = requested.node?.sws.asSws?.createAt ?? ""
//        self.profileImageURL = requested.node?.sws.asSws?.profileImageUrl ?? ""
//        self.joinState = .requested
//    }
//
//    init(joined: WorkspaceJoined) {
//        self.swsIdx = joined.swsIdx
//        self.name = joined.name
//        self.memberCount = joined.memberCount
//        self.creatAt = joined.createAt
//        self.profileImageURL = joined.profileImageUrl
//        self.joinState = .joined
//    }
//
//    init(infoByCode: WorkspaceInfoByCode) {
//        self.swsIdx = infoByCode.swsIdx
//        self.name = infoByCode.name
//        self.memberCount = infoByCode.memberCount
//        self.creatAt = infoByCode.createAt
//        self.profileImageURL = infoByCode.profileImageUrl
//        self.joinState = .none
//    }
}
