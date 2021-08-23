//
//  TargetMemberCellModel.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import Apollo

typealias SelectedTargetMember = (idx: Int, type: ServiceUnitRecipientType)

struct TargetMemberCellModel {
    
    /// 대상의 인덱스입니다.
    var idx: Int
    
    /// 대상의 이름입니다.
    /// - '회원-개인' 일 경우: "박수지"
    /// - '회원-그룹' 일 경우: "플랫폼본부 iOS팀"
    var name: String
    
    /// 대상이 속한 첫번째 그룹의 이름입니다.
    /// - '회원-개인' 일 경우: "플랫폼본부 iOS팀"
    /// - '회원-그룹' 일 경우: nil
    var groupName: String?
    
    /// 대상의 프로필 이미지 URL 입니다.
    var profileImageURL: String?
    
    /// 대상의 타입입니다. (.group, .user)
    var recipientType: ServiceUnitRecipientType
    
    /// 대상에 등록된 기본위치의 인덱스입니다.
    /// - '회원-개인' 일 경우: 처음에는 개인이 속한 그룹의 기본 위치로 설정됨. 무소속 회원의 기본 위치는 nil. 사용자가 변경할 수 있음
    /// - '회원-그룹' 일 경우: optional
    var stopIdx: Int?
    
    /// 기존에 선택된 대상-회원 수정 시 사용합니다. 해당 셀의 선택 유무를 나타냅니다.
    var isSelected: Bool

    /// - parameter selectedTargetMember: 기존에 선택된 대상입니다.
    init?(
        group: GroupListQuery.Data.SwsGroupsConnection.Edge.Node?,
        selectedTargetMember: SelectedTargetMember? = nil
    ) {
        guard let group = group else { return nil }
        
        self.idx = group.groupIdx
        self.name = group.name
        self.groupName = nil
        self.profileImageURL = group.profileImageUrl
        self.recipientType = .group
        self.stopIdx = group.stopIdx
        self.isSelected = ((group.groupIdx == selectedTargetMember?.idx) && (selectedTargetMember?.type == .group))
    }

    init?(
        user: UserListQuery.Data.SwsUsersConnection.Edge.Node?,
        selectedTargetMember: SelectedTargetMember? = nil
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
        
        // 유저가 따로 설정한 워크스페이스 프로필 이미지가 있다면 그 이미지를 표출합니다.
        // 없다면 전체 설정의 이미지를 표출합니다.
        // 전체 설정 프로필 이미지가 없다면 nil 을 전달합니다.
        self.profileImageURL = swsInfo.profileImageUrl ?? (user.profileImageUrl)
        
        self.recipientType = .user
        
        if let personalDefaultStopIdx = swsInfo.stopIdx {
            // 유저가 따로 설정한 기본위치가 있다면 해당 위치를 기본위치로 합니다.
            self.stopIdx = personalDefaultStopIdx
        } else if let groupDefaultStopIdx = swsInfo.groupStop?.asStop?.stopIdx {
            // 그렇지 않다면 유저가 속한 그룹들 중 유효한 기본 위치를 가진 그룹의 기본위치를 기본위치로 합니다.
            self.stopIdx = groupDefaultStopIdx
        } else {
            self.stopIdx = nil
        }
        
        self.isSelected = ((user.userIdx == selectedTargetMember?.idx) && (selectedTargetMember?.type == .user))
    }
}
