//
//  ManagerProvider.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

protocol ManagerProviderType: AnyObject {
    var userManager: UserManagerType { get }
    var pushManager: PushManagerType { get }
    var networkManager: NetworkManagerType { get }
    var serviceManager: ServiceManagerType { get }
    var subscriptionManager: SubscriptionManagerType { get }
}

final class ManagerProvider: ManagerProviderType {
    lazy var userManager: UserManagerType = UserManager(provider: self)
    lazy var pushManager: PushManagerType = PushManager(provider: self)
    lazy var networkManager: NetworkManagerType = NetworkManager(provider: self)
    lazy var serviceManager: ServiceManagerType = ServiceManager(provider: self)
    lazy var subscriptionManager: SubscriptionManagerType = SubscriptionManager(provider: self)
}
