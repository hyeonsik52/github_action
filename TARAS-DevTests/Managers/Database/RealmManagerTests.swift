//
//  RealmManagerTests.swift
//  Dev-ServiceRobotPlatform-iOS-Tests
//
//  Created by nexmond on 2020/04/28.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import XCTest

@testable import TARAS_Dev

import RxSwift
import RxBlocking

class RealmManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOpenRealm() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        do {
            //given
            let fileUrl = try FileManager.default
                .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("test.realm")
            RealmManager.shared.openRealm(fileUrl)
            
            //when
            var opened = false
            let result = RealmManager.shared.openRelay.toBlocking(timeout: 1).materialize()
            switch result {
            case let .completed(elements):
                opened = elements.last == true
            case let .failed(elements, _):
                opened = elements.last == true
            }
            
            //then
            XCTAssertTrue(opened, "failed open Realm")
            
        } catch let error {
            XCTAssertTrue(false, "failed open Realm \(error.localizedDescription)")
        }
    }

}
