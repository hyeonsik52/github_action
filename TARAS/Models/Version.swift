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
        return .init(
            minimumBuildNumber: 1,
            currentBuildNumber: Int(Info.appBuild) ?? 1,
            currentVersion: Info.appVersion
        )
    }
    
    var isLatest: Bool {
        return (Self.thisAppVersion.currentBuildNumber >= self.currentBuildNumber)
    }
    
    var mustUpdate: Bool {
        return (Self.thisAppVersion.currentBuildNumber < self.minimumBuildNumber)
    }
}
