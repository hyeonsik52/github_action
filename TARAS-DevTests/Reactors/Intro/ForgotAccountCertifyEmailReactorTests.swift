//
//  ForgotAccountCertifyEmailReactorTests.swift
//  TARAS-DevTests
//
//  Created by 오현식 on 2022/04/14.
//

import XCTest
@testable import TARAS_Dev

class ForgotAccountCertifyEmailReactorTests: XCTestCase {

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
        let reactor = ForgotAccountCertifyEmailViewReactor(provider: self.provider, isFindId: true)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = ForgotAccountCertifyEmailViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programmatically
        viewController.forgotAccountCertifyEmailView.email.accept(DummyModel.email)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.first, .checkValidation(email: DummyModel.email))
        
        // 3. send an user interaction programmatically
        viewController.forgotAccountCertifyEmailView.certifyButtonDidTap.accept(())
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .sendAuthNumber(email: DummyModel.email))
        
        // 3. send an user interaction programmatically
        viewController.forgotAccountCertifyEmailView.authNumber.accept(DummyModel.authNumber)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkEnable(authNumber: DummyModel.authNumber))
        
        // 3. send an user interaction programmatically
        viewController.confirmButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkAuthNumber(authNumber: DummyModel.authNumber))
    }

    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ForgotAccountCertifyEmailViewReactor(provider: self.provider, isFindId: true)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = ForgotAccountCertifyEmailViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        //유효한 이메일로 인증코드 요청 직후
        let state = ForgotAccountCertifyEmailViewReactor.State(
            isEmailValid: true,
            isEmailEdited: false,
            isAuthNumberValid: false,
            authNumberExpires: Date().addingTimeInterval(1800),
            findUsername: "",
            requestToken: "",
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.forgotAccountCertifyEmailView.emailTextFieldView.innerButton.isEnabled, state.isEmailValid)
        XCTAssertEqual(
            viewController.forgotAccountCertifyEmailView.emailTextFieldView.innerButton.title(for: .normal),
            UpdateUserEmailViewController.Text.retryCertifyEmailButtonTitle
        )
        
        XCTAssertEqual(viewController.forgotAccountCertifyEmailView.authNumberTextFieldView.isHidden, false)
        XCTAssertEqual(viewController.forgotAccountCertifyEmailView.authNumberTextFieldView.textField.text, "")
        
        XCTAssertEqual(
            viewController.forgotAccountCertifyEmailView.authNumberTextFieldView.timerLabel.text,
            (state.authNumberExpires ?? Date()).timeIntervalSinceNow.toTimeString
        )
        
        XCTAssertEqual(viewController.confirmButton.isEnabled, state.isAuthNumberValid && true)
        
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.forgotAccountCertifyEmailView.errorMessageLabel.text, state.errorMessage)
    }
}
