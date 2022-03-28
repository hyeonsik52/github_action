//
//  SignUpPasswordReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/25.
//

import XCTest
@testable import TARAS_Dev

class SignUpPasswordReactorTests: XCTestCase {

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
        let account = Account(ID: DummyModel.id)
        let reactor = SignUpPasswordViewReactor(provider: self.provider, accountInfo: account)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = SignUpPasswordViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.signUpPasswordView.password.accept(DummyModel.password)
        viewController.signUpPasswordView.passwordConfirmed.accept(DummyModel.password)
        
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkPasswordValidation(password: DummyModel.password, confirm: DummyModel.password))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let account = Account(ID: DummyModel.id)
        let reactor = SignUpPasswordViewReactor(provider: self.provider, accountInfo: account)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = SignUpPasswordViewController()
        viewController.reactor = reactor
        
        // 3. set a stub state
        let state = SignUpPasswordViewReactor.State(
            isValid: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.signUpPasswordView.errorMessageLabel.text, state.errorMessage)
        XCTAssertEqual(viewController.nextButton.isEnabled, state.isValid)
    }
}
