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
    public func services(by workspaceId: String) -> Observable<ServiceByWorkspaceIdSubscription.Data.SubscribeServiceChangeset> {
        //temp: 서버가 느려지는 현상이 있어, 임시 비활성
        return .empty()
//        return self.subscribe(ServiceByWorkspaceIdSubscription(id: workspaceId))
//            .compactMap { result in
//                switch result {
//                case .success(let data):
//                    if let changeSet = data.subscribeServiceChangeset {
//                        return changeSet
//                    } else {
//                        Log.err("serviceSubscription error: not fount changeset")
//                    }
//                case .failure(let error):
//                    Log.err("serviceSubscription error: \(error.localizedDescription)")
//                }
//                return nil
//            }
    }

    /// 특정 서비스 구독 (진행중 서비스 상세 화면)
    public func serviceBy(serviceId: String) -> Observable<Result<ServiceByIdSubscription.Data, Error>> {
        return self.subscribe(ServiceByIdSubscription(id: serviceId))
    }
}
