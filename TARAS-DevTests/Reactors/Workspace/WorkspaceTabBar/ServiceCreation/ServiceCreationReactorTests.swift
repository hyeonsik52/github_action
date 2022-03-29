//
//  ServiceCreationReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/28.
//

import XCTest
@testable import TARAS_Dev

class ServiceCreationReactorTests: XCTestCase {
    
    var provider: ManagerProviderType!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.provider = MockManagerProvider()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.provider = nil
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = ServiceCreationViewReactor(
            provider: self.provider,
            workspaceId: DummyModel.id,
            process: try DummyModel.serviceTemplateProcess_general()
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = ServiceCreationViewController()
        viewController.reactor = reactor
        viewController.viewDidLoad()
        
        // 3. set a stub state
        let state = ServiceCreationViewReactor.State(
            serviceUnits: [DummyModel.serviceUnitCreationModel],
            isProcessing: false,
            isRequestSuccess: nil,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.collectionView.numberOfItems(inSection: 0), state.serviceUnits.count)
        XCTAssertEqual(viewController.requestButton.isEnabled, !state.serviceUnits.isEmpty && !state.isProcessing)
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
    }
}
