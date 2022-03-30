//
//  ServiceDetailReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class ServiceDetailReactorTests: XCTestCase {
    
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
        let reactor = ServiceDetailViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceDetailViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewDidLoad()
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refreshService)
        
        // 3. send an user interaction programatically
        viewController.tableView.refreshControl?.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refreshService)
        
        // 3. send an user interaction programatically
        viewController.workCompletionButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .completeServiceUnit)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceDetailViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceDetailViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        //완료된 서비스
        let service = try DummyModel.service_basic()
        let state = ServiceDetailViewReactor.State(
            service: service,
            serviceUnitReactors: reactor.convertServiceUnitCellReactors(service),
            isLoading: false,
            isProcessing: nil,
            errorMessage: nil,
            isServiceUnitCompleted: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.title, state.service?.stateDescription)
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), state.serviceUnitReactors.count)
        XCTAssertEqual(viewController.refreshControl.isRefreshing, state.isLoading == true)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing == true)
        XCTAssertEqual(viewController.workCompletionButton.isEnabled, !(state.isProcessing == true) && !(state.isServiceUnitCompleted == true))
        XCTAssertEqual(viewController.errorContainer.isHidden, state.service?.phase != .canceled)
        XCTAssertEqual(viewController.errorLabel.text, state.service?.canceledDescription)
        XCTAssertEqual(viewController.completedTimeContainer.isHidden, state.service?.phase != .completed)
        XCTAssertEqual(viewController.completedTimeLabel.text, state.service?.finishedAt?.infoDateTimeFormatted)
        XCTAssertEqual(viewController.authNumberContainer.isHidden, state.service?.currentServiceUnit?.authNumber?.isEmpty ?? true)
        XCTAssertEqual(viewController.authNumberLabel.text, state.service?.currentServiceUnit?.authNumber)
        XCTAssertEqual(viewController.detailContainer.isHidden, state.service?.currentServiceUnit?.detail?.isEmpty ?? true)
        XCTAssertEqual(viewController.detailLabel.text, state.service?.currentServiceUnit?.detail)
        XCTAssertEqual(viewController.workCompletionButtonContainer.isHidden, true)
        XCTAssertEqual(viewController.headerContainer.isHidden, true)
    }
}
