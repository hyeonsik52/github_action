//
//  UpdateUserEmailReactorTests.swift
//  TARAS-DevTests
//
//  Created by 오현식 on 2022/04/11.
//

import XCTest
@testable import TARAS_Dev
import RxSwift

class UpdateUserEmailReactorTests: XCTestCase {
    
    var provider: ManagerProviderType!
    
    var disposeBag = DisposeBag()
    
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
        let reactor = UpdateUserEmailViewReactor(provider: self.provider)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = UpdateUserEmailViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programmatically
        viewController.certifyEmailView.email.accept(DummyModel.email)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.first, .checkValidation(email: DummyModel.email))
        
        // 3. send an user interaction programmatically
        viewController.certifyEmailView.certifyButtonDidTap.accept(())
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .sendAuthNumber(email: DummyModel.email))
        
        // 3. send an user interaction programmatically
        viewController.certifyEmailView.authNumber.accept(DummyModel.authNumber)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkEnable(authNumber: DummyModel.authNumber))
        
        // 3. send an user interaction programmatically
        viewController.confirmButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .checkAuthNumber(authNumber: DummyModel.authNumber))
        
    }

    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = UpdateUserEmailViewReactor(provider: self.provider)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = UpdateUserEmailViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        //유효한 이메일로 인증코드 요청 직후
        let state = UpdateUserEmailViewReactor.State(
            isEmailValid: true,
            isAuthNumberValid: false,
            authNumberExpires: 1800,
            isUpdateUserEmail: false,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.certifyEmailView.emailTextFieldView.innerButton.isEnabled, state.isEmailValid)
        XCTAssertEqual(
            viewController.certifyEmailView.emailTextFieldView.innerButton.title(for: .normal),
            UpdateUserEmailViewController.Text.retryCertifyEmailButtonTitle
        )
        
        XCTAssertEqual(viewController.certifyEmailView.authNumberTextFieldView.isHidden, false)
        XCTAssertEqual(viewController.certifyEmailView.authNumberTextFieldView.textField.text, "")
        
        
        XCTAssertEqual(viewController.confirmButton.isEnabled, state.isAuthNumberValid && true)
        
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.certifyEmailView.errorMessageLabel.text, state.errorMessage)
        
        let expectation = XCTestExpectation(description: "TimerTest")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: expectation.fulfill)
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(
            viewController.certifyEmailView.authNumberTextFieldView.timerLabel.text,
            TimeInterval(state.authNumberExpires ?? -1).toTimeString
        )
    }
}
