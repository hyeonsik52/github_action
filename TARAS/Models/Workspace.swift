//
//  Workspace.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 워크스페이스 가입 유형
enum WorkspaceMemberStatus {
    /// 회원 아님
    case notMember
    /// 회원
    case member
    /// 회원가입 요청 심사 중
    case requestingToJoin
}

/// 워크스페이스 정보
struct Workspace: Identifiable {
    
    ///워크스페이스 아이디
    let id: String
    ///워크스페이스 이름
    let name: String
    ///워크스페이스 생성일
    let createdAt: Date
    
    ///가입 승인 필요 여부
    let isRequiredToAcceptToJoin: Bool
    ///가입 조건으로 이메일 필수 여부
    let isRequiredUserEmailToJoin: Bool
    ///가입 조건으로 전화번호 필수 여부
    let isRequiredUserPhoneNumberToJoin: Bool
    
    ///내 회원 상태
    var myMemberStatus: WorkspaceMemberStatus
    
    let memberCount: Int
    let code: String?
}

extension Workspace: FragmentModel {
    
    init(_ fragment: WorkspaceFragment) {
        
        self.id = fragment.id
        self.name = fragment.name
        
        if let createdAt = fragment.createdAt,
           let date = ISO8601DateFormatter().date(from: createdAt) {
            self.createdAt = date
        } else {
            self.createdAt = Date()
        }
        
        self.isRequiredToAcceptToJoin = fragment.isRequiredToAcceptToJoin
        self.isRequiredUserEmailToJoin = fragment.isRequiredUserEmailToJoin
        self.isRequiredUserPhoneNumberToJoin = fragment.isRequiredUserPhoneNumberToJoin
        
        //외부에서 회원이 아님을 확인 후 재설정 필요
        self.myMemberStatus = .member
        
        let members = fragment.members?.edges.compactMap(\.?.node).filter { $0.role != .awaitingToJoin } ?? []
        self.memberCount = members.count
        self.code = fragment.code
    }
    
    init(only fragment: OnlyWorkspaceFragment) {
        
        self.id = fragment.id
        self.name = fragment.name
        
        if let date = ISO8601DateFormatter().date(from: fragment.createdAt) {
            self.createdAt = date
        } else {
            self.createdAt = Date()
        }
        
        self.isRequiredToAcceptToJoin = fragment.isRequiredToAcceptToJoin
        self.isRequiredUserEmailToJoin = fragment.isRequiredUserEmailToJoin
        self.isRequiredUserPhoneNumberToJoin = fragment.isRequiredUserPhoneNumberToJoin
        
        self.myMemberStatus = .requestingToJoin
        
        self.memberCount = fragment.totalMemberCount ?? 0
        self.code = fragment.code
    }
}
