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

class SubscriptionManager: BaseManager {
    
    private var observables = [String: Any]()
    private let lock = NSLock()
}

extension SubscriptionManager: SubscriptionManagerType {
    
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


extension SubscriptionManagerType {
    
    /// 내가 수신한 서비스 변화(생성, 수정, 삭제) 구독
    public func services(by workspaceId: String) -> Observable<Result<ServicesByWorkspaceIdSubscription.Data, Error>> {
        return self.subscribe(ServicesByWorkspaceIdSubscription(workspaceId: workspaceId))
    }

    /// 특정 서비스 구독 (진행중 서비스 상세 화면)
    public func service(by serviceId: String) -> Observable<Result<ServiceByServiceIdSubscription.Data, Error>> {
        return self.subscribe(ServiceByServiceIdSubscription(serviceId: serviceId))
    }

//    /// 특정 서비스의 서비스 로그(생성,수정,삭제) 구독 (로그 화면)
//    public func serviceLog(_ serviceIdx: Int) -> Observable<Result<ServiceLogSubscription.Data, Error>> {
//        return self.subscribe(ServiceLogSubscription(serviceIdx: serviceIdx))
//    }
}
