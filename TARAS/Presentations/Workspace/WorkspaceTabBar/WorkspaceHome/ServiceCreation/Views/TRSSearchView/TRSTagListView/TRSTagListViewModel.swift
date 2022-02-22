//
//  TRSTagListViewModel.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/24.
//

import Foundation

struct TRSTagListViewModel: Hashable {
    
    let id: String
    let string: String
    
    init(string: String, id: String? = nil) {
        self.id = id ?? string
        self.string = string
    }
    
    init<T: TRSTag>(_ tag: T) {
        self.id = tag.id
        self.string = tag.string
    }
    
    var title: String {
        if string.count > 10 {
            return String(self.string[0..<10]) + "..."
        } else {
            return self.string
        }
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        return self.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
