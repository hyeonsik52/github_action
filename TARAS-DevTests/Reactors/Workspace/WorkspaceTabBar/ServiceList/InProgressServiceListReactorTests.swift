//
//  InProgressServiceListReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class InProgressServiceListReactorTests: XCTestCase {
    
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
        let reactor = InProgressServiceListViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = InProgressServiceListViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewDidLoad()
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
        
        // 3. send an user interaction programatically
        viewController.collectionView.refreshControl?.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
        
        // 3. send an user interaction programatically
        reactor.stub.state.value.retryMoreFind = true
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .moreFind(.init(item: 0, section: 0)))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = InProgressServiceListViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = InProgressServiceListViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = InProgressServiceListViewReactor.State(
            services: [],
            isLoading: nil,
            isProcessing: nil,
            retryMoreFind: false
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.collectionView.numberOfItems(inSection: 0), state.services.count)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing == true)
        XCTAssertEqual(viewController.collectionView.refreshControl?.isRefreshing, state.isLoading == true)
    }
}
