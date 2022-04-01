//
//  ServiceBasicInfoReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/30.
//

import XCTest
@testable import TARAS_Dev

class ServiceBasicInfoReactorTests: XCTestCase {
    
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
        let reactor = ServiceBasicInfoViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceBasicInfoViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewDidLoad()
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
        
        // 3. send an user interaction programatically
        viewController.scrollView.refreshControl?.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceBasicInfoViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            serviceId: DummyModel.id
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceBasicInfoViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        //완료된 서비스
        let service = try DummyModel.service_basic()
        let state = ServiceBasicInfoViewReactor.State(
            service: service,
            isLoading: false
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.serviceNumberView.contentLabel.text, state.service?.serviceNumber)
        XCTAssertEqual(viewController.serviceCreatorView.contentLabel.text, state.service?.creator.displayName)
        XCTAssertEqual(viewController.serviceRequestAtView.contentLabel.text, state.service?.requestedAt.infoDateTimeFormatted)
        XCTAssertEqual(viewController.serviceBeginAtView.contentLabel.text, state.service?.startedAt?.infoDateTimeFormatted)
        XCTAssertEqual(viewController.serviceEndAtView.contentLabel.text, state.service?.finishedAt?.infoDateTimeFormatted)
        XCTAssertEqual(viewController.serviceTimeView.contentLabel.text, state.service?.startedAt?.infoReadableTimeTakenFromThis(to: state.service!.finishedAt!))
        XCTAssertEqual(viewController.serviceRobotMovingDistanceView.contentLabel.text, "\(Int(state.service!.travelDistance!))m")
        XCTAssertEqual(viewController.serviceRobotNameView.contentLabel.text, state.service?.robot?.name)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isLoading)
        XCTAssertEqual(viewController.scrollView.refreshControl?.isRefreshing, state.isLoading)
    }
}
