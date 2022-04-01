//
//  LaunchScreenReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/24.
//

import XCTest
@testable import TARAS_Dev

class LaunchScreenReactorTests: XCTestCase {

    var provider: ManagerProviderType!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.provider = MockManagerProvider()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.provider = nil
    }

    func testActions() throws {
        
        // 1. prepare a stub reactor
        let reactor = LaunchScreenViewReactor(provider: self.provider)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = LaunchScreenViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewDidLoad()
        
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .check(isRealmOpened: true))
    }
    
    /// Realm 이 열린 후 clientInfo 업데이트 과정을 누락하지않고 거치는지 확인
    func testIsClientInfoUpdated() throws {
        
        // given
        let reactor = LaunchScreenViewReactor(provider: self.provider)
        let viewController = LaunchScreenViewController()
        viewController.reactor = reactor
        
        // when
        reactor.provider.userManager.userTB.update { $0.clientInfo = nil }
        XCTAssertNil(reactor.provider.userManager.userTB.clientInfo)
        reactor.action.onNext(.check(isRealmOpened: true))
        
        // then
        XCTAssertNotNil(reactor.provider.userManager.userTB.clientInfo)
    }
}
