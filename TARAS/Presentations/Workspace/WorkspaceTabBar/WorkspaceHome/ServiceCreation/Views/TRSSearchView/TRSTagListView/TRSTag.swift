//
//  TRSTag.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/26.
//

import Foundation

protocol TRSTag {
    var id: String { get }
    var string: String { get }
}

extension String: TRSTag {
    
    var id: String { self }
    var string: String { self }
}
