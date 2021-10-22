//
//  UIApplication+Info.swift
//  AppCenter
//
//  Created by nexmond on 2021/05/26.
//

import UIKit

extension UIApplication {
    
    static var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
