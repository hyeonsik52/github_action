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
    //작업대기 여부 (nil은 사용하지 않음을 의미)
    var isWorkWaiting: Bool? = nil
    //상/하차 여부 (nil은 사용하지 않음을 의미)
    var isLoadingStop: Bool? = nil
    
    //optional
    var receivers: [ServiceUnitTargetModel] = []
    var detail: String? = nil
}

extension ServiceUnitCreationModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.stop)
        hasher.combine(self.isWorkWaiting)
        hasher.combine(self.isLoadingStop)
        hasher.combine(self.receivers)
        hasher.combine(self.detail)
    }
}

extension ServiceUnitCreationModel {
    
    mutating func updateStopState(with process: STProcess) {
        
        //템플릿에서 서비스 타입이 로딩인지 확인
        if process.isServiceTypeLS {
            let isNotLoading = process.peek(with: "loading_command")?.asArgument?.ui.asComponent(String.self)?.defaultValue == "UNLOAD"
            if self.stop.isLoadingStop {
                //로딩이고 정차지가 LS이면 상/하차 표시
                self.isLoadingStop = !isNotLoading
            } else {
                //로딩이고 정차지가 일반이면 표시하지 앟음
                self.isLoadingStop = nil
            }
        }
        
        //작업대기 표시
        if let isWaitArgs = process.peek(with: "is_waited")?.asArgument {
            let isWait = isWaitArgs.ui.asComponent(Bool.self)?.defaultValue ?? false
            self.isWorkWaiting = isWait
        } else {
            self.isWorkWaiting = nil
        }
    }
}

protocol ServiceTemplateSerialization {
    
    func toJSON(scheme: STArgument) -> [String: Any]
}

extension ServiceUnitCreationModel: ServiceTemplateSerialization {
    
    func toJSON(scheme: STArgument) -> [String : Any] {
        var args = [String: Any]()
        scheme.subArguments?.forEach { arg in
            let key = arg.key
            if arg.asArgument?.required == true {
                args[key] = {
                    switch key {
                    case "ID": return self.stop.id
                    case "name": return self.stop.name
                    case "message": return self.detail ?? ""
                    case "loading_command": return (self.isLoadingStop ?? true) ? "LOAD": "UNLOAD"
                    case "is_waited": return self.isWorkWaiting ?? true
                    case "receivers":
                        guard let receiverScheme = scheme.subArguments?
                                .first(where: { $0.key == "receivers" })?
                                .asArgument else { return "" }
                        return self.receivers.map { $0.toJSON(scheme: receiverScheme) }
                    default: return ""
                    }
                }()
            }
        }
        return args
    }
}
