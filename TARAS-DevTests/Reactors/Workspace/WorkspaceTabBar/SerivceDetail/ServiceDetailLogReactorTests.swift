//
//  ServiceDetailLogReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class ServiceDetailLogReactorTests: XCTestCase {
    
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
        let reactor = ServiceDetailLogViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceDetailLogViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewDidLoad()
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
        
        // 3. send an user interaction programatically
        viewController.tableView.refreshControl?.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceDetailLogViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceDetailLogViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        //완료된 서비스
        let state = ServiceDetailLogViewReactor.State(
            serviceLogs: DummyModel.serviceLogSet_completed.serviceLogs,
            isLoading: false
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), state.serviceLogs.count)
        XCTAssertEqual(viewController.tableView.refreshControl?.isRefreshing, state.isLoading == true)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isLoading == true)
    }
}
