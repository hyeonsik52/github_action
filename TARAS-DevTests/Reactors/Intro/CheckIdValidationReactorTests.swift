//
//  CheckIdValidationReactorTests.swift
//  TARAS-DevTests
//
//  Created by 오현식 on 2022/04/14.
//

import XCTest
@testable import TARAS_Dev

class CheckIdValidationReactorTests: XCTestCase {

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
        let reactor = CheckIdValidationViewReactor(provider: self.provider)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = CheckIdValidationViewController()
        viewController.reactor = reactor

        // 3. send an user interaction programatically
        viewController.checkIdValidationView.id.accept(DummyModel.username)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkValidation(id: DummyModel.username))
        
        
        // 3. send an user interaction programmatically
        viewController.toCertifyEmailButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkRegistration(id: DummyModel.username))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = CheckIdValidationViewReactor(provider: self.provider)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = CheckIdValidationViewController()
        viewController.reactor = reactor
        
        // 3. set a stub state
        // 아이디 유효성 검사 직후
        let state = CheckIdValidationViewReactor.State(
            isValid: true,
            isAvailable: false,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.toCertifyEmailButton.isEnabled, state.isValid)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.checkIdValidationView.errorMessageLabel.text, state.errorMessage)
    }
}
