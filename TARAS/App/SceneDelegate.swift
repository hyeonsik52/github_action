//
//  SceneDelegate.swift
//  TARAS
//
//  Created by nexmond on 2021/07/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let reactor = LaunchScreenViewReactor(provider: appDelegate.provider)
        let viewController = LaunchScreenViewController()
        viewController.reactor = reactor
        
        window?.rootViewController = viewController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        if let response = connectionOptions.notificationResponse {
            let userInfo = response.notification.request.content.userInfo

            if let infoString = userInfo["gcm.notification.information"] as? String,
                let infoData = infoString.data(using: .utf8),
                let infoDic = try? JSONSerialization.jsonObject(with: infoData, options: []) as? [String: AnyHashable],
                let info = NotificationInfo(infoDic)
            {
                appDelegate.provider.pushManager.setupTabBarController(info)
            }
        }
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        (UIApplication.shared.delegate as? AppDelegate)?.checkUpdate()
    }
}
