//
//  WorkspaceListReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/25.
//

import XCTest
@testable import TARAS_Dev

class WorkspaceListReactorTests: XCTestCase {
    
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
        let reactor = WorkspaceListViewReactor(provider: self.provider, isFrom: .none)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceListViewController()
        viewController.reactor = reactor

        // 3. send an user interaction programatically
        viewController.viewWillAppear(false)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
        
        // 3. send an user interaction programatically
        viewController.viewDidAppear(false)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .judgeEntrance)
        
        // 3. send an user interaction programatically
        viewController.refreshControl.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
    }
    
    func testStates() throws {
        // 1. prepare a stub reactor
        let reactor = WorkspaceListViewReactor(provider: self.provider, isFrom: .none)
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceListViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = WorkspaceListViewReactor.State(
            isPlaceholderHidden: true,
            sections: [],
            entranceType: .none
        )
        reactor.stub.state.value = state

        // 4. assert view properties
        XCTAssertEqual(viewController.tableView.numberOfSections, state.sections.count)
        XCTAssertEqual(viewController.tableViewPlaceholder.isHidden, state.isPlaceholderHidden)
    }
}
