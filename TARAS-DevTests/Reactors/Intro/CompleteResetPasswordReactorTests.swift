//
//  CompleteResetPasswordReactorTests.swift
//  TARAS-DevTests
//
//  Created by 오현식 on 2022/04/14.
//

import XCTest
@testable import TARAS_Dev

class CompleteResetPasswordReactorTests: XCTestCase {

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
        let reactor = CompleteResetPasswordViewReactor(
            provider: self.provider,
            id: DummyModel.username,
            password: DummyModel.password
        )
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = CompleteResetPasswordViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.toWorkspaceButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .autoLogIn)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = CompleteResetPasswordViewReactor(
            provider: self.provider,
            id: DummyModel.username,
            password: DummyModel.password
        )
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = CompleteResetPasswordViewController()
        viewController.reactor = reactor
        
        // 3. set a stub state
        // 로그인 완료 직후
        let state = CompleteResetPasswordViewReactor.State(
            isAutoLogIn: (true, true),
            isProcessing: false
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
    }
}
