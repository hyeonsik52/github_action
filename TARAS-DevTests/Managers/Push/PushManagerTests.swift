//
//  PushManagerTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import XCTest
@testable import TARAS_Dev

class PushManagerTests: XCTestCase {
    
    let pushManager = MockManagerProvider().pushManager as! MockPushManager

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWindow() throws {
        
        XCTAssertNotNil(self.pushManager.window)
    }

    func testSetupTabBarController() throws {
        
        let workspaceId = "ws_\(MockModel.id)"
        let serviceId = "s_\(MockModel.id)"
        
        let notificationInfo = NotificationInfo([
            "workspaceId": workspaceId,
            "serviceId": serviceId
        ])
        
        self.pushManager.setupTabBarController(notificationInfo)
        XCTAssertNotNil(self.pushManager.checkInfo)
        
        let info = self.pushManager.checkInfo!
        XCTAssertEqual(info.workspaceId, workspaceId)
        XCTAssertEqual(info.serviceId, serviceId)
    }
}
