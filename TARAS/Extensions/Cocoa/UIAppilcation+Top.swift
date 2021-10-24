//
//  UIAppilcation+Top.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/10/24.
//

import Foundation

extension UIApplication {
    
    var currentWindow: UIWindow? {
        if #available(iOS 13, *) {
            return self.windows.first { $0.isKeyWindow }
        } else {
            return self.keyWindow
        }
    }
    
    var topViewController: UIViewController? {
        var top = self.currentWindow?.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
    
    static var currentWindow: UIWindow? {
        return self.shared.currentWindow
    }
    
    static var topViewController: UIViewController? {
        return self.shared.topViewController
    }
}
