//
//  MockUserManager.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import Foundation
@testable import TARAS_Dev

class MockUserManager: BaseManager, UserManagerType {
    
    private let clientInfo = "0.0.1/iPhone10,6/ios/15.3.1/ko"
    
    private let accessToken = "PU0h7ZcjYsi9pWWNSfg3ootjaNmtpR"
    private let refreshToken = "B4WsUV1xmENiDG3G6niV1M8BA80VjC"
    private lazy var _userTB = USER_TB().then {
        $0.accessToken = self.accessToken
        $0.refreshToken = self.refreshToken
    }
    
    var isReAuthenticating = false
    
    var userTB: USER_TB {
        return self._userTB
    }
    
    var hasTokens: Bool {
        return (self.userTB.accessToken != nil && self.userTB.refreshToken != nil)
    }
    
    func reAuthenticate(_ accessToken: String, _ completion: @escaping (ErrorResult) -> Void) {
        
        guard !self.isReAuthenticating,
              accessToken == self.userTB.accessToken else {
            completion(.success)
            return
        }
        
        self.isReAuthenticating = true
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
            completion(.success)
            self.isReAuthenticating = false
        }
    }
    
    func updateClientInfo() {
        self.userTB.clientInfo = self.clientInfo
    }
    
    func updateTokens(access: String, refresh: String) {
        self.userTB.accessToken = access
        self.userTB.refreshToken = refresh
    }
    
    func updateUserInfo(_ user: UserFragment) {
        self.userTB.ID = user.id
        self.userTB.id = user.username
        self.userTB.name = user.displayName
        self.userTB.email = user.email
        self.userTB.phoneNumber = user.phoneNumber
    }
    
    func initializeUserTB() {
        self.userTB.id = nil
        self.userTB.ID = nil
        self.userTB.name = nil
        self.userTB.email = nil
        self.userTB.phoneNumber = nil
        self.userTB.lastWorkspaceId = nil
        self.userTB.accessToken = nil
        self.userTB.refreshToken = nil
    }
    
    func initializeLastWorkspaceId(_ workspaceId: String) {
        if let lastWorkspaceId = self.userTB.lastWorkspaceId,
           lastWorkspaceId == workspaceId {
            self.userTB.lastWorkspaceId = nil
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
    
    func authPayload() -> [String : String] {
        return ["Authorization": "Bearer \(self.userTB.accessToken ?? "")"]
    }
}
