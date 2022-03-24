//
//  MockREST.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/23.
//

import Foundation
@testable import TARAS_Dev

struct MockResponseModel: RestAPIResponse {
    
    enum CodingKeys: String, CodingKey {
        case test = "test"
    }
    
    let test: String
}

struct MockRequestModel: RestAPIRequest {
    typealias Response = MockResponseModel
    
    enum CodingKeys: String, CodingKey {
        case test
    }
    
    let test: String
}

struct MockRestAPI<S: RestAPIRequest>: RestAPI {
    
    let input: S
    
    init(input: S) {
        self.input = input
    }
    
    var url: URL {
        return URL(string: "https://test.com")!
    }
    
    var parameters: [String: Any] {
        return self.input.dictionary
    }
}
