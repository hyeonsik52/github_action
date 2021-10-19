//
//  ServiceUnit.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

///// 단위서비스 정보
struct ServiceUnit {
    
    ///단위서비스 아이디
    let id: String
    ///단위서비스 상태
    let state: String?
    ///단위서비스 작업 위치
    let stop: Stop = .init(id: "-1", name: "알 수 없는 위치")
    
    ///수신자 목록
    let receivers: [User]
    ///요청사항
    let detail: String?
    
    ///서비스 내의 진행 순서 <- 외부에서 지정
    var orderWithinService: Int
}

extension ServiceUnit: FragmentModel {
    
    init(_ fragment: ServiceUnitFragment) {
        
        self.id = fragment.id
        self.state = fragment.state
        
        if let stopFragment = fragment.stop?.fragments.stopFragment {
            self.stop = .init(stopFragment)
        }
        
        //TODO
        self.receivers = []
        self.detail = nil
    }
}
