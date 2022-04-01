//
//  WorkspaceSearchReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/28.
//

import XCTest
@testable import TARAS_Dev

class WorkspaceSearchReactorTests: XCTestCase {
    
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
        let reactor = WorkspaceSearchViewReactor(provider: self.provider)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceSearchViewController()
        viewController.textFieldView.textField.text = DummyModel.displayName
        viewController.reactor = reactor
        
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .updateCode(DummyModel.displayName))

        // 3. send an user interaction programatically
        viewController.viewDidAppear(false)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .updateIsInitialOpen)
        
        // 3. send an user interaction programatically
        viewController.searchButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .confirmCode)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = WorkspaceSearchViewReactor(provider: self.provider)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceSearchViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = WorkspaceSearchViewReactor.State(
            code: nil,
            errorMessage: nil,
            isLoading: false,
            workspaceInfo: nil
        )
        reactor.stub.state.value = state

        // 4. assert view properties
        XCTAssertEqual(viewController.searchButton.isEnabled, InputPolicy.workspaceCode.matchRange(state.code ?? ""))
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isLoading)
        XCTAssertEqual(viewController.errorMessageLabel.text, state.errorMessage)
    }
}
