//
//  Robot.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 로봇 정보
struct Robot: Identifiable {
    
    /// 로봇 아이디
    let id: String
    /// 로봇 이름
    let name: String?
}

extension Robot: FragmentModel {

    init(_ fragment: RobotFragment) {

        self.id = fragment.id
        self.name = fragment.name
    }
    
    init(option fragment: RobotFragment?) {
        
        self.id = fragment?.id ?? Self.unknownId
        self.name = fragment?.name ?? "알 수 없는 로봇"
    }
}

extension Robot {

    init(_ fragment: RobotRawFragment) {

        self.id = fragment.key
        self.name = fragment.name
    }
}

extension Robot: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
    }
}
