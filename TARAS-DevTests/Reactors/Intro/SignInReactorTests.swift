//
//  SignInReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/24.
//

import XCTest
@testable import TARAS_Dev

class SignInReactorTests: XCTestCase {

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
        let reactor = SignInViewReactor(provider: self.provider)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = SignInViewController()
        viewController.signInView.idTextFieldView.textField.text = MockModel.username
        viewController.signInView.passwordTextFieldView.textField.text = MockModel.password
        viewController.reactor = reactor

        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkValidation(id: MockModel.username, password: MockModel.password))
        
        // 3. send an user interaction programatically
        viewController.signInView.signInButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .signIn(id: MockModel.username, password: MockModel.password))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = SignInViewReactor(provider: self.provider)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = SignInViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = SignInViewReactor.State(
            isValid: false,
            isSignIn: nil,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state

        // 4. assert view properties
        XCTAssertEqual(viewController.signInView.signInButton.isEnabled, state.isValid)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.signInView.warningLabel.text, state.errorMessage)
    }
}
