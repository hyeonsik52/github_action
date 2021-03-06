//
//  SwiftEntryKit.swift
//  Dev-ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol SwiftEntryKitExtension {
    
    var entryName: String? { get }
    
    /// *주의 : 반드시 display 직전에 올바른 entryName을 지정해야 함
    func show(with attributes: EKAttributes)
    
    func dismiss(_ completion: (() -> Void)?)
    static func dismiss(_ completion: (() -> Void)?)
}

extension SwiftEntryKitExtension {
    
    func dismiss(_ completion: (() -> Void)? = nil) {
        if let entryName = self.entryName {
            SwiftEntryKit.dismiss(.specific(entryName: entryName), with: completion)
        }else{
            Self.dismiss(completion)
        }
    }
    
    static func dismiss(_ completion: (() -> Void)? = nil) {
        SwiftEntryKit.dismiss(.displayed, with: completion)
    }
}
