//
//  ResetPasswordReactorTests.swift
//  TARAS-DevTests
//
//  Created by 오현식 on 2022/04/14.
//

import XCTest
@testable import TARAS_Dev

class ResetPasswordReactorTests: XCTestCase {

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
        let reactor = ResetPasswordViewReactor(
            provider: self.provider,
            id: DummyModel.username,
            token: DummyModel.id
        )
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = ResetPasswordViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.resetPasswordView.password.accept(DummyModel.password)
        viewController.resetPasswordView.passwordConfirmed.accept(DummyModel.password)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkPasswordValidation(password: DummyModel.password, confirm: DummyModel.password))
        
        // e. send an user interaction programatically
        viewController.toCompleteResetPasswordButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .updatePassword(password: DummyModel.password))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ResetPasswordViewReactor(
            provider: self.provider,
            id: DummyModel.username,
            token: DummyModel.id
        )
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = ResetPasswordViewController()
        viewController.reactor = reactor
        
        // 3. set a stub state
        // 비밀번호 유효성 검사 직후
        let state = ResetPasswordViewReactor.State(
            isValid: true,
            isUpdate: false,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.toCompleteResetPasswordButton.isEnabled, state.isValid)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.resetPasswordView.errorMessageLabel.text, state.errorMessage)

    }
}
