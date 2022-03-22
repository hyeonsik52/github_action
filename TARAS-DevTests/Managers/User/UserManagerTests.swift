//
//  UserManagerTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import XCTest
@testable import TARAS_Dev

class UserManagerTests: XCTestCase {

    let userManager = MockManagerProvider().userManager
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasTokens() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        XCTAssertEqual(self.userManager.hasTokens, true)
    }
    
    func testUpdateClientInfo() throws {
        
        XCTAssertNil(self.userManager.userTB.clientInfo)
        self.userManager.updateClientInfo()
        XCTAssertNotNil(self.userManager.userTB.clientInfo)
    }
    
    func testUpdateTokens() throws {
        
        let accessToken = self.userManager.userTB.accessToken ?? ""
        let refreshToken = self.userManager.userTB.refreshToken ?? ""
        
        self.userManager.updateTokens(access: "access", refresh: "refresh")
        
        XCTAssertNotEqual(accessToken, self.userManager.userTB.accessToken)
        XCTAssertNotEqual(refreshToken, self.userManager.userTB.refreshToken)
        
        self.userManager.updateTokens(access: accessToken, refresh: refreshToken)
        
        XCTAssertEqual(accessToken, self.userManager.userTB.accessToken)
        XCTAssertEqual(refreshToken, self.userManager.userTB.refreshToken)
    }
    
    func testUpdateUserInfo() throws {
        
        let userFragment = UserFragment(
            id: MockModel.id,
            username: MockModel.username,
            displayName: MockModel.displayName,
            email: MockModel.email,
            phoneNumber: MockModel.phoneNumber
        )
        
        self.userManager.updateUserInfo(userFragment)
        
        XCTAssertEqual(userFragment.id, self.userManager.userTB.ID)
        XCTAssertEqual(userFragment.username, self.userManager.userTB.id)
        XCTAssertEqual(userFragment.displayName, self.userManager.userTB.name)
        XCTAssertEqual(userFragment.email, self.userManager.userTB.email)
        XCTAssertEqual(userFragment.phoneNumber, self.userManager.userTB.phoneNumber)
    }
    
    func testAccount() throws {
        
        let account = self.userManager.account()
        
        XCTAssertEqual(account.ID, self.userManager.userTB.ID)
        XCTAssertEqual(account.id, self.userManager.userTB.id)
        XCTAssertEqual(account.name, self.userManager.userTB.name)
        XCTAssertEqual(account.email, self.userManager.userTB.email)
        XCTAssertEqual(account.phoneNumber, self.userManager.userTB.phoneNumber)
    }
    
    func testAuthPayload() throws {
        
        let payload = self.userManager.authPayload()
        
        XCTAssertNotNil(self.userManager.userTB.accessToken)
        XCTAssertTrue(payload["Authorization"]?.hasSuffix(self.userManager.userTB.accessToken!) == true)
    }
    
    func testReAuthenticate() throws {
        
        XCTAssertNotNil(self.userManager.userTB.accessToken)
        let accessToken = self.userManager.userTB.accessToken!
        
        let expect = expectation(description: "waiting...")
        self.userManager.reAuthenticate(accessToken) { result in
            expect.fulfill()
        }
        
        var afterRequestBlocked = false
        self.userManager.reAuthenticate(accessToken) { result in
            afterRequestBlocked = true
        }
        XCTAssertTrue(afterRequestBlocked)
        
        waitForExpectations(timeout: .infinity)
    }
    
    func testInitializeLastWorkspaceId() throws {
        
        self.userManager.userTB.lastWorkspaceId = MockModel.id
        XCTAssertNotNil(self.userManager.userTB.lastWorkspaceId)
        
        self.userManager.initializeLastWorkspaceId(MockModel.id)
        XCTAssertNil(self.userManager.userTB.lastWorkspaceId)
    }
    
    func testInitializeUserTB() throws {
        
        self.userManager.initializeUserTB()
        XCTAssertFalse(self.userManager.hasTokens)
    }
}
