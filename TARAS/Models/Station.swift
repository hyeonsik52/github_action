//
//  Station.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/09.
//

import Foundation

struct Station: Identifiable {
    
    var id: String
    var name: String
}

extension Station: FragmentModel {
    
    init(_ fragment: StationFragment) {
        
        self.id = fragment.id
        self.name = fragment.name
    }
}
