//
//  RecipientUserCellModel.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import Apollo

struct RecipientCellModel {
    
    /// 수신자의 인덱스입니다.
    var idx: Int
    
    /// 수신자의 이름입니다.
    /// - '개인' 일 경우: "박수지"
    /// - '그룹' 일 경우: "플랫폼본부 iOS팀"
    var name: String
    
    /// 수신자가 속한 첫번째 그룹의 이름입니다.
    /// - '개인' 일 경우: "플랫폼본부 iOS팀"
    /// - '그룹' 일 경우: nil
    var groupName: String?
    
    /// 수신자의 프로필 이미지 URL 입니다.
    var profileImageURL: String?
    
    /// 수신자의 타입입니다. (.group, .user)
    var recipientType: ServiceUnitRecipientType
    
    /// 기존에 선택된 수신자들을 수정 시 사용합니다. 해당 셀의 선택 유무를 나타냅니다.
    var isSelected: Bool
    
    init?(
        group: GroupListQuery.Data.SwsGroupsConnection.Edge.Node?,
        isSelected: Bool = false
    ) {
        guard let group = group else { return nil }
        
        self.idx = group.groupIdx
        self.name = group.name
        self.groupName = nil
        self.profileImageURL = group.profileImageUrl
        self.recipientType = .group
        self.isSelected = isSelected
    }
    
    init?(
        user: UserListQuery.Data.SwsUsersConnection.Edge.Node?,
        isSelected: Bool = false
    ) {
        guard let user = user,
              /// 유저의 해당 워크스페이스 내 정보입니다.
              let swsInfo = user.userSwsInfo?.asUserSwsInfo else { return nil }
        
        self.idx = user.userIdx
        
        // 유저가 따로 설정한 워크스페이스 이름이 있다면 그 이름을 표출합니다.
        // 없다면 전체 설정의 이름을 표출합니다.
        self.name = swsInfo.name ?? user.name
        
        // 유저가 속한 그룹들 중 첫 번째 그룹을 표출합니다.
        // 왜 첫 번째 그룹만 표시하냐구요? 어떤 기준이 있는걸까요? 아니요. 기획이 그렇게 나왔기 때문이죠.
        let groupName = swsInfo.groupsConnection.edges.compactMap { $0.node?.name ?? nil }.first
        self.groupName = groupName ?? "(소속 그룹 없음)"
        
        self.recipientType = .user
        self.isSelected = isSelected
    }
}
