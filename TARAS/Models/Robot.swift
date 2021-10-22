//
//  Robot.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 로봇 정보
struct Robot {
    
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
}
