//
//  STParser.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

typealias JSON = [String: Any]

struct STParser {
    
    private func parse<Convertible: DefaultStringConvertible>(
        arg: ServiceArgumentType,
        type: Convertible.Type
    ) -> STNode {
        
        let required = arg.required
        let needToSet = arg.needToSet
        let inputType = arg.generalizedInputType.name
        let displayName = arg.displayText
        let uiComponentType = arg.uiComponentType
        let uiComponentDefaultValue = Convertible(string: arg.uiComponentDefaultValue)
        let from = STASource(rawValue: arg.model)
        let subArguments = self.parse(arg.generalizedInputType.generalizedChildArguments)
        
        return STArgument(
            name: arg.name,
            required: required,
            needToSet: needToSet,
            inputType: inputType,
            dispalyText: displayName,
            ui: STAUIComponent<Convertible>(
                type: uiComponentType,
                defaultValue: uiComponentDefaultValue
            ),
            from: from,
            subArguments: subArguments
        )
    }
    
    private func parseType<Convertible: DefaultStringConvertible>(
        arg: ServiceArgumentType,
        type: Convertible.Type
    ) -> STNode {
        if arg.arrayOf {
            return self.parse(arg: arg, type: [Convertible].self)
        } else {
            return self.parse(arg: arg, type: Convertible.self)
        }
    }
    
    func parse(_ args: [ServiceArgumentType]?) -> [STNode]? {
        guard let arguments = args, arguments.count > 0 else { return nil }
        return arguments.map {
            switch $0.generalizedInputType.name {
            case "Boolean":
                return self.parseType(arg: $0, type: Bool.self)
            case "Integer":
                return self.parseType(arg: $0, type: Int.self)
            case "Float":
                return self.parseType(arg: $0, type: Float.self)
            case "String":
                return self.parseType(arg: $0, type: String.self)
            case "JSON":
                return self.parseType(arg: $0, type: JSON.self)
            case "Receiver":
                return self.parseType(arg: $0, type: ConvertibleReceiver.self)
            case "Destination":
                return self.parseType(arg: $0, type: ConvertibleDestination.self)
            case "LoadingDestination":
                return self.parseType(arg: $0, type: ConvertibleLoadingDestination.self)
            default:
                return self.parseType(arg: $0, type: ConvertibleUnknown.self)
            }
        }
    }
}
