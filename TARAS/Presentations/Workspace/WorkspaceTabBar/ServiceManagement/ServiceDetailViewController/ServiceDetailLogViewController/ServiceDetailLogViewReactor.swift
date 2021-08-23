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
    
    private var countPerLoading: Int = 20
    
    private var serviceLogs = [ServiceLogModel]()
    
    private var startCursor: String?
    private var hasPreviousPage: Bool = true
    
    private var lastRow = -1
    
    enum Action {
        case refresh
        case loadMore(Int) // last row
    }
    
    enum Mutation {
        case refreshServiceLogs([ServiceLogModel])
        case addServiceLogs([ServiceLogModel])
        case isProcessing(Bool)
        case isLoading(Bool?)
    }
    
    struct State {
        var serviceLogs: [ServiceLogModel]
        var isProcessing: Bool
        var isLoading: Bool?
    }
    
    var initialState: State {
        return State(serviceLogs: [], isProcessing: false, isLoading: nil)
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    let serviceIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int, serviceIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceIdx = serviceIdx
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            self.startCursor = nil
        case .loadMore(let lastRow):
            guard self.currentState.isLoading == false else { return .empty() }
            if lastRow > self.lastRow {
                self.lastRow = lastRow
                if !self.hasPreviousPage {
                    print("🏆 loadedAll")
                    return .empty()
                }
            }else{
                print("🏆 pass")
                return .empty()
            }
        }

        print("🏆 begin", self.startCursor ?? "")
        
        let query = ServiceLogsByServiceIdxConnectionQuery(
            swsIdx: self.swsIdx,
            serviceIdx: self.serviceIdx,
            before: self.startCursor,
            last: self.countPerLoading
        )
        
        func loadingState(_ flag: Bool) -> Observable<Mutation> {
            switch action {
            case .refresh:
                return .just(.isLoading(flag))
            case .loadMore:
                return .just(.isProcessing(flag))
            }
        }
        
        return .concat([
            loadingState(true),
           self.provider.networkManager
                .fetch(query)
                .do(onNext: { [weak self] data in
                    let pageInfo = data.serviceLogsByServiceIdxConnection.pageInfo
                    self?.startCursor = pageInfo.startCursor
                    self?.hasPreviousPage = (pageInfo.hasPreviousPage == "1")
                    self?.lastRow = 0
                    print("🏆 end", self?.startCursor ?? "")
                })
                .map { $0.serviceLogsByServiceIdxConnection.edges.compactMap{$0.node} }
                .map { $0.compactMap(ServiceLogModel.init) }
                .map {
                    switch action {
                    case .refresh:
                        return Mutation.refreshServiceLogs($0)
                    case .loadMore:
                        return Mutation.addServiceLogs($0)
                    }
            },
            loadingState(false)
        ])
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .refreshServiceLogs(services):
            state.serviceLogs = services.sorted { $0.serviceLogIdx > $1.serviceLogIdx }
        case let .addServiceLogs(services):
            state.serviceLogs.append(contentsOf: services.sorted { $0.serviceLogIdx > $1.serviceLogIdx })
        case .isProcessing(let processing):
            state.isProcessing = processing
        case .isLoading(let loading):
            state.isLoading = loading
        }
        return state
    }
}
