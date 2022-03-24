//
//  SubscriptionManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo
import RxSwift

protocol SubscriptionManagerType: AnyObject {
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>>
}

class SubscriptionManager: BaseManager, SubscriptionManagerType {
    
    private(set) var observables = [String: Any]()
    private let lock = NSLock()
    
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>> {
        lock.lock(); defer { lock.unlock() }
        
        let key = subscription.key
        if let existed = observables[key] {
            Log.debug("✴️ \(key) [existed]")
            return existed as! Observable<Result<T.Data, Error>>
        }else{
            Log.debug("✴️ \(key) [new]")
            let new = self.provider.networkManager.subscribe(subscription).share()
            observables[key] = new
            return new
        }
    }
}
