//
//  ServiceTemplate.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/29.
//

import Foundation

/// 서비스 템플릿
struct ServiceTemplate: Identifiable {
    /// 서비스 템플릿 아이디
    let id: String
    /// 서비스 템플릿 이름
    let name: String
    /// 서비스 템플릿 유형
    let type: ServiceTemplateType
    /// 서비스 템플릿 설명
    let description: String?
    /// 간편생성 여부
    let isCompiled: Bool
    
    /// 템플릿을 통한 서비스 생성 보조
    let serviceBuilder: ServiceBuilder
}

extension ServiceTemplate: FragmentModel {
    
    init(_ fragment: ServiceTemplateRawFragmnet) {
        
        self.id = fragment.id
        self.name = fragment.name
        if fragment.isCompiled {
            self.type = .shortcut
        } else {
            self.type = .general(.init(rawValue: fragment.serviceType))
        }
        self.description = fragment.description
        self.isCompiled = fragment.isCompiled
        
        let arguments = fragment.arguments.map(\.fragments.serviceArgumentRawFragment)
        self.serviceBuilder = .init(arguments)
    }
    
    init(option fragment: ServiceTemplateRawFragmnet?) {
        
        self.id = fragment?.id ?? Self.unknownId
        self.name = fragment?.name ?? Self.unknownName
        if fragment?.isCompiled == true {
            self.type = .shortcut
        } else {
            self.type = .general(.init(rawValue: fragment?.serviceType ?? ""))
        }
        self.description = fragment?.description
        self.isCompiled = fragment?.isCompiled ?? false
        
        let arguments = fragment?.arguments.map(\.fragments.serviceArgumentRawFragment) ?? []
        self.serviceBuilder = .init(arguments)
    }
}
