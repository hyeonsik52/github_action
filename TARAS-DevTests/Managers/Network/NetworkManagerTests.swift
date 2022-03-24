//
//  NetworkManagerTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/23.
//

import XCTest
@testable import TARAS_Dev
import RxSwift
import Apollo

class NetworkManagerTests: XCTestCase {

    let networkManager = MockManagerProvider().networkManager as! MockNetworkManager
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGraphQL() throws {
        
        var type: GraphQLOperationType?
        
        
        let expect1 = expectation(description: "graphql-query")
        
        self.networkManager.fetch(MockGraphQLQuery())
            .subscribe(onNext: { data in
                type = data.resultMap["operationType"] as? GraphQLOperationType
            }, onCompleted: {
                expect1.fulfill()
            }).disposed(by: self.disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(type == .query)
        
        
        let expect2 = expectation(description: "graphql-mutation")
        
        self.networkManager.perform(MockGraphQLMutation(input: .init(value: "test")))
            .subscribe(onNext: { data in
                type = data.resultMap["operationType"] as? GraphQLOperationType
            }, onCompleted: {
                expect2.fulfill()
            }).disposed(by: self.disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(type == .mutation)
        
        
        let expect3 = expectation(description: "graphql-subscription")
        
        self.networkManager.subscribe(MockGraphQLSubscription())
            .subscribe(onNext: { result in
                if case .success(let data) = result {
                    type = data.resultMap["operationType"] as? GraphQLOperationType
                }
            }, onCompleted: {
                expect3.fulfill()
            }).disposed(by: self.disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(type == .subscription)
    }
    
    func testREST() throws {
        
        let expect = expectation(description: "rest")
        
        let request = MockRestAPI(input: MockRequestModel(test: "test"))
        var response: MockResponseModel?
        
        self.networkManager.call("POST", request)
            .as().response(MockResponseModel.self)
            .subscribe(onNext: { result in
                if case .success(let value) = result {
                    response = value
                }
            }, onCompleted: {
                expect.fulfill()
            }).disposed(by: self.disposeBag)
        
        waitForExpectations(timeout: 2)
        
        XCTAssertTrue(response?.test == "test")
    }
}
