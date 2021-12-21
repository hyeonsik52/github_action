//
//  PagingReceivedServicesViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class PagingReceivedServicesViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refresh
        case more(Int)  //last item
        //temp
//        case notification(Result<ServicesByWorkspaceIdSubscription.Data, Error>)
    }
    
    enum Mutation {
        case refresh([ServiceCellReactor])
        case more([ServiceCellReactor])
        ///필터링에 의해 추가 로드가 되지 않은 경우 다시 시도 플래그
        case notFoundCompleted
        
        //temp
//        case addService([ServiceCellReactor])
//        case updateService(ServiceCellReactor)
//        case deleteService(String) //serviceId
        
        ///초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case isLoading(Bool?)
        
        ///추가 로딩
        case isProcessing(Bool?)
    }
    
    struct State {
        var sections: [ServiceModelSection]
        var isLoading: Bool?
        var isProcessing: Bool?
        var retryMore: Bool
    }
    
    var initialState: State {
        
//        let dummyItems = self.provider.serviceManager
//            .dummyServices(1, serviceUnitCount: 3)
//            .map { ServiceCellReactor(mode: .managementReceived, service: $0) }
        
        let sections: [ServiceModelSection] = [
            .init(header: "", items: [])
        ]
        
        return State(
            sections: sections,
            isLoading: nil,
            isProcessing: nil,
            retryMore: false
        )
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    
    private let countPerLoading = 5
    
    private var startCursor: String?
    private var hasPreviousPage: Bool = true
    
    private var lastItem = -1
    
    private let refDate = Date()
    
    init(provider: ManagerProviderType, workspaceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.bind()
    }
    
    private func bind() {
        
        //temp
//        self.provider.subscriptionManager.services(by: self.workspaceId)
//            .subscribe(onNext: { [weak self] result in
//                self?.action.onNext(.notification(result))
//            })
//            .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return .concat([
                .just(.isLoading(true)),
                self.refresh(),
                .just(.isLoading(false))
            ])
        case .more(let item):
            guard self.currentState.isLoading == false else { return .empty() }
            
            if item > self.lastItem {
                self.lastItem = item
                if !self.hasPreviousPage {
                    return .empty()
                }
            }else{
                return .empty()
            }
            
            return .concat([
                .just(.isProcessing(true)),
                self.more(item),
                .just(.isProcessing(false))
            ])
            //temp
//        case .notification(let result):
//            return self.subscription(result)
//        case .hiddenNotification(let result):
//            return self.subscription(result)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .refresh(let services):
            state.sections[0].items = services
        case .more(let services):
            state.sections[0].items.append(contentsOf: services)
            //temp
//            state.sections[0].items.sort(by: { self.sort($0, $1) })
//        case let .addService(services):
//            state = self.addServices(state: state, data: services)
//        case let .updateService(service):
//            state = self.updateServices(state: state, data: service)
//        case let .deleteService(serviceId):
//            state = self.deleteServices(state: state, serviceId: serviceId)
        case .isLoading(let isLoading):
            state.isLoading = isLoading
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .notFoundCompleted:
            state.retryMore = !state.retryMore
        }
        return state
    }
}

extension PagingReceivedServicesViewReactor {
        
    private func refresh() -> Observable<Mutation> {
        
        //temp
//        let query = ServicesQuery(
//            workspaceId: self.workspaceId,
////            phase: nil,
//            before: nil,
//            last: 2147483647
//        )
//        return self.provider.networkManager.fetch(query)
//            .do(onNext: { [weak self] data in
//                guard let pageInfo = data.hiGlovisServices?.pageInfo else { return }
//                self?.startCursor = pageInfo.startCursor
//                self?.hasPreviousPage = pageInfo.hasPreviousPage
//                self?.lastItem = -1
//            })
//            .map { self.convert($0) }
//            .map { .refresh($0) }
        return .empty()
    }
    
    private func more(_ item: Int) -> Observable<Mutation> {
        
        //temp
//        let query = ServicesQuery(
//            workspaceId: self.workspaceId,
////            phase: nil,
//            before: self.startCursor,
//            last: self.countPerLoading
//        )
//
//        return self.provider.networkManager.fetch(query)
//            .do(onNext: { [weak self] data in
//                guard let pageInfo = data.hiGlovisServices?.pageInfo else { return }
//                self?.startCursor = pageInfo.startCursor
//                self?.hasPreviousPage = pageInfo.hasPreviousPage
//            })
//            .map { self.convert($0) }
//            .map { .more($0) }
        return .empty()
    }
    
    //temp
//    private func subscription(_ result: Result<ServicesByWorkspaceIdSubscription.Data, Error>) -> Observable<Mutation> {
//        switch result {
//        case .success(let data):
//        let subscription = data.serviceBySwsIdxSubscription
//        if let created = subscription?.asServiceCreated?.item {
//
//            var mutations = [Mutation]()
//
//            let processing = self.convert(.processing, data: created)
//
//                for item in processing {
//                    let itemServiceIdx = item.currentState.service.serviceIdx
//
//                    if self.currentState.sections[0].items.contains(where: { $0.currentState.service.serviceIdx == itemServiceIdx }) {
//                        //이미 존재하면 업데이트
//                        mutations.append(.updateService(.processing, item))
//                    }else{
//                        //같은 항목이 없다면 추가
//                        mutations.append(.addService(.processing, [item]))
//                    }
//                }
//
//            return (mutations.isEmpty ? .empty(): .concat(mutations.map {.just($0)}))
//
//        }else if let updated = subscription?.asServiceUpdated?.item {
//
//            var mutations = [Mutation]()
//
//            let processing = self.convert(.processing, data: updated)
//            let completed = self.convert(.completed, data: updated)
//
//            //갱신된 서비스 인덱스가 필터링 된 진행 중 목록에 있다면 추가 또는 업데이트
//            if processing.isEmpty {
//                //없다면 목록에서 삭제
//                mutations.append(.deleteService(.processing, updated.serviceIdx))
//            }else{
//                for item in processing {
//                    let itemServiceIdx = item.currentState.service.serviceIdx
//
//                    if self.currentState.sections[0].items.contains(where: { $0.currentState.service.serviceIdx == itemServiceIdx }) {
//                        //이미 존재하면 업데이트
//                        mutations.append(.updateService(.processing, item))
//                    }else{
//                        //같은 항목이 없다면 추가
//                        mutations.append(.addService(.processing, [item]))
//                    }
//                }
//            }
//
//            //갱신된 서비스 인덱스가 필터링 된 수락된 목록에 있다면 추가 또는 업데이트
//            if completed.isEmpty {
//                //없다면 목록에서 삭제
//                mutations.append(.deleteService(.completed, updated.serviceIdx))
//            }else{
//                for item in completed {
//                    let itemServiceIdx = item.currentState.service.serviceIdx
//
//                    if self.currentState.sections[1].items.contains(where: { $0.currentState.service.serviceIdx == itemServiceIdx }) {
//                        //이미 존재하면 업데이트
//                        mutations.append(.updateService(.completed, item))
//                    }else{
//                        //같은 항목이 없다면 추가
//                        mutations.append(.addService(.completed, [item]))
//                    }
//                }
//            }
//
//            return (mutations.isEmpty ? .empty(): .from(mutations))
//
//        }else if let deleted = subscription?.asServiceDeleted {
//            return .from([
//                .deleteService(.processing, deleted.serviceIdx),
//                .deleteService(.completed, deleted.serviceIdx)
//            ])
//        }
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//        return .empty()
//    }
}

//temp
//extension PagingReceivedServicesViewReactor {
    
    //temp
//    private func convert(_ data: ServicesQuery.Data) -> [ServiceCellReactor] {
//        guard let services = data.hiGlovisServices?.edges
//            .compactMap(\.?.node?.fragments.serviceFragment)
//                .compactMap(self.provider.serviceManager.convert) else { return [] }
//        return self.convert(services)
//    }
//
//    private func convert(_ data: ServiceFragment) -> [ServiceCellReactor] {
//        guard let service = self.provider.serviceManager.convert(service: data) else { return [] }
//        return self.convert([service])
//    }
//
//    private func convert(_ data: [Service]) -> [ServiceCellReactor] {
//        return data
//            .map{
//                ServiceCellReactor(
//                    mode: .managementReceived,
//                    service: $0
//                )
//            }
//            .sorted { [weak self] in self?.sort($0, $1) ?? false }
//    }
//
//    private func sort(_ lhs: ServiceCellReactor, _ rhs: ServiceCellReactor) -> Bool {
//        return lhs.currentState.service.createdAt > rhs.currentState.service.createdAt
//    }
//}

//extension PagingReceivedServicesViewReactor {
//
//    private func addServices(state: State, data: [ServiceCellReactor]) -> State {
//        var state = state
//        for reactor in data {
//            state.sections[0].items.insert(reactor, at: 0)
//            state.sections[0].items.sort(by: { self.sort($0, $1) })
//        }
//        return state
//    }
//
//    private func updateServices(state: State, data: ServiceCellReactor) -> State {
//        var state = state
//        let serviceId = data.currentState.service.id
//        if let index = state.sections[0].items.firstIndex(where: { $0.currentState.service.id == serviceId }) {
//            state.sections[0].items[index] = data
//        }
//        return state
//    }
//
//    private func deleteServices(state: State, serviceId: String) -> State {
//        var state = state
//        state.sections[0].items.removeAll { $0.currentState.service.id == serviceId }
//        return state
//    }
//}
