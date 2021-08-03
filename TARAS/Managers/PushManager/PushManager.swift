//
//  PushManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/24.
//

import UIKit

protocol PushManagerType: AnyObject {
    var window: UIWindow? { get }
    func setupTabBarController(_ info: NotificationInfo)
}

final class PushManager: BaseManager, PushManagerType {
    
    var window: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }

    func setupTabBarController(_ info: NotificationInfo) {
        DispatchQueue.main.async {
            if let _ = self.window {
                switch info.notificationType {
                case .created, .arrived:
                    self.setupWorkspaceListViewController(pushInfo: info)
                }
            }
        }
    }
    
    enum TabType: Int {
        case serviceRequest
        case myService
        case more
    }
    
    fileprivate func setupWorkspaceListViewController(pushInfo: NotificationInfo) {
        
//        let isLogin = (self.provider.userManager.userTB.accessToken != nil)
//
//        let viewController: UIViewController = {
//            if isLogin {
//                return WorkspaceListViewController().then {
//                    $0.reactor = WorkspaceListViewReactor(provider: self.provider, isFrom: .push, pushInfo: pushInfo)
//                }
//            }else{
//                return SignInViewController().then {
//                    $0.reactor = SignInViewReactor(provider: self.provider)
//                }
//            }
//        }()
//
//        let navigationController = BaseNavigationController(rootViewController: viewController)
//        self.window?.rootViewController = navigationController
    }
}

