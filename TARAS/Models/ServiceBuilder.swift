//
//  ServiceBuilder.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

struct ServiceBuilder {
    
    private let arguments: [ServiceArgumentType]
    private let parser = STParser()
    
    init(_ arguments: [ServiceArgumentType]) {
        self.arguments = arguments
    }
    
    func parse() -> [STNode]? {
        return self.parser.parse(self.arguments)
    }
    
    func generateServiceTemplateInputJsonValue(
        with serviceUnits: [ServiceUnitCreationModel],
        repeatCount: Int? = nil
    ) -> [String: Any] {
        var args = [String: Any]()
        self.parse()?.forEach { arg in
            let field = arg.key
            if arg.asArgument?.needToSet == true {
                args[field] = {
                    switch field {
//                    case "robot_key":
//                        return ""
                    case "destinations":
                        return serviceUnits.map { $0.toJSON(node: arg) }
                    case "repeat_count":
                        if let repeatCount = repeatCount {
                            return repeatCount
                        }
                    default: break
                    }
                    return ""
                }()
            } else {
                Log.debug("Field '\(field)' is ignored as no setting is needed.")
            }
        }
        return args
    }
}
