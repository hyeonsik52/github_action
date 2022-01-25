//
//  String.swift
//  ServiceRobotPlatform-iOS
//
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension String {
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var isTrue: Bool {
        switch self {
        case "0":
            return false
            
        case "1":
            return true
        
        default:
            return false
        }
    }
}


extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension String {
    
    func koreanCompare(_ compare: String) -> Bool {
        // 기본 localizedCaseInsensitiveCompare는 숫자, 영문(대소무시), 한글 순 정렬
        // 한글 > 영문(대소구분 없음) > 숫자 > $
        // 그외 특수문자는 전부 무시한채 인덱싱
        // $는 예외

        // self 가 @"ㄱ" 보다 작고 (한글이 아니고) , comp 가 @"ㄱ"보다 같거나 클때 - 무조건 크다
        // 비교하면 -1 0 1 이 작다, 같다, 크다 순이므로 +1 을 하면 한글일때 YES 아니면 NO 가 된다.
        // self 가 한글이고 comp 가 한글이 아닐때 무조건 작다인 조건과
        // self 가 글자(한/영)이 아니고 comp가 글자(한/영)일떄 무조건 크다인 조건을 반영한다.
        
        let left = (self.localizedCaseInsensitiveCompare("ㄱ").rawValue+1 > 0 ? "0": !(self.localizedCaseInsensitiveCompare("a").rawValue+1 > 0) ? "2": "1") + self
        let right = (compare.localizedCaseInsensitiveCompare("ㄱ").rawValue+1 > 0 ? "0": !(compare.localizedCaseInsensitiveCompare("a").rawValue+1 > 0) ? "2": "1") + compare
        return (left.localizedCaseInsensitiveCompare(right) == .orderedAscending)
    }
    
    static func koreanCompare(lhs: String, rhs: String) -> Bool {
        return lhs.koreanCompare(rhs)
    }
}

extension Array where Element == String {
    
    func koreanSorted() -> Array {
        return self.sorted(by: String.koreanCompare)
    }
    
    mutating func koreanSort() {
        self.sort(by: String.koreanCompare)
    }
}

extension String {
    
    func toDate(_ format: String? = nil) -> Date? {
        if let format = format {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
            dateFormatter.dateFormat = format
            return dateFormatter.date(from: self)
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: self)
        }
    }
}

extension String {
    
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [NSRange] {
        var results = [NSRange]()
        var ranges = [Range<Index>]()
        while let range = range(of: substring, options: options, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
            ranges.append(range)
            let location = distance(from: startIndex, to: range.lowerBound)
            let length = distance(from: range.lowerBound, to: range.upperBound)
            results.append(NSMakeRange(location, length))
        }
        return results
    }
}
