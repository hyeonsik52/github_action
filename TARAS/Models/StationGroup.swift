//
//  StationGroup.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/09.
//

import Foundation

struct StationGroup: Identifiable {
    
    var id: String
    var name: String
    var stations: [Station]
}

extension StationGroup: FragmentModel {
    
    init(_ fragment: StationGroupFragment) {
        
        self.id = fragment.id
        self.name = fragment.name
        self.stations = fragment.stations?.edges
            .compactMap(\.?.node?.fragments.stationFragment)
            .map(Station.init) ?? []
    }
}
