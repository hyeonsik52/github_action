//
//  WorkspaceMemberState.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

/// 워크스페이스 가입 유형
enum WorkspaceMemberState {
    
    /// 회원 아님
    case notMember
    /// 회원
    case member
    /// 회원가입 요청 심사 중
    case requestingToJoin
}
