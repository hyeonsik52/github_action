//
//  ServiceUnitModelSet.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/10/21.
//

import Foundation

struct ServiceUnitModelSet {
    
    ///서비스
    var service: Service
    ///단위서비스
    var serviceUnit: ServiceUnit
    ///서비스에서 단위서비스 순서
    var serviceUnitOffset: Int
    
    init(
        service: Service,
        serviceUnit: ServiceUnit,
        offset: Int? = nil
    ) {
        self.service = service
        self.serviceUnit = serviceUnit
        
        let findedIndex = service.serviceUnits.firstIndex { $0.id == serviceUnit.id }
        self.serviceUnitOffset = offset ?? findedIndex ?? -1
    }
}
