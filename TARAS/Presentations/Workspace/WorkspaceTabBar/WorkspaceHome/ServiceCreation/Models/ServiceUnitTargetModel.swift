//
//  ServiceUnitTargetModel.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import Foundation

struct ServiceUnitTargetModel: Identifiable {
    
    var id: String
    var name: String
    
    var selectedAt: Date? = nil
    
    var isSelected: Bool {
        set {
            self.selectedAt = (newValue ? Date(): nil)
        }
        get {
            return (self.selectedAt != nil)
        }
    }
    
    //TODO: 개선 필요
    var isLoadingStop: Bool = false
}

extension ServiceUnitTargetModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
        hasher.combine(self.selectedAt)
    }
}

extension ServiceUnitTargetModel: ServiceTemplateSerialization {
    
    func toJSON(scheme: STArgument) -> [String : Any] {
        var args = [String: Any]()
        scheme.subArguments?.forEach { arg in
            let key = arg.key
            if arg.asArgument?.required == true {
                args[key] = {
                    switch key {
                    case "ID": return self.id
                    default: return ""
                    }
                }()
            }
        }
        return args
    }
}

extension ServiceUnitTargetModel: TRSTag {
    
    var string: String { self.name }
}
