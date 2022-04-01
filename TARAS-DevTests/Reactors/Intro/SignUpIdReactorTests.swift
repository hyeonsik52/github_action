//
//  SignUpIdReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/25.
//

import XCTest
@testable import TARAS_Dev

class SignUpIdReactorTests: XCTestCase {

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
        let reactor = SignUpIdViewReactor(provider: self.provider)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = SignUpIdViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.signUpView.id.accept(DummyModel.id)
        
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkValidation(id: DummyModel.id))
        
        // 3. send an user interaction programatically
        viewController.signUpView.duplicateCheckButtonDidTap.accept(())
        
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkDuplication(id: DummyModel.id))
    }
    
    func testStates() throws {
        // 1. prepare a stub reactor
        let reactor = SignUpIdViewReactor(provider: self.provider)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = SignUpIdViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = SignUpIdViewReactor.State(
            isValid: false,
            isAvailable: false,
            isProcessing: false,
            message: ("error test message", .redEB4D39)
        )
        reactor.stub.state.value = state

        // 4. assert view properties
        XCTAssertEqual(viewController.signUpView.idTextFieldView.innerButton.isEnabled, state.isValid)
        XCTAssertEqual(viewController.nextButton.isEnabled, state.isAvailable)
        XCTAssertEqual(viewController.signUpView.errorMessageLabel.text, state.message?.message)
        XCTAssertEqual(viewController.signUpView.errorMessageLabel.textColor, state.message?.color)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
    }
}
