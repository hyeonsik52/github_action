//
//  STFlow.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/06.
//

import Foundation

struct STFlow: Identifiable {
    var id: String = UUID().uuidString
    var childs: [STFlow]?
    var view: STView
    var json: [String: Any] = [:]
}
