//
//  MockSubscriptionManager.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import Foundation
@testable import TARAS_Dev
import Apollo
import RxSwift

class MockSubscriptionManager: BaseManager, SubscriptionManagerType {
    
    private lazy var original = SubscriptionManager(provider: self.provider)
    
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>> {
        return self.original.subscribe(subscription)
    }
    
    func services(by workspaceId: String) -> Observable<[ServicesByWorkspaceIdSubscription.Data.ServiceChangeSet]> {
        return .just([])
    }
    
    func service(id: String) -> Observable<Result<ServiceByIdSubscription.Data, Error>> {
        return .just(.success(.init(serviceTmp: [])))
    }
}
