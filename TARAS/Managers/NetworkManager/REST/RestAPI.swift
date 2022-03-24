//
//  RestAPI.swift
//  TARAS
//
//  Created by nexmond on 2021/10/15.
//

import Foundation

protocol RestAPI {
    var url: URL { get }
    var parameters: [String: Any] { get }
}
