//
//  BaseObjectTests.swift
//  Dev-ServiceRobotPlatform-iOS-Tests
//
//  Created by nexmond on 2020/04/28.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import XCTest

@testable import TARAS_Dev

class BaseObjectTests: XCTestCase {

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

    func testAutoIncrement() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        TEST_TB(index: NSNotFound).add()
        TEST_TB(index: NSNotFound).add()
        
        //given
        let allObjects = TEST_TB.allObjects.sorted(byKeyPath: "index", ascending: false)
        
        //when
        let first = allObjects[1]
        let second = allObjects[0]
        
        //then
        XCTAssertTrue(second.index-first.index == 1, "fail AutoIncrement: \(second.index) - \(first.index) != 1")
        
        TEST_TB.allObjects.delete()
    }
    
    func testThreadSafe() throws {
        
        TEST_TB(index: NSNotFound).add()
        
        let expect = expectation(description: "threadSafe processing...")
        
        //given
        let test = TEST_TB.getFirst!
        test.update{$0.content = nil}
        let content = test.content
        let threadSafe = test.threadSafeReference
        
        //when
        DispatchQueue.global().async {
            let resolved = threadSafe.resolved
            resolved?.update{$0.content = "successed"}
            
            XCTAssertTrue(resolved?.content != content, "fail threadSafe resolving: \(resolved?.content ?? "nil") == \(content ?? "nil")")
            
            TEST_TB.allObjects.delete()
            
            expect.fulfill()
        }
        
        //then
        wait(for: [expect], timeout: 1);
    }
    
    func testGetFirst() throws {
        
        TEST_TB(index: NSNotFound).add()
        
        //given
        
        //when
        let test = TEST_TB.getFirst
        
        //then
        XCTAssertNotNil(test, "fail getFirst")

        TEST_TB.allObjects.delete()
    }
    
    func testDelete() throws {
        
        TEST_TB(index: NSNotFound).add()
        
        //given
        let test = TEST_TB.allObjects.last
        
        //when
        test?.delete()
        
        //then
        XCTAssertTrue(test?.isInvalidated ?? false, "fail delete")

        TEST_TB.allObjects.delete()
    }
}
