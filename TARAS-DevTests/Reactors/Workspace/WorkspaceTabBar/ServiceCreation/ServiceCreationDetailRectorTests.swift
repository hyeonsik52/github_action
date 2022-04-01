//
//  ServiceCreationDetailRectorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class ServiceCreationDetailRectorTests: XCTestCase {
    
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
        let reactor = ServiceCreationDetailViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceUnit: DummyModel.serviceUnitCreationModel,
            mode: .create,
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationDetailViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.confirmButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .confirm(""))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceCreationDetailViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceUnit: DummyModel.serviceUnitCreationModel,
            mode: .create,
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationDetailViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = ServiceCreationDetailViewReactor.State(
            isConfirmed: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.detailTextView.text, reactor.serviceUnit.detail ?? "")
    }
}
