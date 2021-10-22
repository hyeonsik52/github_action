//
//  RestAPIType.swift
//  TARAS-AL
//
//  Created by nexmond on 2021/10/15.
//

import Foundation

enum RestAPIType<T: RestAPIResponse> {
    
    var responseType: T.Type {
        return T.self
    }
}
