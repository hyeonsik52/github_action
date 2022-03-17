//
//  STArgument.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

struct STArgument {
    
    let name: String
    
    let required: Bool
    let needToSet: Bool
    let inputType: String
    let displayText: String
    
    let ui: STUI
    let from: STASource?
    
    let subArguments: [STNode]?
    
    init(
        name: String,
        required: Bool,
        needToSet: Bool,
        inputType: String,
        dispalyText: String,
        ui: STUI,
        from: STASource? = nil,
        subArguments: [STNode]? = nil
    ) {
        self.name = name
        
        self.required = required
        self.needToSet = needToSet
        self.inputType = inputType
        self.displayText = dispalyText
        
        self.ui = ui
        self.from = from
        
        self.subArguments = subArguments
    }
    
}

extension STArgument: STNode {
    
    var key: String {
        return self.name
    }
    
    var subNodes: [STNode]? {
        return self.subArguments
    }
}
