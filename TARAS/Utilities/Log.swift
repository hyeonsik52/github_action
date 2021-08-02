//
//  Log.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/04/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import CocoaLumberjack

final class Log {
    
    private class func message(flag: String, items: [Any], separator: String) -> String {
        return "\(flag): " + items.reduce("", { $0.isEmpty ? "\($1)": "\($0)\(separator)\($1)" })
    }
    
    class func info(_ items: Any..., separator: String = " ") {
        let message = self.message(flag: "ℹ️ INFO", items: items, separator: separator)
        DDLogInfo(message)
    }
    
    class func debug(_ items: Any..., separator: String = " ") {
        let message = self.message(flag: "⚠️ DEBUG", items: items, separator: separator)
        DDLogDebug(message)
    }
    
    class func warning(_ items: Any..., separator: String = " ") {
        let message = self.message(flag: "❗️ WARNING", items: items, separator: separator)
        DDLogWarn(message)
    }
    
    class func error(_ items: Any..., separator: String = " ") {
        let message = self.message(flag: "🚨 ERROR", items: items, separator: separator)
        DDLogError(message)
    }
    
    class func request(_ items: Any..., separator: String = " ") {
        let message = self.message(flag: "🙋🏻 REQUEST", items: items, separator: separator)
        DDLogDebug(message)
    }
    
    class func complete(_ items: Any..., separator: String = " ") {
        let message = self.message(flag: "🙆🏻 COMPLETE", items: items, separator: separator)
        DDLogDebug(message)
    }
    
    class func fail(_ items: Any..., separator: String = " ") {
        let message = self.message(flag: "🙅🏻 FAIL", items: items, separator: separator)
        DDLogDebug(message)
    }
}
