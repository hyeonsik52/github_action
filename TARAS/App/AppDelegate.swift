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
import FirebaseFirestore

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
    
    struct TokenSet: Equatable {
        var apns: Data?
        var fcm: String?
    }
    private var registrationToken: TokenSet?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Log
        self.setupCocoaLumberjack()
        
        // Realm
        RealmManager.shared.openRealm()
        
        // Basics
        self.setupWindow()
        self.setupNavigationBar()
        
        // FCM Related
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.regiserForRemoteNotifications(application)
        
        let _ = Firestore.firestore()
        
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
        
        self.applicationWillEnterForeground(application)
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.checkUpdate()
    }
}

extension AppDelegate {
    
    func checkUpdate() {
        
        self.provider.networkManager.tempUpdateCheck()
            .filterNil()
            .flatMapLatest { error -> Observable<Int> in
                let errorUserInfo = (error as NSError).userInfo
                let title = errorUserInfo[NSLocalizedFailureErrorKey] as? String
                let message = errorUserInfo[NSLocalizedDescriptionKey] as? String
                if let title = title {
                    let actionTitle = (errorUserInfo[NSLocalizedRecoverySuggestionErrorKey] as? String) ?? "확인"
                    return UIAlertController.show(
                        .alert,
                        title: title,
                        message: message,
                        items: [actionTitle],
                        usingCancel: false
                    ).map(\.0)
                } else {
                    Log.error(message ?? "error message empty")
                    return .just(-1)
                }
            }.subscribe(onNext: { index in
                if index >= 0 {
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
        if #available(iOS 13, *) {
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithOpaqueBackground()
            coloredAppearance.backgroundColor = .white
            coloredAppearance.shadowColor = UIColor.clear
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black0F0F0F, .font: UIFont.bold[20]]
            
            // large title text left margin
            let style = NSMutableParagraphStyle()
            style.firstLineHeadIndent = 6
            coloredAppearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.black0F0F0F,
                .font: UIFont.bold[24],
                .paragraphStyle: style
            ]
            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().compactAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.white
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        
        UINavigationBar.appearance().tintColor = .black0F0F0F
        UINavigationBar.appearance().prefersLargeTitles = true
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
        
        if let infoString = userInfo["gcm.notification.information"] as? String,
            let infoData = infoString.data(using: .utf8),
            let infoDic = try? JSONSerialization.jsonObject(with: infoData, options: []) as? [String: AnyHashable],
            let info = NotificationInfo(infoDic)
        {
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
        
        let current = TokenSet(apns: deviceToken, fcm: Messaging.messaging().fcmToken)
        self.uploadFcmToken(with: current, #function)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let current = TokenSet(apns: messaging.apnsToken, fcm: fcmToken)
        self.uploadFcmToken(with: current, #function)
    }
    
    private func uploadFcmToken(with tokenSet: TokenSet, _ func: String) {
        // 토큰이 없는 경우 업로드에 실패하므로 무시함
        guard self.provider.userManager.hasTokens else {
            Log.info("Can't upload fcm token without authorization token. (from: \(`func`))")
            return
        }
        
        // 이전에 업로드 성공한 토큰이 다시 등록되는 경우 무시함
        let prevTokenSet = self.registrationToken
        guard tokenSet != self.registrationToken else {
            Log.info("Ignored already registered token set. (from: \(`func`))")
            return
        }
        self.registrationToken = tokenSet
        
        guard let token = tokenSet.fcm else { return }
        
        // 토큰이 사용 가능할 때 or 리프레시 됐을 때 메소드가 자동으로 호출 됨
        Log.info("Firebase registration token: \(token) [with \(String(describing: tokenSet.apns))] (from: \(`func`))")
        
        // 앱 서버에 FCM token 을 업로드
        if let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString {
//            let input = UpdateFcmRegistrationIdInput(
//                clientType: "ios",
//                deviceUniqueKey: deviceUniqueKey,
//                registrationId: token
//            )
//
//            Log.info("\(input)")
//
//            self.provider.networkManager
//                .perform(UpdateFcmTokenMutation(input: input))
//                .map { $0.updateFcmRegistrationIdMutation }
//                .subscribe(onNext: { [weak self] result in
//                    if let payload = result.asUpdateFcmRegistrationIdPayload {
//                        if payload.result.isTrue {
//                            Log.complete("updated FCM token to server")
//                        }
//                    }else if let error = result.asUpdateFcmRegistrationIdError {
//                        self?.registrationToken = prevTokenSet
//                        Log.error("failed to update FCM token to server: \(error.errorCode)")
//                    }
//                }, onError: { [weak self] error in
//                    self?.registrationToken = prevTokenSet
//                    Log.error("failed to update FCM token to server: \(error.localizedDescription)")
//                }).disposed(by: self.disposeBag)
        }else{
            self.registrationToken = prevTokenSet
            Log.error("failed to update FCM token to server: not found device unique id")
        }
    }
}
