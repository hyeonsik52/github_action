//
//  STProcess.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

class STProcess {
    
    private let template: ServiceTemplate
    private let args: STNode
    private var keys = [String]()
    
    init(template: ServiceTemplate) {
        self.template = template
        self.args = STArgument(
            key: "arguments",
            required: false,
            inputType: "user_defined",
            dispalyText: "",
            ui: STAUIComponent<JSON>(
                type: "[]JSON",
                defaultValue: nil,
                placeholder: nil
            ),
            from: nil,
            subArguments: template.serviceBuilder.parse()
        )
    }
    
    ///셀렉터에 해당하는 값을 반환한다. 유효한 셀렉터가 아닌 경우 경고를 남긴다.
    func value(selector: String, _ func: String = #function) -> STNode? {
        let keys = selector.components(separatedBy: ".")
        let value = self.value(keys: keys)
        if value == nil {
            let path = keys.joined(separator: ".")
            Log.debug(`func`, "'\(path)' 경로에서 값을 찾을 수 없습니다.")
        }
        return value
    }
    
    private func value(keys: [String]) -> STNode? {
        var availabledResult: STNode?
        var result: STNode? = self.args
        var validKeys = [String]()
        keys.forEach {
            result = result?[$0]
            if let json = result as? JSON, let value = json[$0] {
                result = value as? STNode
            }
            if let availabled = result {
                validKeys.append($0)
                availabledResult = availabled
            }
        }
        if result == nil {
            let availableKeys = availabledResult?.subNodes?.map(\.key).joined(separator: ", ") ?? ""
            let availableKeysMessage = "유효한 값\(availableKeys.isEmpty ? "이 없습니다.": "을 얻으려면 [\(availableKeys)] 중 하나를 사용하십시오.")"
            let validPath = validKeys.joined(separator: ".")
            let validPathMessage = "유효한 경로\(validKeys.isEmpty ? "가 아닙니다.": "는 \(validPath)이며,")"
            Log.debug("\(validPathMessage) \(availableKeysMessage)")
        }
        return result
    }
    
    ///현재 셀렉터에 키를 추가하여 해당하는 값을 반환한다. 값이 없으면 키가 추가되지 않는다.
    @discardableResult
    func appendKey(_ key: String, _ func: String = #function) -> STNode? {
        guard let value = self.peek(with: key) else {
            Log.debug(`func`, "키가 유효하지 않습니다.")
            return nil
        }
        self.keys.append(key)
        return value
    }
    
    ///현재 셀렉터에 키를 더한 셀랙터에 해당하는 값을 반환한다.
    func peek(with key: String? = nil, _ func: String = #function) -> STNode? {
        var keys = self.keys
        if let key = key {
            keys.append(key)
        }
        let value = self.value(keys: keys)
        if value == nil {
            let path = keys.joined(separator: ".")
            Log.debug(`func`, "'\(path)'에서 값을 찾을 수 없습니다.")
        }
        return value
    }
    
    ///쌓인 키들을 초기화한다.
    @discardableResult
    func clearKey(_ func: String = #function) -> Self {
        Log.debug(`func`, "키를 초기화합니다. [\(self.keys.joined(separator: "."))] -> []")
        self.keys.removeAll()
        return self
    }
}
