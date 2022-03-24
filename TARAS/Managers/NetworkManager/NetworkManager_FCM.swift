//
//  NetworkManager_FCM.swift
//  TARAS
//
//  Created by nexmond on 2022/03/11.
//

import Foundation
import RxSwift
import FirebaseMessaging

protocol FCMSupport {
    func registerFcmToken(with tokenSet: PushTokenSet, _ func: String)
    func registerFcmToken(auto func: String)
    func registerFcmToken<T>(auto func: String) -> Observable<T>
    func unregisterFcmToken() -> Observable<Bool>
}

struct PushTokenSet: Equatable {
    var apns: Data?
    var fcm: String?
}

extension NetworkManager {
    
    static var registeredToken: PushTokenSet?
    static var fcmDisposeBag = DisposeBag()
    
    func registerFcmToken(with tokenSet: PushTokenSet, _ func: String) {
        // 토큰이 없는 경우 업로드에 실패하므로 무시함
        guard self.provider.userManager.hasTokens else {
            Log.info("Can't upload fcm token without authorization token. (from: \(`func`))")
            return
        }
        
        // 이전에 업로드 성공한 토큰이 다시 등록되는 경우 무시함
        let prevTokenSet = Self.registeredToken
        guard tokenSet != Self.registeredToken else {
            Log.info("Ignored already registered token set. (from: \(`func`))")
            return
        }
        Self.registeredToken = tokenSet
        
        guard let token = tokenSet.fcm else { return }
        
        // 토큰이 사용 가능할 때 or 리프레시 됐을 때 메소드가 자동으로 호출 됨
        Log.info("Firebase registration token: \(token) [with \(String(describing: tokenSet.apns))] (from: \(`func`))")
        
        // 앱 서버에 FCM token 을 업로드
        if let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString,
           let accessToken = self.provider.userManager.userTB.accessToken, accessToken.count > 0 {
            
            let mutation = RegisterFcmMutation(input: .init(
                clientType: "ios",
                deviceUniqueKey: deviceUniqueKey,
                fcmToken: token
            ))
            
            self.perform(mutation)
                .subscribe(onNext: { result in
                    if result.registerFcm == true {
                        Log.complete("updated FCM token to server")
                    } else {
                        Log.complete("Failed FCM token updated to server")
                    }
                }).disposed(by: Self.fcmDisposeBag)
        }else{
            Self.registeredToken = prevTokenSet
            Log.error("failed to update FCM token to server: not found device unique id")
        }
    }
    
    func registerFcmToken(auto func: String) {
        let tokenSet = PushTokenSet(apns: nil, fcm: Messaging.messaging().fcmToken)
        self.registerFcmToken(with: tokenSet, `func`)
    }
    
    func registerFcmToken<T>(auto func: String) -> Observable<T> {
        self.registerFcmToken(auto: `func`)
        return .empty()
    }
    
    func unregisterFcmToken() -> Observable<Bool> {
        guard let _ = self.provider.userManager.userTB.accessToken,
              let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString,
              let fcmToken = Messaging.messaging().fcmToken
        else {
            return .just(false)
        }
        
        let mutation = UnregisterFcmMutation(input: .init(
            clientType: "ios",
            deviceUniqueKey: deviceUniqueKey,
            fcmToken: fcmToken
        ))
        
        return self.perform(mutation).map { $0.unregisterFcm == true }
    }
}
