//
//  MockPushManager.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import Foundation
@testable import TARAS_Dev

class MockPushManager: BaseManager, PushManagerType {
    
    var checkInfo: NotificationInfo?
    
    var window: UIWindow? = .init(frame: .zero)
    
    func setupTabBarController(_ info: NotificationInfo) {
        self.checkInfo = info
    }
}
