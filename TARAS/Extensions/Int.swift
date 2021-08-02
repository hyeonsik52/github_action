//
//  Int.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension Int {
    
    static var max32: Int {
        return Int(Int32.max)
    }
    
    func fillZero(_ count: Int) -> String {
        let desc = self.description
        guard desc.count < count else { return desc }
        let paddingCount = count - desc.count
        let paddingZero = (0..<paddingCount).map{_ in "0"}.reduce("", +)
        return paddingZero+desc
    }
    
    ///3자리 마다 ',' 표시
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber)!
    }
}


