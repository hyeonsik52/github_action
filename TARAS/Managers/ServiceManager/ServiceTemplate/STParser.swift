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
        return STArgument(
            name: arg.name,
            required: arg.required,
            needToSet: arg.needToSet,
            inputType: arg.generalizedInputType.name,
            dispalyText: arg.displayText,
            ui: STAUIComponent(
                type: arg.uiComponentType,
                defaultValue: Convertible(string: arg.uiComponentDefaultValue)
            ),
            from: .init(rawValue: arg.model),
            subArguments: self.parse(arg.generalizedInputType.generalizedChildArguments)
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
//            case "Receiver":
//                return self.parseType(arg: $0, type: ConvertibleReceiver.self)
//            case "Destination":
//                return self.parseType(arg: $0, type: ConvertibleDestination.self)
//            case "LoadingDestination":
//                return self.parseType(arg: $0, type: ConvertibleLoadingDestination.self)
            default:
                return self.parseType(arg: $0, type: ConvertibleDefault.self)
            }
        }
    }
}
