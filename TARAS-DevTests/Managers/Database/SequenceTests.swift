//
//  SequenceTests.swift
//  Dev-ServiceRobotPlatform-iOS-Tests
//
//  Created by nexmond on 2020/04/28.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import XCTest

@testable import TARAS_Dev

class SequenceTests: XCTestCase {

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

    func testAdd() throws {
        
        TEST_TB(index: NSNotFound).add()
        TEST_TB(index: NSNotFound).add()
        
        //given
        let newTest = TEST_TB(index: NSNotFound)
        let newObjects = [newTest]
        
        //when
        newObjects.add()
        
        //then
        let test = TEST_TB.getFirst(property: "index", value: newTest.index)
        XCTAssertNotNil(test, "fail sequence adding")
        
        TEST_TB.allObjects.delete()
    }

    func testUpdate() throws {
        
        TEST_TB(index: NSNotFound).add()
        
        //given
        let test = TEST_TB.getFirst!
        let objects = [test]
        
        //when
        objects.update { sequence in
            sequence.first?.content = "updated"
        }
        
        //then
        XCTAssertTrue(objects.first?.content == "updated", "fail sequence updating")
        
        TEST_TB.allObjects.delete()
    }

    func testDelete() throws {
        
        TEST_TB(index: NSNotFound).add()
        
        //give
        let test = TEST_TB.getFirst!
        let objects = [test]
        
        //when
        objects.delete()
        
        //then
        XCTAssertTrue(test.isInvalidated, "fail results deleting")
        
        TEST_TB.allObjects.delete()
    }
}
