//
//  UpdateUserInfoReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/28.
//

import XCTest
@testable import TARAS_Dev

class UpdateUserInfoReactorTests: XCTestCase {
    
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
        let reactor = UpdateUserInfoViewReactor(
            provider: self.provider,
            userID: DummyModel.username,
            inputType: .name,
            prevValue: DummyModel.displayName
        )
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = UpdateUserInfoViewController()
        viewController.userInputView.textField.text = DummyModel.displayName
        viewController.reactor = reactor
        
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkValidation(text: DummyModel.displayName))
        
        // 3. send an user interaction programatically
        viewController.userInputView.confirmButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .update(text: DummyModel.displayName))
    }

    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = UpdateUserInfoViewReactor(
            provider: self.provider,
            userID: DummyModel.username,
            inputType: .name,
            prevValue: DummyModel.displayName
        )
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = UpdateUserInfoViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = UpdateUserInfoViewReactor.State(
            isValid: false,
            isUpdated: nil,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state

        // 4. assert view properties
        XCTAssertEqual(viewController.userInputView.confirmButton.isEnabled, state.isValid)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.errorMessageLabel.text, state.errorMessage)
    }
}
