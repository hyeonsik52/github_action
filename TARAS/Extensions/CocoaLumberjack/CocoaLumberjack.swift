//
//  CocoaLumberjack.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/02/03.
//

import CocoaLumberjack

extension DDLog {
    
    static func logger<T: DDLogger>(_ loggerType: T.Type) -> T? {
        return self.allLoggers.first { type(of: $0) == loggerType } as? T
    }
}
