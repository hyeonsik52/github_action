//
//  ServiceType.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

///서비스 타입
enum ServiceType: Int {
    
    ///카페 배송
    case cafe
    ///택배 배송
    case parcel
    ///일반 배송
    case general
    
    init(type: String) {
        switch type {
        case "CAFE":
            self = .cafe
        case "GENERAL":
            self = .general
        default:
            self = .parcel
        }
    }
    
    static let all: [Self] = [.cafe, .parcel, .general]
}

extension ServiceType {
    
    var description: String {
        switch self {
        case .cafe:
            return "카페"
        case .parcel:
            return "택배"
        case .general:
            return "일반"
        }
    }

    var requestMenu: String {
        return "\(self.description) 배송"
    }

    var listMenu: String {
        switch self {
        case .general:
            return self.requestMenu
        default:
            return self.description
        }
    }
    
    var toString: String {
        switch self {
        case .cafe:
            return "CAFE"
        case .parcel:
            return "PARCEL"
        case .general:
            return "GENERAL"
        }
    }
}

