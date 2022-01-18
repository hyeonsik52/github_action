//
//  ServiceBuilder.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

struct ServiceBuilder {
    
    private let template: ServiceTemplate
    private let parser = STParser()
    
    init(_ template: ServiceTemplate) {
        self.template = template
    }
    
    func parse() -> [STNode] {
        return self.parser.parse(
            args: self.template.arguments,
            types: self.template.types
        )
    }
    
    func generateServiceTemplateInputJsonValue(
        with serviceUnits: [ServiceUnitCreationModel],
        repeatCount: Int? = nil
    ) -> [String: Any] {
        
        var args = [String: Any]()
        
        self.parse().forEach { arg in
            let key = arg.key
            args[key] = {
                switch key {
                case "destinations":
                    if let scheme = arg.asArgument {
                        return serviceUnits.map { $0.toJSON(scheme: scheme) }
                    }
                case "repeat_count":
                    if let repeatCount = repeatCount {
                        return repeatCount
                    }
                default: break
                }
                return ""
            }()
        }
        
        return [
            "arguments": args
        ]
    }
}
