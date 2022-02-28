//
//  Stop.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/09.
//

import Foundation

enum StopType {
    case normal
    case loading
    
    var isLoading: Bool {
        return (self == .loading)
    }
}

struct Stop: Identifiable {
    
    ///정차지 아이디
    let id: String
    ///정차지 이름
    let name: String
    ///정차지 유형
    let stopType: StopType
}

extension Stop: FragmentModel {

    init(_ fragment: StopFragment) {

        self.id = fragment.id
        self.name = fragment.name
        
        if let data = fragment.remark.asString?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
           let type = json["type"] as? String,
            type.lowercased() == "loading" {
            self.stopType = .loading
        } else {
            self.stopType = .normal
        }
    }
    
    init(option fragment: StopFragment?) {
        
        self.id = fragment?.id ?? Self.unknownId
        self.name = fragment?.name ?? "알 수 없는 위치"
        
        if let data = fragment?.remark.asString?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
           let type = json["type"] as? String,
            type.lowercased() == "loading" {
            self.stopType = .loading
        } else {
            self.stopType = .normal
        }
    }
}

extension Stop {

    init(option fragment: StopRawFragment?) {

        self.id = fragment?.id ?? Self.unknownId
        self.name = fragment?.name ?? "알 수 없는 위치"
        
        if let data = fragment?.remark.toString?.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
           let type = json["type"] as? String,
            type.lowercased() == "loading" {
            self.stopType = .loading
        } else {
            self.stopType = .normal
        }
    }
}

extension Stop: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
        hasher.combine(self.stopType)
    }
}
