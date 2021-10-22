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
}
