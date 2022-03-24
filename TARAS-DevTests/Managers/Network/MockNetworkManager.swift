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
        return .create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                observer.onNext(.init(unsafeResultMap: ["operationType": query.operationType]))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func perform<T: GraphQLMutation>(_ mutation: T) -> Observable<T.Data> {
        return .create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                observer.onNext(.init(unsafeResultMap: ["operationType": mutation.operationType]))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>> {
        return .create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                observer.onNext(.success(.init(unsafeResultMap: ["operationType": subscription.operationType])))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func updateWebSocketTransportConnectingPayload() {
        self.updateWebSocketCallCount += 1
    }
}

extension MockNetworkManager: RESTSupport {
    
    func call(_ method: String, _ api: RestAPI) -> Observable<(HTTPURLResponse, Data)> {
        return .create { observer in
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) {
                let httpResponse = HTTPURLResponse(url: api.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                let data = try! JSONSerialization.data(withJSONObject: api.parameters, options: .fragmentsAllowed)
                observer.onNext((httpResponse, data))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
