//
//  InputPolicy.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 입력 정책 컨테이너
struct InputPolicy {
    
    /// 길이 정책
    let range: ClosedRange<Int>
    /// 양식 정책
    let format: String
}

extension InputPolicy {
    
    var min: Int {
        return self.range.lowerBound
    }
    
    var max: Int {
        return self.range.upperBound
    }
}

extension InputPolicy {
    
    func matchFormat(_ string: String) -> Bool {
        return string.matches(self.format)
    }
    
    func matchRange(_ string: String) -> Bool {
        return (self.range ~= string.count)
    }
    
    func orMoreThanMin(_ string: String) -> Bool {
        return (string.count >= self.min)
    }
    
    func orMoreThanMax(_ string: String) -> Bool {
        return (string.count >= self.max)
    }
    
    func moreThanMax(_ string: String) -> Bool {
        return (string.count > self.max)
    }
    
    func match(_ string: String) -> Bool {
        return (self.matchFormat(string) && self.matchRange(string))
    }
}

extension InputPolicy {
    
    /// 아이디
    /// 4~20자 (영어 소문자 / 영어 소문자&숫자 조합)
    static let id = InputPolicy(range: 4...20, format: "^(?=[a-z])+[0-9a-z]*$")

    /// 비밀번호
    /// 10~32자 (영어 대문자, 소문자, 숫자, 특수문자 중 2종류 이상 조합)
    static let password: InputPolicy = {
        
        //숫자 셋
        let n = "0-9"
        //소문자 셋
        let l = "a-z"
        //대문자 셋
        let u = "A-Z"
        //허용된 특수문자 셋
        let s = "!\"#$%&\'()*+,-./:;<=>?@\\[＼\\]^_`{|}~\\\\"
        //허용된 문자 셋
        let c = "\(n)\(l)\(u)\(s)"
        
        //숫자로 시작하고 뒤로 소문자, 대문자, 특수문자가 오는 경우
        let nf = "((?=[\(n)]+)[\(n)]+[\(l)\(u)\(s)]+[\(c)]*)"
        //소문자로 시작하고 뒤로 숫자, 대문자, 특수문자가 오는 경우
        let lf = "((?=[\(l)]+)[\(l)]+[\(n)\(u)\(s)]+[\(c)]*)"
        //대문자로 시작하고 뒤로 숫자, 소문자, 특수문자가 오는 경우
        let uf = "((?=[\(u)]+)[\(u)]+[\(n)\(l)\(s)]+[\(c)]*)"
        //특수문자로 시작하고 뒤로 숫자, 소문자, 대문자가 오는 경우
        let sf = "((?=[\(s)]+)[\(s)]+[\(n)\(l)\(u)]+[\(c)]*)"
        
        return .init(range: 10...32, format: "^\(nf)|\(lf)|\(uf)|\(sf)$")
    }()
    
    /// 이름
    /// 1~20자의 모든 문자 (공백 포함)
    static let name = InputPolicy(range: 1...20, format: "^.+$")
    
    /// 이메일
    /// 6~128자의 xxx@yyy.zzz 형태. x, y, z 각 x, y 1자 이상 z 2자 이상
    static let email = InputPolicy(range: 6...128, format: "^[0-9a-zA-Z-_.]+@[0-9a-zA-Z-_]+([.][a-zA-Z]{2,})+$")
    
    /// 전화번호
    /// 1~21자의 숫자만
    static let phoneNumber = InputPolicy(range: 1...21, format: "^[0-9]+$")
    
    /// 인증번호
    /// 6자의 숫자만
    static let authNumber = InputPolicy(range: 6...6, format: "^[0-9]+$")
    
    /// 워크스페이스 코드
    /// 5~20자의 모든 문자
    static let workspaceCode = InputPolicy(range: 5...20, format: "^.+$")
    
    /// 주문 요청사항
    /// 1~200자의 모든 문자
    static let requestMessage = InputPolicy(range: 1...200, format: "^.+$")
    
    /// 최소 1자 이상
    static let min1 = InputPolicy(range: 1...Int.max, format: "^.+$")
}
