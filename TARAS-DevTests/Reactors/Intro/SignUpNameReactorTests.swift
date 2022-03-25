//
//  SignUpNameReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/25.
//

import XCTest
@testable import TARAS_Dev

class SignUpNameReactorTests: XCTestCase {
    
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
        let reactor = SignUpNameViewReactor(provider: self.provider, accountInfo: .init())
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = SignUpNameViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.signUpView.name.accept(MockModel.displayName)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkValidation(name: MockModel.displayName))

        // 3. send an user interaction programatically
        viewController.confirmButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .signUp(name: MockModel.displayName))
        
        // 3. send an user interaction programatically
        viewController.reactor?.action.onNext(.login(withAuth: true))
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .login(withAuth: true))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = SignUpNameViewReactor(provider: self.provider, accountInfo: .init())
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = SignUpNameViewController()
        viewController.reactor = reactor
        
        // 3. set a stub state
        let state = SignUpNameViewReactor.State(
            isValid: false,
            isSignUp: nil,
            isLogin: nil,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.confirmButton.isEnabled, state.isValid)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.signUpView.errorMessageLabel.text, state.errorMessage)
    }
}
