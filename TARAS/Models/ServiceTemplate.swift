//
//  ServiceTemplate.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/29.
//

import Foundation

enum ServiceTemplateType {
    case general(ServiceType?)
    case shortcut
    
    init(string: String) {
        if string.isEmpty {
            self = .shortcut
        } else {
            self = .general(.init(rawValue: string))
        }
    }
    
    var isGeneral: Bool {
        guard case .general = self else { return false }
        return true
    }
    
    var isShortcut: Bool {
        guard case .shortcut = self else { return false }
        return true
    }
}

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
    /// 인수 정보
    let arguments: [String: Any]
    /// arguments에서 사용되는 인수 유형
    let types: [String: Any]
    /// 간편생성 여부
    let isCompiled: Bool
}

extension ServiceTemplate: FragmentModel {
    
    init(_ fragment: ServiceTemplateFragment) {
        self.id = fragment.id
        self.name = fragment.name
        self.type = .init(string: fragment.serviceType)
        self.description = fragment.description
        self.arguments = fragment.arguments?.toDictionary ?? [:]
        self.types = fragment.types?.toDictionary ?? [:]
        self.isCompiled = fragment.isCompiled
    }
    
    init(option fragment: ServiceTemplateFragment?) {
        self.id = fragment?.id ?? Self.unknownId
        self.name = fragment?.name ?? Self.unknownName
        self.type = .general(nil)
        self.description = fragment?.description
        self.arguments = fragment?.arguments?.toDictionary ?? [:]
        self.types = fragment?.types?.toDictionary ?? [:]
        self.isCompiled = fragment?.isCompiled ?? false
    }
}
