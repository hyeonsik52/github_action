//
//  DefaultMyInfoReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/28.
//

import XCTest
@testable import TARAS_Dev

class DefaultMyInfoReactorTests: XCTestCase {
    
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
        let reactor = DefaultMyInfoViewReactor(provider: self.provider)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = DefaultMyInfoViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewWillAppear(false)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .reload)
        
        viewController.reactor?.action.onNext(.logout)
        XCTAssertEqual(reactor.stub.actions.last, .logout)
        
        // 3. send an user interaction programatically
        viewController.refreshControl.sendActions(for: .valueChanged)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .reload)
        
        viewController.reactor?.action.onNext(.resign)
        XCTAssertEqual(reactor.stub.actions.last, .resign)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = DefaultMyInfoViewReactor(provider: self.provider)
        reactor.isStubEnabled = true
        
        // 2. prepare a view with a stub reactor
        let viewController = DefaultMyInfoViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let account = DummyModel.account_basic
        let latestVersion = Version.thisAppVersion
        let state = DefaultMyInfoViewReactor.State(
            account: account,
            version: (latestVersion.currentVersion, true),
            isLogout: nil,
            isResign: nil,
            isLoading: false,
            isProcessing: false,
            errorMessage: nil
        )
        reactor.stub.state.value = state

        // 4. assert view properties
        XCTAssertEqual(viewController.idCellView.detailLabel.text, account.id)
        XCTAssertEqual(viewController.nameCellView.detailLabel.text, account.name)
        XCTAssertEqual(viewController.emailCellView.detailLabel.text, account.email)
        XCTAssertEqual(viewController.phoneNumberCellView.detailLabel.text, account.phoneNumber)
        
        XCTAssertEqual(viewController.versionCellView.detailLabel.text, latestVersion.currentVersion)
        XCTAssertEqual(viewController.versionCellView.arrowImageView.isHidden, true)
        
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isProcessing)
        XCTAssertEqual(viewController.refreshControl.isRefreshing, state.isLoading)
    }
}
