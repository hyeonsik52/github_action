//
//  Version.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

/// 버전 정보
struct Version {

    /// 최소 빌드
    let minimumBuildNumber: Int
    /// 현재 빌드
    let currentBuildNumber: Int
    /// 현재 버전
    let currentVersion: String
}

extension Version: FragmentModel {

    init(_ fragment: VersionFragment) {

        self.minimumBuildNumber = fragment.minVersionCode ?? 1
        self.currentBuildNumber = fragment.currentVersionCode ?? 1
        self.currentVersion = fragment.currentVersionName ?? "0.0.1"
    }
    
    init(option fragment: VersionFragment?) {
        
        self.minimumBuildNumber = fragment?.minVersionCode ?? 1
        self.currentBuildNumber = fragment?.currentVersionCode ?? 1
        self.currentVersion = fragment?.currentVersionName ?? "0.0.1"
    }
}

extension Version {
    
    static var thisAppVersion: Self {
        let currentBuildNumber = Int(Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String)!
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        return .init(
            minimumBuildNumber: 1,
            currentBuildNumber: currentBuildNumber,
            currentVersion: currentVersion
        )
    }
    
    var isLatest: Bool {
        return (Self.thisAppVersion.currentBuildNumber >= self.currentBuildNumber)
    }
}
