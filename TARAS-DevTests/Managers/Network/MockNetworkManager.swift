//
//  MockNetworkManager.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import Foundation
@testable import TARAS_Dev
import RxSwift
import Apollo

class MockNetworkManager: BaseManager, NetworkManagerType {
    
    var updateWebSocketCallCount = 0
    var resisterFcmRegistered: Bool? = nil
    
    func fetch<T: GraphQLQuery>(_ query: T) -> Observable<T.Data> {
        return .just(try! .init(jsonObject: [:], variables: [:]))
    }
    
    func perform<T: GraphQLMutation>(_ mutation: T) -> Observable<T.Data> {
        return .just(try! .init(jsonObject: [:], variables: [:]))
    }
    
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>> {
        return .just(.success(try! .init(jsonObject: [:], variables: [:])))
    }
    
    func updateWebSocketTransportConnectingPayload() {
        self.updateWebSocketCallCount += 1
    }
    
    func postByRest<T: RestAPIResponse>(_ api: RestAPIType<T>) -> Observable<Result<T, RestError>> {
        return .just(.failure(.init(code: "test")))
    }
    
    func clientUpdateCheck() -> Observable<Error?> {
        return .just(nil)
    }
    
    func clientVersionCheck() -> Observable<Version?> {
        return .just(nil)
    }
    
    func registerFcmToken(with tokenSet: PushTokenSet, _ func: String) {
        self.resisterFcmRegistered = true
    }
    
    func registerFcmToken(auto func: String) {
        self.registerFcmToken(with: .init(), `func`)
    }
    
    func registerFcmToken<T>(auto func: String) -> Observable<T> {
        self.registerFcmToken(auto: `func`)
        return .empty()
    }
    
    func unregisterFcmToken() -> Observable<Bool> {
        self.resisterFcmRegistered = false
        return .just(self.resisterFcmRegistered ?? false)
    }
}
