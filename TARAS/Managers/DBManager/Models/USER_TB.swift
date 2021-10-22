//
//  USER_TB.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import RealmSwift

class USER_TB: BaseObject {
    
    /// 유저 아이디
    @objc dynamic var id: String? = nil
    
    /// 아이디
    @objc dynamic var ID: String? = nil
    
    /// 이름
    @objc dynamic var name: String? = nil
    
    /// 이메일
    @objc dynamic var email: String? = nil
    
    /// 전화번호
    @objc dynamic var phoneNumber: String? = nil
    
    /// accessToken
    @objc dynamic var accessToken: String? = nil
    
    /// refreshToken
    @objc dynamic var refreshToken: String? = nil
    
    /// 앱버전/장치명/OS/OS버전/언어
    @objc dynamic var clientInfo: String? = nil
    
    /// 마지막으로 접속한 워크스페이스의 유니크 아이디
    @objc dynamic var lastWorkspaceId: String? = nil
    
    /// 최초 로그인 시, workspaceListVC 에 진입했을 때 workspaceSearchVC 프레젠트 여부를 결정하는 플래그
    @objc dynamic var isInitialOpen: Bool = true
}


// MARK: - BaseObjectAutoIncrementProtocol

extension USER_TB: BaseObjectAutoIncrementProtocol {
    
    static var lastIndex: Int = NSNotFound
}
