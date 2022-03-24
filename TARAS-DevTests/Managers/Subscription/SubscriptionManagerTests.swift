//
//  SubscriptionManagerTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import XCTest
@testable import TARAS_Dev
import RxSwift
import Apollo

class SubscriptionManagerTests: XCTestCase {

    let provider = MockManagerProvider()
    lazy var subscriptionManager = self.provider.subscriptionManager as! MockSubscriptionManager
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubscribe() throws {
        
        let expectFirst = expectation(description: "first")
        self.subscriptionManager.subscribe(MockGraphQLSubscription())
            .subscribe(onNext: { result in
                if case .success(let data) = result,
                   let type = data.resultMap["operationType"] as? GraphQLOperationType,
                   type == .subscription {
                    expectFirst.fulfill()
                }
            }).disposed(by: self.disposeBag)
        
        let expectSecond = expectation(description: "second")
        self.subscriptionManager.subscribe(MockGraphQLSubscription())
            .subscribe(onNext: { result in
                if case .success(let data) = result,
                   let type = data.resultMap["operationType"] as? GraphQLOperationType,
                   type == .subscription {
                    expectSecond.fulfill()
                }
            }).disposed(by: self.disposeBag)
        
        waitForExpectations(timeout: 2)
        
        XCTAssertEqual(self.subscriptionManager.observables.count, 1)
    }
}
