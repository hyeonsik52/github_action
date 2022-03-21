//
//  STUI.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

protocol STUI {}

extension STUI {
    
    func asComponent<T>() -> STAUIComponent<T>? {
        return self as? STAUIComponent<T>
    }
    
    func defaultValue<T: DefaultStringConvertible>() -> T {
        let argument: STAUIComponent<T>? = self.asComponent()
        return argument?.defaultValue ?? .defaultValue
    }
}
