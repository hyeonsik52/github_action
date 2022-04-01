//
//  ServiceCreationSelectReceiverReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class ServiceCreationSelectReceiverReactorTests: XCTestCase {
    
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
        let reactor = ServiceCreationSelectReceiverViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceUnit: DummyModel.serviceUnitCreationModel,
            mode: .create,
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationSelectReceiverViewController()
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
        
        let user = ServiceUnitTargetModel(id: DummyModel.id, name: DummyModel.displayName)
        reactor.stub.state.value.users = [
            .init(
                model: user,
                selectionType: .check,
                isEnabled: true,
                isIconVisibled: true,
                highlightRanges: [],
                isSeparated: false
            )
        ]
        // 3. send an user interaction programatically
        viewController.tableView.delegate?.tableView?(viewController.tableView, didSelectRowAt: .init(row: 0, section: 0))
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .select(model: user))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceCreationSelectReceiverViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceUnit: DummyModel.serviceUnitCreationModel,
            mode: .create,
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationSelectReceiverViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = ServiceCreationSelectReceiverViewReactor.State(
            selectedUsers: [],
            users: [],
            isLoading: false,
            placeholderState: .networkDisconnected
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), state.users.count)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isLoading)
        XCTAssertTrue(viewController.listPlaceholderView.notFoundPlaceholder.isHidden == (state.placeholderState != .resultNotFound))
        XCTAssertTrue(viewController.listPlaceholderView.disconnectedPlaceholder.isHidden == (state.placeholderState != .networkDisconnected))
    }
}
