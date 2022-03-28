//
//  WorkspaceSearchResultReactorTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/28.
//

import XCTest
@testable import TARAS_Dev

class WorkspaceSearchResultReactorTests: XCTestCase {
    
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
        let reactor = WorkspaceSearchResultViewReactor(
            provider: self.provider,
            workspaceCode: MockModel.workspaceCode
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceSearchResultViewController()
        viewController.reactor = reactor
        
        // 3. send an user interaction programatically
        viewController.viewDidLoad()
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .refresh)

        // 3. send an user interaction programatically
        viewController.resultView.enterButton.sendActions(for: .touchUpInside)
        // 4. assert actions
        XCTAssertEqual(reactor.stub.actions.last, .request)
        
        
        let state = WorkspaceSearchResultViewReactor.State(
            workspace: MockModel.workspace_basic,
            isLoading: false,
            result: true,
            errorMessage: nil
        )
        reactor.stub.state.accept(state)
        XCTAssertEqual(reactor.stub.actions.last, .refresh)
    }
    
    func testStates() throws {
        
        // 1. prepare a stub reactor
        let reactor = WorkspaceSearchResultViewReactor(
            provider: self.provider,
            workspaceCode: MockModel.workspaceCode
        )
        reactor.isStubEnabled = true

        // 2. prepare a view with a stub reactor
        let viewController = WorkspaceSearchResultViewController()
        viewController.reactor = reactor

        // 3. set a stub state
        let state = WorkspaceSearchResultViewReactor.State(
            workspace: MockModel.workspace_only,
            isLoading: false,
            result: nil,
            errorMessage: nil
        )
        reactor.stub.state.value = state
        
        // 4. assert view properties
        XCTAssertEqual(viewController.resultView.isHidden, state.workspace == nil)
        
        XCTAssertEqual(viewController.resultView.nameLabel.text, state.workspace?.name)
        XCTAssertEqual(viewController.resultView.createdAtLabel.text, state.workspace?.createdAt.toString("yy.MM.dd 생성"))
        XCTAssertEqual(viewController.resultView.memberCountLabel.text, "회원 \(state.workspace?.memberCount ?? -1)명")
        
        XCTAssertEqual(viewController.resultView.guideLabel.text, WorkspaceSearchResultView.Text.WSSRV_2)
        XCTAssertEqual(viewController.resultView.enterButton.title(for: .normal), WorkspaceSearchResultView.Text.WSSRV_4)
        
        XCTAssertEqual(viewController.activityIndicatorView.isAnimating, state.isLoading)
    }
}
