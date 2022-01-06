//
//  STAUIComponent.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

struct STAUIComponent<T>: STUI {
    let type: String
    let defaultValue: T?
    let placeholder: String?
}
