//
//  STArgument.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

struct STArgument: STNode {
    
    let key: String
    
    let required: Bool
    let inputType: String
    let displayText: String
    
    let ui: STUI
    let from: STASource?
    
    let subArguments: [STNode]?
    
    init(
        key: String,
        required: Bool,
        inputType: String,
        dispalyText: String,
        ui: STUI,
        from: STASource? = nil,
        subArguments: [STNode]? = nil
    ) {
        self.key = key
        self.required = required
        self.inputType = inputType
        self.displayText = dispalyText
        
        self.ui = ui
        self.from = from
        
        self.subArguments = subArguments
    }
    
    var subNodes: [STNode]? {
        return self.subArguments
    }
}
