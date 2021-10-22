//
//  VersionCheck.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/10/22.
//

import Foundation

struct VersionCheck: Codable {
    
    enum CodingKeys: String, CodingKey {
        case currentVersionCode
        case currentVersionName
        case minVersionCode
    }
    
    let currentVersionCode: Int
    let currentVersionName: String
    let minVersionCode: Int
}
