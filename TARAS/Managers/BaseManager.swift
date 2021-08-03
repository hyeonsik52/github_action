//
//  BaseManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

class BaseManager {
    
    unowned let provider: ManagerProviderType
    
    init(provider: ManagerProviderType) {
        self.provider = provider
    }
}
