//
//  Workspace.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 워크스페이스 정보
struct Workspace: Identifiable {
    
    ///워크스페이스 아이디
    let id: String
    ///워크스페이스 이름
    let name: String
    ///워크스페이스 생성일
    let createdAt: Date
    ///워크스페이스 회원 수
    let memberCount: Int
    
    ///가입 조건으로 이메일 필수 여부
    let isRequiredUserEmailToJoin: Bool?
    ///가입 조건으로 전화번호 필수 여부
    let isRequiredUserPhoneNumberToJoin: Bool?
    
    ///워크스페이스에서의 내 회원 상태
    var myMemberState: WorkspaceMemberState
    
    ///워크스페이스 코드
    let code: String
}

extension Workspace: FragmentModel {
    
    init(_ fragment: WorkspaceFragment) {

        self.id = fragment.id
        self.name = fragment.name
        self.createdAt = fragment.createdAt?.toDate() ?? Date()
        self.memberCount = fragment.members?.totalCount ?? 0
        
        self.myMemberState = .member
        
        self.isRequiredUserEmailToJoin = nil
        self.isRequiredUserPhoneNumberToJoin = nil
        
        self.code = fragment.code ?? ""
    }

    init(only fragment: OnlyWorkspaceFragment) {

        self.id = fragment.id
        self.name = fragment.name
        self.createdAt = fragment.createdAt
        self.memberCount = fragment.totalMemberCount ?? 0
        
        if let role = fragment.role {
            switch role {
            case .awaitingToJoin:
                self.myMemberState = .requestingToJoin
            case .member, .manager, .administrator:
                self.myMemberState = .member
            default:
                self.myMemberState = .notMember
            }
        } else {
            self.myMemberState = .notMember
        }
        
        self.isRequiredUserEmailToJoin = fragment.isRequiredUserEmailToJoin
        self.isRequiredUserPhoneNumberToJoin = fragment.isRequiredUserPhoneNumberToJoin
        
        self.code = fragment.code ?? ""
    }
    
    init(option fragment: WorkspaceFragment?) {
        
        self.id = fragment?.id ?? Self.unknownId
        self.name = fragment?.name ?? "알 수 없는 워크스페이스"
        
        self.createdAt = fragment?.createdAt?.toDate() ?? Date()
        self.memberCount = fragment?.members?.totalCount ?? 0
        
        self.myMemberState = .member
        
        self.isRequiredUserEmailToJoin = nil
        self.isRequiredUserPhoneNumberToJoin = nil
        
        self.code = fragment?.code ?? ""
    }
}
