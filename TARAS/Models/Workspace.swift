//
//  Workspace.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

//import Foundation
//
///// 워크스페이스 정보
//struct Workspace {
//    /// 워크스페이스 인덱스
//    let idx: Int
//    /// 워크스페이스 코드
//    let code: String
//    /// 워크스페이스 이름
//    let name: String
//    /// 대표 사진
//    let image: String?
//    /// 생성일자
//    let createAt: Date
//    /// 사용자의 가입 상태
//    let myMemberStatus: WorkspaceMemberStatus
//    /// 가입 신청중인 요청 인덱스
//    let joinRequestIdx: Int?
//}
//
///// 워크스페이스 가입 유형
//enum WorkspaceMemberStatus {
//    /// 회원 아님
//    case notMember
//    /// 회원
//    case member
//    /// 회원가입 요청 심사 중
//    case requestingToJoin
//}
//
//extension WorkspaceMemberStatus {
//    
//    init(raw: SWSMemberStatus) {
//        switch raw {
//        case .member:
//            self = .member
//        case .requestingToJoin:
//            self = .requestingToJoin
//        default:
//            self = .notMember
//        }
//    }
//}
//
//extension Workspace {
//    
//    init(result: WorkspaceFragment) {
//        
//        self.idx = result.swsIdx
//        self.code = result.code
//        self.name = result.name
//        self.image = result.profileImageUrl
//        
//        let dateFormatter = ISO8601DateFormatter()
//        self.createAt = dateFormatter.date(from: result.createAt) ?? Date()
//        
//        self.myMemberStatus = WorkspaceMemberStatus(raw: result.myMemberStatus)
//        
//        self.joinRequestIdx = result.myJoinRequest?.asSwsJoinRequest?.swsJoinRequestIdx
//    }
//}

struct Workspace: Identifiable {
    
    var id: String
    var name: String
    var code: String?
    var isAllowedToSearch: Bool
    var isRequiredToAcceptToJoin: Bool
    var isRequiredUserEmailToJoin: Bool
    var isRequiredUserPhoneNumberToJoin: Bool
    var members: [User]?
    var stationGroups: [StationGroup]
    var stations: [Station]
}

extension Workspace: FragmentModel {
    
    init(_ fragment: WorkspaceFragment) {
        
        self.id = fragment.id
        self.name = fragment.name
        self.code = fragment.code
        self.isAllowedToSearch = fragment.isAllowedToSearch
        self.isRequiredToAcceptToJoin = fragment.isRequiredToAcceptToJoin
        self.isRequiredUserEmailToJoin = fragment.isRequiredUserEmailToJoin
        self.isRequiredUserPhoneNumberToJoin = fragment.isRequiredUserPhoneNumberToJoin
        self.members = fragment.members.edges
            .compactMap(\.?.node?.fragments.userForWorkspaceFragment)
            .map(User.init)
        self.stationGroups = fragment.stationGroups?.edges
            .compactMap(\.?.node?.fragments.stationGroupFragment)
            .map(StationGroup.init) ?? []
        self.stations = fragment.stations?.edges
            .compactMap(\.?.node?.fragments.stationFragment)
            .map(Station.init) ?? []
    }
    
    init(alt fragment: WorkspaceForUserFragment) {
        
        self.id = fragment.id
        self.name = fragment.name
        self.code = fragment.code
        self.isAllowedToSearch = fragment.isAllowedToSearch
        self.isRequiredToAcceptToJoin = fragment.isRequiredToAcceptToJoin
        self.isRequiredUserEmailToJoin = fragment.isRequiredUserEmailToJoin
        self.isRequiredUserPhoneNumberToJoin = fragment.isRequiredUserPhoneNumberToJoin
        self.isAllowedToSearch = fragment.isAllowedToSearch
        self.stationGroups = fragment.stationGroups?.edges
            .compactMap(\.?.node?.fragments.stationGroupFragment)
            .map(StationGroup.init) ?? []
        self.stations = fragment.stations?.edges
            .compactMap(\.?.node?.fragments.stationFragment)
            .map(Station.init) ?? []
    }
}
