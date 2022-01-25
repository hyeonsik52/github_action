//
//  TRSTagListViewModel.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/24.
//

import Foundation

struct TRSTagListViewModel: Hashable {
    
    let string: String
    
    var title: String {
        if string.count > 10 {
            return String(self.string[0..<10]) + "..."
        } else {
            return self.string
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.string == rhs.string
    }
    
    var hashValue: Int {
        return self.string.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.string)
    }
}
