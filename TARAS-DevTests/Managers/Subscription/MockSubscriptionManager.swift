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
    
    var observables = [String: Any]()
    
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>> {
        let key = subscription.key
        if let existed = observables[key] {
            Log.debug("✴️ \(key) [existed]")
            return existed as! Observable<Result<T.Data, Error>>
        }else{
            Log.debug("✴️ \(key) [new]")
            let new = Observable<Result<T.Data, Error>>.create { observer in
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            observables[key] = new
            return new
        }
    }
    
    func services(by workspaceId: String) -> Observable<[ServicesByWorkspaceIdSubscription.Data.ServiceChangeSet]> {
        return self.subscribe(ServicesByWorkspaceIdSubscription(
            id: workspaceId,
            userId: "",
            jsonFilter: try! .init(jsonValue: [:])
        )).map { (try? $0.get())?.serviceChangeSet ?? [] }
    }
    
    func service(id: String) -> Observable<Result<ServiceByIdSubscription.Data, Error>> {
        return self.subscribe(ServiceByIdSubscription(id: id))
    }
}
