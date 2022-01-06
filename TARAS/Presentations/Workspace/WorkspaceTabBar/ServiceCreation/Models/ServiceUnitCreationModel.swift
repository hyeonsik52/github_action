//
//  ServiceUnitCreationModel.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import Foundation

struct ServiceUnitCreationModel: Identifiable {
    
    //immutable
    let id: String = UUID().uuidString
    
    //required
    var stop: ServiceUnitTargetModel! = nil
    var receiver: ServiceUnitTargetModel! = nil
    
    //optional
    var attachmentId: String? = nil
    var detail: String? = nil
}

extension ServiceUnitCreationModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.stop)
        hasher.combine(self.receiver)
        hasher.combine(self.attachmentId)
        hasher.combine(self.detail)
    }
}
