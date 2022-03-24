//
//  ListTests.swift
//  Dev-ServiceRobotPlatform-iOS-Tests
//
//  Created by nexmond on 2020/04/28.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import XCTest

@testable import TARAS_Dev

class ListTests: XCTestCase {

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

        let newTest = TEST_TB(index: NSNotFound)
        newTest.list.append(TEST_TB(index: NSNotFound))
        newTest.add()
        
        //give
        let test = TEST_TB.getFirst!.list.first
        
        //when
        
        //then
        XCTAssertNotNil(test, "fail list getFirst")
        
        TEST_TB.allObjects.delete()
    }

    func testUpdate() throws {
        
        let newTest = TEST_TB(index: NSNotFound)
        newTest.list.append(TEST_TB(index: NSNotFound))
        newTest.add()
        
        //given
        let list = TEST_TB.getFirst!.list
        
        //when
        list.update { list in
            list.first?.content = "updated"
        }
        
        //then
        XCTAssertTrue(list.first?.content == "updated", "fail list updating: \(list.first?.content ?? "nil") != updated")
        
        TEST_TB.allObjects.delete()
    }

    func testDelete() throws {
        
        let newTest = TEST_TB(index: NSNotFound)
        newTest.list.append(TEST_TB(index: NSNotFound))
        newTest.add()
        
        //given
        let list = TEST_TB.getFirst!.list
        
        //when
        list.delete()
        
        //then
        XCTAssertTrue(list.count == 0, "fail list delete")
        
        TEST_TB.allObjects.delete()
    }
}
