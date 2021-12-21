//
//  Stop.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/09.
//

import Foundation

struct Stop: Identifiable {
    
    ///정차지 아이디
    let id: String
    ///정차지 이름
    let name: String
}

extension Stop: FragmentModel {

    init(_ fragment: StopFragment) {

        self.id = fragment.id
        self.name = fragment.name
    }
    
    init(option fragment: StopFragment?) {
        
        self.id = fragment?.id ?? Self.unknownId
        self.name = fragment?.name ?? "알 수 없는 위치"
    }
}

extension Stop: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
    }
}
