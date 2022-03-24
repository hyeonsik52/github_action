//
//  MockManagerProvider.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import Foundation
@testable import TARAS_Dev

final class MockManagerProvider: ManagerProviderType {
    lazy var userManager: UserManagerType = MockUserManager(provider: self)
    lazy var pushManager: PushManagerType = MockPushManager(provider: self)
    lazy var networkManager: NetworkManagerType = MockNetworkManager(provider: self)
    lazy var subscriptionManager: SubscriptionManagerType = MockSubscriptionManager(provider: self)
    lazy var notificationManager: NotificationManagerType = MockNotificationManager(provider: self)
}
