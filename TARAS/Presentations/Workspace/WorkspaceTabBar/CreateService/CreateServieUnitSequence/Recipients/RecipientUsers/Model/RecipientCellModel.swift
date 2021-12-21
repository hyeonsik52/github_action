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
    
    var ID: String
    var id: String?
    var name: String?
    var isSelected: Bool
    
    init?(user: MemberFragment, isSelected: Bool = false) {
        
        self.ID = user.id
        self.id = user.username
        self.name = user.displayName
        self.isSelected = isSelected
    }
}
