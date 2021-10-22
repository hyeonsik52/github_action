//
//  RestAPIRequest.swift
//  TARAS-AL
//
//  Created by nexmond on 2021/10/16.
//

import Foundation

protocol RestAPIRequest: Codable {
    associatedtype Response: RestAPIResponse
    var responseType: Response.Type { get }
}

extension RestAPIRequest {
    var responseType: Response.Type {
        return Response.self
    }
}
