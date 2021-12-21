//
//  UserManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo
import RxCocoa
import RxSwift
import RealmSwift

protocol UserManagerType: AnyObject {
    
    var userTB: USER_TB { get }
    var hasTokens: Bool { get }
    func reAuthenticate(_ accessToken: String, _ completion: @escaping(Error?) -> Void)
    func updateClientInfo()
    func updateTokens(access: String, refresh: String)
    func updateUserInfo(_ user: UserFragment)
    func initializeUserTB()
    func initializeLastWorkspaceId(_ workspaceId: String)
    func account() -> Account
    func authPayload() -> [String: String]
}

class UserManager: BaseManager, UserManagerType {
    
    private var isReAuthenticating = false
    
    private let disposeBag = DisposeBag()

    /// userTB 는 DB상 하나만 존재합니다. (index == 0)
    var userTB: USER_TB {
        // DB에 userTB가 있을 경우: 기존 userTB를 반환
        if let userTB = USER_TB.getFirst(property: "index", value: 0) {
            return userTB
        } else {
            // DB에 userTB가 없을 경우: 새 userTB를 DB에 저장한 후 반환
            let newUserTB = USER_TB(index: 0)
            RealmManager.shared.realmWrite { realm -> Bool in
                realm.add(newUserTB)
                return true
            }
            return newUserTB
        }
    }

    var hasTokens: Bool {
        guard let _ = self.userTB.accessToken,
              let _ = self.userTB.refreshToken else {
            return false
        }
        return true
    }
}


// MARK: - Token

extension UserManager {

    /// access token 갱신
    func reAuthenticate(_ accessToken: String, _ completion: @escaping(Error?) -> Void) {
    
//        guard let clientInfo = self.userTB.clientInfo,
//              let refreshToken = self.userTB.refreshToken else { return }
//
//        let input = RefreshSessionInput(
//            clientInfo: clientInfo,
//            clientType: "ios",
//            refreshToken: refreshToken
//        )
//
//        // 2. 서버의 토큰이 만료된 상태(하지만 클라에서는 호출이 이루어지지 않아 만료 상태를 모르는 상태)에서 2개 이상의
//        // 호출이 일어날 경우 동시에 재인증 과정이 진행될 수 있기 때문에,
//        // isReAuthenticating 플래그로 인증 중에 진입하는 경우 재시도하도록 한다.
//        guard !self.isReAuthenticating,
//            // 3. 재인증 완료된 후, 이전의 호출이 이전 토큰을 가지고 시도할 수 있기 때문에,
//            // 호출의 토큰과 현재 토큰이 같은 때만 통과시킨다
//            accessToken == self.provider.userManager.userTB.accessToken else {
//                completion(nil)
//                return
//        }
//
//        self.isReAuthenticating = true
//
//        self.provider.networkManager
//            .perform(RefreshSessionMutation(input: input))
//            .map { $0.refreshSessionMutation }
//            .subscribe(onNext: { [weak self] data in
//                guard let self = self else { return }
//
//                if let error = data.asRefreshSessionError {
//                    if error.errorCode == .invalidRefreshToken {
//                        let error = NSError(domain: "", code: 401, userInfo: nil)
//                        completion(error)
//                    }
//                }
//
//                if let payload = data.asLoginPayload {
//                    self.updateTokens(access: payload.accessToken, refresh: payload.refreshToken)
//                    self.provider.networkManager.updateWebSocketTransportConnectingPayload()
//
//                    // 1. completion(nil)은 재호출 하는 기능이기 때문에, 성공한 경우에만 사용해야 함.
//                    completion(nil)
//                }
//                self.isReAuthenticating = false
//            }, onError: { [weak self] error in
//                completion(error)
//                self?.isReAuthenticating = false
//            }).disposed(by: self.disposeBag)
    
        //TODO: 재로그인 처리?
        //현재는 갱신 방법이 없어서 무조건 실패
        
        let error = NSError(domain: "", code: 401, userInfo: nil)
        completion(error)
    }
}

extension UserManager {

    /// userTB 의 clientInfo (앱버전/장치명/OS/OS버전/언어) 업데이트
    func updateClientInfo() {
        let appVersion = Info.appVersion
        let deviceName = UIDevice.current.modelName
        let osName = "ios"
        let osVersion = UIDevice.current.systemVersion
        let deviceLanguage = Locale.current.languageCode ?? "ko"
        let clientInfo = "\(appVersion)/\(deviceName)/\(osName)/\(osVersion)/\(deviceLanguage)"
        
        self.userTB.update {
            $0.clientInfo ??= clientInfo
        }
    }

    func updateTokens(access: String, refresh: String) {
        self.userTB.update {
            $0.accessToken ??= access
            $0.refreshToken ??= refresh
        }
    }

    func updateUserInfo(_ user: UserFragment) {

        self.userTB.update {
            $0.ID ??= user.id
            $0.id ??= user.username
            $0.name ??= user.displayName
            $0.email ??= user.email
            $0.phoneNumber ??= user.phoneNumber
        }
    }
    
    func initializeUserTB() {
        userTB.update {
            $0.id = nil
            $0.ID = nil
            $0.name = nil
            $0.email = nil
            $0.phoneNumber = nil
            $0.lastWorkspaceId = nil
            $0.accessToken = nil
            $0.refreshToken = nil
        }
    }
    
    func initializeLastWorkspaceId(_ workspaceId: String) {
        if let lastWorkspaceId = self.userTB.lastWorkspaceId,
           lastWorkspaceId == workspaceId {
            self.provider.userManager.userTB.update {
                $0.lastWorkspaceId = nil
            }
        }
    }
    
    func account() -> Account {
        let info = self.userTB
        return Account(
            ID: info.ID,
            id: info.id,
            name: info.name,
            email: info.email,
            phoneNumber: info.phoneNumber
        )
    }
    
    func authPayload() -> [String: String] {
        return ["Authorization": "Bearer \(self.userTB.accessToken ?? "")"]
    }
}
