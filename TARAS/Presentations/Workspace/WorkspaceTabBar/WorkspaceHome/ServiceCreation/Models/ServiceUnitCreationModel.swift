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
            let isNotLoading = process.peek(with: "loading_command")?.asArgument?.ui.defaultValue() == "UNLOAD"
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
            self.isWorkWaiting = isWaitArgs.ui.defaultValue()
        } else {
            self.isWorkWaiting = nil
        }
    }
}

protocol ServiceTemplateSerialization {
    
    func toJSON(node: STNode) -> [String: Any]
    func fieldValue(field: String, node: STNode, parentNode: STNode) -> Any
}

extension ServiceTemplateSerialization {
    
    func toJSON(node: STNode) -> [String: Any] {
        var args = [String: Any]()
        node.subNodes?.forEach { arg in
            let field = arg.key
            if arg.asArgument?.needToSet == true {
                args[field] = self.fieldValue(field: field, node: arg, parentNode: node)
            } else {
                Log.debug("Field '\(field)' is ignored as no setting is needed.")
            }
        }
        return args
    }
}

extension ServiceUnitCreationModel: ServiceTemplateSerialization {
    
    func fieldValue(field: String, node: STNode, parentNode: STNode) -> Any {
        if let argument = node.asArgument {
            switch field {
            case "ID": return self.stop.id
            case "name": return self.stop.name
            case "message": return self.detail ?? argument.ui.defaultValue()
            case "loading_command": return (self.isLoadingStop ?? true) ? "LOAD": "UNLOAD"
            case "is_waited": return self.isWorkWaiting ?? argument.ui.defaultValue()
            case "receivers":
                guard let receiverArgs = parentNode.subNodes?.compactMap(\.asArgument)
                    .first(where: { $0.key == "receivers" }) else { return "" }
                return self.receivers.map { $0.toJSON(node: receiverArgs) }
            case "img_urls": return argument.ui.defaultValue() as [String]
            default: return ""
            }
        } else {
            return ""
        }
    }
}
