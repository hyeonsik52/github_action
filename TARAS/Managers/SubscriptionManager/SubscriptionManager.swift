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
    public func services(
        by workspaceId: String
    ) -> Observable<[ServicesByWorkspaceIdSubscription.Data.ServiceChangeSet]> {
        return self.subscribe(ServicesByWorkspaceIdSubscription(id: .init(_eq: workspaceId)))
            .compactMap { result in
                switch result {
                case .success(let data):
                    let changeSets = data.serviceChangeSet
                    if changeSets.isEmpty {
                        Log.error("serviceSubscription error:", "not fount changeset")
                    } else {
                        return changeSets
                    }
                case .failure(let error):
                    Log.error("serviceSubscription error:", error.localizedDescription)
                }
                return nil
            }
    }
    
    /// 특정 서비스 구독 (진행중 서비스 상세 화면)
    public func service(
        by serviceId: String,
        with workspaceId: String
    ) -> Observable<Result<ServiceByIdSubscription.Data, Error>> {
        let subscription = ServiceByIdSubscription(
            id: .init(_eq: serviceId),
            workspaceId: .init(_eq: workspaceId))
        return self.subscribe(subscription)
    }
}
