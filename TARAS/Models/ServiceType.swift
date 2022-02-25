//
//  ServiceType.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/21.
//

import Foundation

///서비스 타입
enum ServiceType: String {
    
    ///일반 (N)
    case general = "GENERAL"
    ///로딩-언로딩 (L)
    case loading = "LOADING"
    ///복귀
    case recall = "RECALL"
    ///알수없는
    case unknown
}
