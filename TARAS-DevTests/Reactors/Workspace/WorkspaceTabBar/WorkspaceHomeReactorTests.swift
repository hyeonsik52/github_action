//
//  WorkspaceHomeReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/28.
//

import XCTest
@testable import TARAS_Dev

class WorkspaceHomeReactorTests: XCTestCase {
    
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
        let reactor = WorkspaceHomeReactor(
            provider: self.provider,
            workspaceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceHomeViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewDidLoad()
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .loadTemplates)
        
        // 3. send an user interaction programatically
        viewController.viewWillAppear(false)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refreshInfo)
        
        // 3. send an user interaction programatically
        viewController.collectionView.refreshControl?.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .loadTemplates)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = WorkspaceHomeReactor(
            provider: self.provider,
            workspaceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceHomeViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = WorkspaceHomeReactor.State(
            myUserInfo: DummyModel.user_basic,
            workspace: DummyModel.workspace_basic,
            templates: [try DummyModel.serviceTemplate_basic_general()],
            isLoading: false,
            isProcessing: false,
            errorMessage: nil,
            isShortcutDeleted: nil,
            isShortcutCreated: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.workspaceView.nameLabel.text, state.workspace?.name)
        XCTAssertEqual(viewController.headerView.userNameLabel.text, "\(state.myUserInfo?.displayName ?? "")님!")
        XCTAssertEqual(viewController.collectionView.numberOfItems(inSection: 0), state.templates.count)
        XCTAssertEqual(viewController.collectionView.refreshControl?.isRefreshing, state.isProcessing)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isLoading)
        
        reactor.stub.state.value.isShortcutDeleted = true
        XCTAssertEqual(reactor.stub.actions.last, .loadTemplates)
    }
}
