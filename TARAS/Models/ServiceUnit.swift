//
//  ServiceUnit.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

///// 단위서비스 정보
struct ServiceUnit: Identifiable {
    
    ///단위서비스 아이디
    let id: String
    ///단위서비스 상태
    let state: String?
    ///단위서비스 작업 위치
    let stop: Stop
    
    ///수신자(작업자)들
    let recipients: [User]
    
    ///요청사항
    let detail: String?
    
    ///서비스 내의 진행 순서
    ///(빈 목적지가 존재할 수 있으므로 0부터 시작하지 않을 수 있음)
    let orderWithinService: Int
    
    ///현재 진행중인지 여부
    var isInProgress: Bool = false
    
    ///로봇 도착 시간
    var robotArrivalTime: Date?
    
    ///인증번호
    let authNumber: String?
}

extension ServiceUnit: FragmentModel {

    init(_ fragment: ServiceUnitFragment) {

        self.id = fragment.id
        self.state = fragment.state
        
        self.stop = .init(option: fragment.stop?.fragments.stopFragment)
        self.recipients = fragment.receivers?.compactMap(\.?.fragments.userFragment).map(User.init) ?? []
        
        self.detail = fragment.message

        self.orderWithinService = fragment.index
        
        //서비스 로그에서 해당 정보 탐색 후 입력
        self.robotArrivalTime = nil
        
        //temp
        self.authNumber = nil
    }
    
    init(option fragment: ServiceUnitFragment?) {
        
        self.id = fragment?.id ?? Self.unknownId
        self.state = fragment?.state ?? Self.unknownName
        
        self.stop = .init(option: fragment?.stop?.fragments.stopFragment)
        self.recipients = fragment?.receivers?.compactMap(\.?.fragments.userFragment).map(User.init) ?? []
        
        self.detail = fragment?.message

        self.orderWithinService = fragment?.index ?? 0
        
        //서비스 로그에서 해당 정보 탐색 후 입력
        self.robotArrivalTime = nil
        
        //temp
        self.authNumber = nil
    }
}

extension ServiceUnit {

    init(_ fragment: ServiceUnitRawFragment) {

        self.id = fragment.id
        self.state = nil
        
        self.stop = .init(option: fragment.stop?.fragments.stopRawFragment)
        //warn: 내 작업 여부 판단, 정차지 작업자 표시를 위한 데이터만 포함되어 있으므로, subscription을 통해 업데이트 된 수신자 정보 사용에 주의하시기 바랍니다.
        self.recipients = fragment.receivers?.map {
            return .init(
                id: $0.id,
                username: User.unknownId,
                displayName: $0.displayName,
                email: nil,
                phonenumber: nil
            )
        } ?? []
        
        self.detail = fragment.message

        self.orderWithinService = fragment.index
        
        //서비스 로그에서 해당 정보 탐색 후 입력
        self.robotArrivalTime = nil
        
        //temp
        self.authNumber = nil
    }
}

extension ServiceUnit {
    
    ///내 작업 여부
    func isMyWork(_ id: String?) -> Bool {
        return self.recipients.contains { $0.id == id }
    }
}

extension ServiceUnit: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.state)
        hasher.combine(self.stop)
        hasher.combine(self.recipients)
        hasher.combine(self.detail)
        hasher.combine(self.orderWithinService)
        hasher.combine(self.robotArrivalTime)
        hasher.combine(self.authNumber)
    }
}
