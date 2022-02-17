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
                case .received:
                    self.setupWorkspaceTabBarController(pushInfo: info)
                }
            }
        }
    }
    
    fileprivate func setupWorkspaceListViewController() -> UINavigationController {
        let listReactor = WorkspaceListViewReactor(provider: self.provider, isFrom: .push)
        let listViewController = WorkspaceListViewController()
        listViewController.reactor = listReactor
        let navigationController = UINavigationController(rootViewController: listViewController)
        self.window?.rootViewController = navigationController
        return navigationController
    }
    
    fileprivate func setupWorkspaceTabBarController(pushInfo: NotificationInfo) {
        
        let workspaceListViewController = self.setupWorkspaceListViewController()
        
        
        guard let workspaceId = pushInfo.workspaceId else { return }
        
        // 탭바
        let tabBarController = WorkspaceTabBarController()
        tabBarController.reactor = .init(
            provider: self.provider,
            workspaceId: workspaceId,
            pushInfo: pushInfo
        )
        workspaceListViewController.pushViewController(tabBarController, animated: false)
        
        
        guard let serviceId = pushInfo.serviceId else { return }
        
        // 서비스 상세보기
        tabBarController.selectedIndex = 1
        
        let detailViewReactor = ServiceDetailViewReactor(
            provider: self.provider,
            workspaceId: workspaceId,
            serviceId: serviceId
        )
        tabBarController.selectedViewController?.navigationPush(
            type: ServiceDetailViewController.self,
            reactor: detailViewReactor,
            animated: false,
            bottomBarHidden: true
        )
    }
}

