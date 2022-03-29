//
//  WorkspaceMoreReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/28.
//

import XCTest
@testable import TARAS_Dev

class WorkspaceMoreReactorTests: XCTestCase {
    
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
        let reactor = WorkspaceMoreViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceMoreViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewWillAppear(false)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .reload)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = WorkspaceMoreViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceMoreViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = WorkspaceMoreViewReactor.State(
            workspace: DummyModel.workspace_basic,
            isQuit: nil,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        let workspace = state.workspace
        XCTAssertEqual(viewController.workspaceView.nameLabel.text, workspace?.name)
        XCTAssertEqual(viewController.workspaceView.dateLabel.text, workspace?.createdAt.toString(JoinRequestView.Text.JRV_5))
        XCTAssertEqual(viewController.workspaceView.button.title(for: .normal), JoinRequestView.Text.JRV_6)
    }
}
