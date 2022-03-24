//
//  NotificationManagerTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/23.
//

import XCTest
@testable import TARAS_Dev
import RxSwift

class NotificationManagerTests: XCTestCase {
    
    let notificationManager = MockManagerProvider().notificationManager
    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNotification() throws {
        
        let Notification = MockNotification.self
        
        let expect1 = expectation(description: "repeat0")
        
        var postedValue: String?
        self.notificationManager.observe(to: Notification, repeat: 0) { value in
            let isFirst = (postedValue == nil)
            postedValue = value
            if isFirst {
                expect1.fulfill()
            }
        }
        
        self.notificationManager.post(Notification.init("test1"))
        self.notificationManager.post(Notification.init("test1"))
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(postedValue, "test1")
        
        let expect2 = expectation(description: "repeat1")
        
        var count = 0
        self.notificationManager.observe(to: Notification, repeat: 1) { value in
            count += 1
            if count >= 2 {
                expect2.fulfill()
            }
        }
        
        self.notificationManager.post(Notification.init("test2"))
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(postedValue, "test2")
        
        self.notificationManager.dispose(to: Notification)
        
        self.notificationManager.post(Notification.init("test3"))
        
        XCTAssertNotEqual(postedValue, "test3")
    }
}
