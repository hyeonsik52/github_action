//
//  ServiceShortcutRegistrationReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class ServiceShortcutRegistrationReactorTests: XCTestCase {
    
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
        let reactor = ServiceShortcutRegistrationViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceShortcutRegistrationViewController()
        viewController.textFieldView.textField.text = DummyModel.displayName
        viewController.detailTextView.text = DummyModel.description
        viewController.reactor = reactor

        // 3. send an user interaction programatically
        viewController.confirmButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .register(name: DummyModel.displayName, description: DummyModel.description))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceShortcutRegistrationViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceShortcutRegistrationViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        //완료된 서비스
        let state = ServiceShortcutRegistrationViewReactor.State(
            isConfirmed: nil,
            isProcessing: true,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.confirmButton.isEnabled, (viewController.textFieldView.textField.text?.isEmpty == false) && !(state.isProcessing == true))
    }
}
