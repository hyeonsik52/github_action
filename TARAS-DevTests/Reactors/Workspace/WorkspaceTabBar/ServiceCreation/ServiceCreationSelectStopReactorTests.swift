//
//  ServiceCreationSelectStopReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/29.
//

import XCTest
@testable import TARAS_Dev

class ServiceCreationSelectStopReactorTests: XCTestCase {
    
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
        let reactor = ServiceCreationSelectStopViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            mode: .create,
            entry: .general(DummyModel.serviceUnitCreationModel),
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationSelectStopViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.tableView.refreshControl?.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh(term: nil))
        
        // 3. send an user interaction programatically
        viewController.searchView.searchTerm.accept(DummyModel.description)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh(term: DummyModel.description))
        
        // 3. send an user interaction programatically
        viewController.listPlaceholderView.disconnectedRetryButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh(term: DummyModel.description))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceCreationSelectStopViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            mode: .create,
            entry: .general(DummyModel.serviceUnitCreationModel),
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationSelectStopViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = ServiceCreationSelectStopViewReactor.State(
            stops: [],
            isLoading: false,
            isConfirmed: nil,
            placeholderState: .networkDisconnected
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), state.stops.count)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isLoading)
        XCTAssertTrue(viewController.listPlaceholderView.notFoundPlaceholder.isHidden == (state.placeholderState != .resultNotFound))
        XCTAssertTrue(viewController.listPlaceholderView.disconnectedPlaceholder.isHidden == (state.placeholderState != .networkDisconnected))
    }
}
