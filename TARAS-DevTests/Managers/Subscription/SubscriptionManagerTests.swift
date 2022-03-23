//
//  SubscriptionManagerTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import XCTest
@testable import TARAS_Dev
import RxSwift
import RxBlocking

class SubscriptionManagerTests: XCTestCase {

    let subscriptionManager = MockManagerProvider().subscriptionManager as! MockSubscriptionManager
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubscribe() throws {
        
        let expectFirst = expectation(description: "first")
        self.subscriptionManager.services(by: "")
            .subscribe(onCompleted: {
                expectFirst.fulfill()
            }).disposed(by: self.disposeBag)
        
        wait(for: [expectFirst], timeout: 2)
        
        XCTAssertEqual(self.subscriptionManager.observables.count, 1)
        
        
        let expectSecond = expectation(description: "second")
        self.subscriptionManager.service(id: "")
            .subscribe(onCompleted: {
                expectSecond.fulfill()
            }).disposed(by: self.disposeBag)
        
        let expectThird = expectation(description: "third")
        self.subscriptionManager.service(id: "")
            .subscribe(onCompleted: {
                expectThird.fulfill()
            }).disposed(by: self.disposeBag)
        
        wait(for: [expectSecond, expectThird], timeout: 2)
        
        XCTAssertEqual(self.subscriptionManager.observables.count, 2)
    }
}
