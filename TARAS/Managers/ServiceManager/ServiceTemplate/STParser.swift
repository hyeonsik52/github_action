//
//  STParser.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

typealias JSON = [String: Any]

struct STParser {
    
    private func extract<T>(_ json: JSON, key: String, type: T.Type) -> T? {
        guard let value = json[key] as? T else { return nil }
        return value
    }
    
    private func parse<T>(key: String, value: Any, types: JSON, type: T.Type) -> STNode? {
        if let json = value as? JSON {
            
            let required = self.extract(json, key: "required", type: Bool.self) ?? false
            let inputType = self.extract(json, key: "input_type", type: String.self) ?? ""
            let displayName = self.extract(json, key: "display_text", type: String.self) ?? ""
            let uiComponentType = self.extract(json, key: "ui_component_type", type: String.self) ?? ""
            let uiComponentDefaultValue = self.extract(json, key: "ui_component_default_value", type: T.self)
            let uiComponentPlaceholder = self.extract(json, key: "ui_component_placeholder", type: String.self)
            let from = STASource(rawValue: self.extract(json, key: "from", type: String.self) ?? "")
            
            var subArguments: [STNode]?
            let type = inputType.replacingOccurrences(of: "[]", with: "")
            if let typeArg = types[type] as? JSON {
                subArguments = self.parse(args: typeArg, types: types)
            }
            
            return STArgument(
                key: key,
                required: required,
                inputType: inputType,
                dispalyText: displayName,
                ui: STAUIComponent<T>(
                    type: uiComponentType,
                    defaultValue: uiComponentDefaultValue,
                    placeholder: uiComponentPlaceholder
                ),
                from: from,
                subArguments: subArguments
            )
        } else {
            return [key: value]
        }
    }
    
    func parse(args: JSON, types: JSON) -> [STNode] {
        return args.compactMap {
            let key = $0.key
            let value = $0.value
            
            guard let json = value as? JSON else {
                return self.parse(key: key, value: value, types: types, type: Any.self)
            }
            
            let inputType = self.extract(json, key: "input_type", type: String.self) ?? ""
            
            switch inputType {
            case "int":
                return self.parse(key: key, value: json, types: types, type: Int.self)
            case "bool":
                return self.parse(key: key, value: json, types: types, type: Bool.self)
            case "string":
                return self.parse(key: key, value: json, types: types, type: String.self)
            case "JSON":
                return self.parse(key: key, value: json, types: types, type: JSON.self)
            default:
                if inputType.contains("[]") {
                    return self.parse(key: key, value: json, types: types, type: [Any].self)
                } else {
                    return self.parse(key: key, value: json, types: types, type: Any.self)
                }
            }
        }
    }
}
