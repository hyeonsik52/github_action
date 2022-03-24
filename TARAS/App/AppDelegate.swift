//
//  AppDelegate.swift
//  TARAS
//
//  Created by nexmond on 2021/07/30.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseCore
import FirebaseMessaging

import RxSwift
import RxReachability

import Reachability
import CocoaLumberjack

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let provider = ManagerProvider()
    let disposeBag = DisposeBag()
    var reachability = try? Reachability()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Log
        self.setupCocoaLumberjack()
        
        // Realm
        RealmManager.shared.openRealm()
        
        // Basics
        self.setupWindow()
        self.setupNavigationBar()
        self.setupTabBar()
        
        // FCM Related
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.regiserForRemoteNotifications(application)
        
        // RxSwift Resource count
        #if DEBUG
        _ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                print("Resource count \(RxSwift.Resources.total)")
            })
        #endif
        
        // 네트워크 상태를 구독합니다.
        if let reachability = self.reachability {
            reachability.rx.isReachable.skip(1).map { $0 ?
                ("네트워크에 연결되었습니다.", UIColor.networkGreen6DD400):
                ("네트워크 연결이 유실되었습니다.", UIColor.networkRedFE4242)
            }.subscribe(onNext: { $0.0.sek.showTopNote(color: $0.1) })
            .disposed(by: self.disposeBag)
            
            reachability.rx.reachabilityChanged.skip(1)
                .subscribe(onNext: { [weak self] reachability in
                    Log.info("Updated reachability: \(reachability.description)")
                    self?.provider.networkManager.updateWebSocketTransportConnectingPayload()
                }).disposed(by: self.disposeBag)

            try? reachability.startNotifier()
        }
        
        if #available(iOS 13, *) {} else {
            self.applicationWillEnterForeground(application)
        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.checkUpdate()
    }
}

extension AppDelegate {
    
    func checkUpdate() {
        
        self.provider.networkManager.clientVersion.updateCheck()
            .filterNil()
            .flatMapLatest { error -> Observable<Int> in
                let errorUserInfo = (error as NSError).userInfo
                let title = errorUserInfo[NSLocalizedFailureErrorKey] as? String
                let message = errorUserInfo[NSLocalizedDescriptionKey] as? String
                if let title = title {
                    let actionTitle = (errorUserInfo[NSLocalizedRecoverySuggestionErrorKey] as? String) ?? "확인"
                    let exitTitle = "앱 종료"
                    return UIAlertController.show(
                        .alert,
                        title: title,
                        message: message,
                        items: [
                            UIAlertController.AlertAction(title: exitTitle, style: .destructive),
                            UIAlertController.AlertAction(title: actionTitle, style: .default)
                        ],
                        usingCancel: false
                    ).map(\.0)
                } else {
                    Log.error(message ?? "error message empty")
                    return .just(-1)
                }
            }.subscribe(onNext: { index in
                if index == 0 {
                    exit(0)
                } else {
                    //앱 설치 페이지로 이동
                }
            }).disposed(by: self.disposeBag)
    }
}


// MARK: - Basic Settings

extension AppDelegate {
    
    /// iOS 버전에 따른 window 설정
    func setupWindow() {
        if #available(iOS 13, *) {
            Log.debug("Operated in iOS 13")
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            let reactor = LaunchScreenViewReactor(provider: self.provider)
            let viewController = LaunchScreenViewController()
            viewController.reactor = reactor
            window.rootViewController = viewController
            window.backgroundColor = .white
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    /// Naviagation Bar 설정
    func setupNavigationBar() {
        
        let titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.black0F0F0F, .font: UIFont.bold[20]]
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 6
        let largeTitleTextAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.black0F0F0F,
            .font: UIFont.bold[24],
            .paragraphStyle: style
        ]
        
        if #available(iOS 13, *) {
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithTransparentBackground()
            coloredAppearance.backgroundColor = .clear
            coloredAppearance.shadowColor = UIColor.clear
            coloredAppearance.titleTextAttributes = titleTextAttributes
            coloredAppearance.largeTitleTextAttributes = largeTitleTextAttributes
            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().compactAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        } else {
            UINavigationBar.appearance().barTintColor = .clear
            UINavigationBar.appearance().isTranslucent = true
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
            UINavigationBar.appearance().largeTitleTextAttributes = largeTitleTextAttributes
        }
        
        UINavigationBar.appearance().tintColor = .black0F0F0F
        UINavigationBar.appearance().prefersLargeTitles = true
    }
    
    func setupTabBar() {
        
        if #available(iOS 15, *) {
            let opaqueAppearance = UITabBarAppearance()
            opaqueAppearance.configureWithOpaqueBackground()
            opaqueAppearance.backgroundColor = .white
            opaqueAppearance.shadowColor = .clear
            UITabBar.appearance().standardAppearance = opaqueAppearance
            UITabBar.appearance().scrollEdgeAppearance = opaqueAppearance
        }
        
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false
    }
}


// MARK: UISceneSession Lifecycle

extension AppDelegate {
    
    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


// MARK: - CocoaLumberjack

extension AppDelegate {
    
    /// CocoaLumberjack 설정
    func setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}


// MARK: - FCM

extension AppDelegate: UNUserNotificationCenterDelegate {

    func regiserForRemoteNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // 1. registerForRemoteNotifications() 호출
        // 2. Apple Push Notification 서비스 등록 프로세스 시작
        // 3. 등록 성공 시 application(_:didRegisterForRemoteNotificationsWithDeviceToken:) 호출, device token 전달
        // 4. 이 토큰을 서버에 전달
        application.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo["gcm.message_id"] {
            Log.info("Message ID: \(messageID)")
        }
        
        if let infoDic = userInfo as? [String: Any] {
            let info = NotificationInfo(infoDic)
            self.provider.pushManager.setupTabBarController(info)
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.error("Error registration APNS token: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // APN 등록 성공 후 전달받은 deviceToken을 Firebase 서버로 전달
        Messaging.messaging().apnsToken = deviceToken
        
        let current = PushTokenSet(apns: deviceToken, fcm: Messaging.messaging().fcmToken)
        self.provider.networkManager.fcm.register(with: current, #function)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let current = PushTokenSet(apns: messaging.apnsToken, fcm: fcmToken)
        self.provider.networkManager.fcm.register(with: current, #function)
    }
}
