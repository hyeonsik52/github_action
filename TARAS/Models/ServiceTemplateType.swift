//
//  ServiceTemplateType.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/31.
//

import Foundation

enum ServiceTemplateType {
    case general(ServiceType?)
    case shortcut
    
    var isGeneral: Bool {
        guard case .general = self else { return false }
        return true
    }
    
    var isShortcut: Bool {
        guard case .shortcut = self else { return false }
        return true
    }
}
