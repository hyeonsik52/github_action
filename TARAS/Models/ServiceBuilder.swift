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
}
