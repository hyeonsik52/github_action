//
//  ServiceUnit.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

//import Foundation
//
///// 단위서비스 정보
//struct ServiceUnit {
//    /// 단위서비스 인덱스
//    let idx: Int
//    /// 단위서비스 상태
//    let status: ServiceUnitStatus
//    /// 요청 일자
//    let requestAt: Date
//    /// 정차지
//    let stop: Stop
//    /// 작업자 정보
//    let worker: Worker
//    /// 요청 사항
//    let requestContent: String?
//}
//
//extension ServiceUnit {
//
//    init?(result: ServiceUnitFragment, with provider: UserManagerType) {
//        let dateFormatter = ISO8601DateFormatter()
//        guard let createAt = dateFormatter.date(from: result.createAt) else {
//            return nil
//        }
//
//        self.idx = result.serviceUnitIdx
//        self.status = result.status
//
//        self.requestAt = createAt
//
//        let stop = Stop(result: result.stop?.asStop?.fragments.stopFragment)
//        self.stop = stop ?? .init(idx: -1, name: "알 수 없는 위치")
//        let recipient = result.recipients.first?.asServiceUnitRecipientUser?.user.asUser?.fragments.userFragment
//        self.worker = Worker(result: recipient, with: provider) ?? Worker(idx: -1, name: "알 수 없는 사용자", isMe: false)
//        self.requestContent = result.message
//    }
//}
