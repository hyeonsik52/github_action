//
//  ServiceCreationSummaryReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class ServiceCreationSummaryReactorTests: XCTestCase {
    
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
        let reactor = ServiceCreationSummaryViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceUnit: DummyModel.serviceUnitCreationModel,
            mode: .create,
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationSummaryViewController()
        viewController.reactor = reactor
        
        // 4. assert actions
        XCTAssertTrue(reactor.stub.actions.contains(where: { $0 == .updateDetail(reactor.initialState.serviceUnit.detail)}))
        
        // 3. send an user interaction programatically
        viewController.confirmButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .confirm)
        
        // 3. send an user interaction programatically
        viewController.viewDidAppear(false)
        viewController.workWaitingSwitch.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .updateIsWorkWaiting(viewController.workWaitingSwitch.isOn))
        
        // 3. send an user interaction programatically
        viewController.viewDidAppear(false)
        viewController.loadingTypeSwitch.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .updateIsLoadingStop(viewController.loadingTypeSwitch.isOn))
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceCreationSummaryViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceUnit: DummyModel.serviceUnitCreationModel,
            mode: .create,
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationSummaryViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = reactor.initialState
        
        // 4. assert view properties
        let serviceUnit = state.serviceUnit
        XCTAssertEqual(viewController.stopLabel.text, serviceUnit.stop?.name)
        XCTAssertEqual(viewController.workWaitingSwitchContainer.isHidden, serviceUnit.isWorkWaiting == nil)
        XCTAssertEqual(viewController.loadingTypeSwitchContainer.isHidden, serviceUnit.isLoadingStop == nil)
        XCTAssertEqual(viewController.workWaitingSwitch.isOn, serviceUnit.isWorkWaiting)
        XCTAssertEqual(viewController.loadingTypeSwitch.isOn, serviceUnit.isLoadingStop)
        XCTAssertEqual(viewController.loadingTypeSwitchStateLabel.text, serviceUnit.isLoadingStop == true ? "상차": "하차")
        XCTAssertEqual(viewController.detailTextView.text, serviceUnit.detail)
        XCTAssertEqual(viewController.receiverLabel.text, serviceUnit.receivers.map(\.name).joined(separator: "\n"))
        XCTAssertEqual(viewController.receiverListContainer.isHidden, serviceUnit.receivers.isEmpty)
    }
}
