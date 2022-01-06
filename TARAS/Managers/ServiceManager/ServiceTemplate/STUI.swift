//
//  STUI.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

protocol STUI {}

extension STUI {
    func asComponent<T>(_ type: T.Type) -> STAUIComponent<T>? {
        return self as? STAUIComponent<T>
    }
}
