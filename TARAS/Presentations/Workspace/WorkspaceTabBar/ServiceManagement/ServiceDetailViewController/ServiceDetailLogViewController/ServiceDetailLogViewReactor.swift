//
//  ServiceDetailLogViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class ServiceDetailLogViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    private var serviceLogs = [ServiceLog]()
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case refreshServiceLogs([ServiceLog])
        case addServiceLogs([ServiceLog])
        case isLoading(Bool?)
    }
    
    struct State {
        var serviceLogs: [ServiceLog]
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(serviceLogs: [], isLoading: nil)
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    let serviceId: String
    
    init(provider: ManagerProviderType, workspaceId: String, serviceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceId = serviceId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.isLoading(true)),
                //temp
//                self.provider.networkManager.fetch(ServiceQuery(serviceId: self.serviceId))
//                    .compactMap { $0.hiGlovisServiceByOrderId?.fragments.serviceFragment.timestamps }
//                    .compactMap { $0.data(using: .utf8) }
//                    .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .allowFragments) }
//                    .compactMap { $0 as? [String: Any] }
//                    .compactMap { self.provider.serviceManager.convert(log: $0) }
//                    .map { .refreshServiceLogs([$0]) },
                .just(.isLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .refreshServiceLogs(services):
            state.serviceLogs = services.sorted { $0.date > $1.date }
        case let .addServiceLogs(services):
            state.serviceLogs.append(contentsOf: services.sorted { $0.date > $1.date })
        case .isLoading(let loading):
            state.isLoading = loading
        }
        return state
    }
}
