//
//  ResultsTests.swift
//  Dev-ServiceRobotPlatform-iOS-Tests
//
//  Created by nexmond on 2020/04/28.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import XCTest

@testable import TARAS_Dev

class ResultsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let fileUrl = try FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("test.realm")
        RealmManager.shared.openRealm(fileUrl)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        TEST_TB.allObjects.delete()
    }

    func testGetFirst() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        TEST_TB(index: NSNotFound).add()
        
        //give
        let test = TEST_TB.getFirst(property: "index", value: TEST_TB.lastIndex)
        
        //when
        
        //then
        XCTAssertNotNil(test, "fail results getFirst")
        
        TEST_TB.allObjects.delete()
    }

    func testUpdate() throws {
        
        TEST_TB(index: NSNotFound).add()
        
        //give
        let results = TEST_TB.allObjects
        
        //when
        results.update { results in
            results.first?.content = "updated"
        }
        
        //then
        XCTAssertTrue(results.first?.content == "updated", "fail results updating")
        
        TEST_TB.allObjects.delete()
    }

    func testDelete() throws {
        
        TEST_TB(index: NSNotFound).add()
        
        //give
        let results = TEST_TB.allObjects
        
        //when
        results.delete()
        
        //then
        XCTAssertTrue(results.count == 0, "fail results deleting")
    }
}
