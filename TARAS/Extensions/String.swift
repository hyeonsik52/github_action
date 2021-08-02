//
//  String.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/19.
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
    
    // 전화번호를 문자열로만 처리함
//    /// API 호출 하실 때, 모든 전화번호는 국제 번호 형식 (82~) 으로 전송해 주셔야 합니다.
//    /// 슬랙 'srp_0-플랫폼본부' [전화번호 형식 공지](https://twinny.slack.com/archives/GSV3EBWBY/p1596724402141900) 참고
//    var nationalizePhoneNumber: String {
//        if self[0..<2] == "82" {
//            return self
//        } else if self[0] == "0" {
//            return "82" + self.substring(fromIndex: 1)
//        } else {
//            return "82" + self
//        }
//    }
//
//    var denationalizePhoneNumber: String? {
//        guard self.count > 2 else { return nil }
//        if self[0..<2] == "82" {
//            return "0" + self.substring(fromIndex: 2)
//        } else {
//            return self
//        }
//    }
}
