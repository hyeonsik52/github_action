//
//  KeyboardExtension.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/25.
//

import Foundation

protocol KeyboardExtension {
    
    var isKeyboardHideWhenTouch: Bool { get }
}

extension UIScrollView: KeyboardExtension {
    
    @objc var isKeyboardHideWhenTouch: Bool {
        return true
    }
}
