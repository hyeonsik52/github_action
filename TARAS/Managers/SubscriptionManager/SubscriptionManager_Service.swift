//
//  SubscriptionManager_Service.swift
//  TARAS
//
//  Created by nexmond on 2022/03/24.
//

import Foundation
import RxSwift

protocol ServiceSubscriptionSupport {
    func services(by workspaceId: String) -> Observable<[ServicesByWorkspaceIdSubscription.Data.ServiceChangeSet]>
    func service(id: String) -> Observable<Result<ServiceByIdSubscription.Data, Error>>
}

extension SubscriptionManager {
    
    /// 내가 수신한 서비스 변화(생성, 수정, 삭제) 구독
    public func services(by workspaceId: String) -> Observable<[ServicesByWorkspaceIdSubscription.Data.ServiceChangeSet]> {
        let userTb = self.provider.userManager.userTB
        guard let userId = userTb.ID, let userUsername = userTb.id else { return .empty() }
        return self.subscribe(ServicesByWorkspaceIdSubscription(id: workspaceId, userId: userId, jsonFilter: try! .init(jsonValue: ["id": userUsername])))
            .compactMap { result in
                switch result {
                case .success(let data):
                    let changeSets = data.serviceChangeSet
                    if changeSets.isEmpty {
                        Log.error("serviceSubscription error:", "not found changeset")
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
    public func service(id: String) -> Observable<Result<ServiceByIdSubscription.Data, Error>> {
        return self.subscribe(ServiceByIdSubscription(id: id))
    }
}
