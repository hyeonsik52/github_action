//
//  PagingCreatedServicesViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class PagingCreatedServicesViewReactor: Reactor {
    
    enum SectionType {
        case processing
        case completed
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refresh
        case moreCompleted(Int)  //last item
//        case notification(Result<ServiceBySwsIdxSubscriptionSubscription.Data, Error>)
//        case hiddenNotification(Result<HiddenServiceSubscriptionSubscription.Data, Error>)
    }
    
    enum Mutation {
        case refreshProcessing([ServiceCellReactor])
        case refreshCompleted([ServiceCellReactor])
        case moreCompleted([ServiceCellReactor])
        ///필터링에 의해 추가 로드가 되지 않은 경우 다시 시도 플래그
        case notFoundCompleted
        
//        case addService(SectionType, [ServiceCellReactor])
//        case updateService(SectionType, ServiceCellReactor)
//        case deleteService(SectionType, Int) //serviceIdx
        
        ///초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case processingIsLoading(Bool?)
        case completedIsLoading(Bool?)
        
        ///추가 로딩
        case isProcessing(Bool?)
    }
    
    struct State {
        var sections: [ServiceModelSection]
        var processingIsLoading: Bool?
        var completedIsLoading: Bool?
        var isProcessing: Bool?
        var retryMoreCompleted: Bool
    }
    
    var initialState: State {
        
//        let dummyItems = self.provider.serviceManager
//            .dummyServices(1, serviceUnitCount: 3)
//            .map { ServiceCellReactor(mode: .homeSendedDetail, service: $0) }
        
        let sections: [ServiceModelSection] = [
            .init(header: "진행 중 서비스", items: []),
            .init(header: "완료된 서비스", items: [])
        ]
        
        return State(
            sections: sections,
            processingIsLoading: nil,
            completedIsLoading: nil,
            isProcessing: nil,
            retryMoreCompleted: false
        )
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    private let countPerLoading = 5
    
    private var startCursor: String?
    private var hasPreviousPage: Bool = true
    
    private var lastItem = -1
    
    private let refDate = Date()
    
    init(provider: ManagerProviderType, swsIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.bind()
    }
    
    private func bind() {
        
//        self.provider.subscriptionManager.service(by: self.swsIdx)
//            .subscribe(onNext: { [weak self] result in
//                self?.action.onNext(.notification(result))
//            })
//            .disposed(by: self.disposeBag)
//
//        self.provider.subscriptionManager.hiddenService()
//            .subscribe(onNext: { [weak self] result in
//                self?.action.onNext(.hiddenNotification(result))
//            })
//            .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return .concat([
                .just(.processingIsLoading(true)),
                .just(.completedIsLoading(true)),
                self.refresh(.processing),
                .just(.processingIsLoading(false)),
                self.refresh(.completed),
                .just(.completedIsLoading(false))
            ])
        case .moreCompleted(let item):
            guard self.currentState.completedIsLoading == false else { return .empty() }
            
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
                self.moreCompleted(item),
                .just(.isProcessing(false))
            ])
//        case .notification(let result):
//            return self.subscription(result)
//        case .hiddenNotification(let result):
//            return self.subscription(result)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .refreshProcessing(let services):
            state.sections[0].items = services
        case .refreshCompleted(let services):
            state.sections[1].items = services
        case .moreCompleted(let services):
            state.sections[1].items.append(contentsOf: services)
            state.sections[1].items.sort(by: { self.sort(.completed, $0, $1) })
//        case let .addService(type, services):
//            state = self.addServices(type, state: state, data: services)
//        case let .updateService(type, service):
//            state = self.updateServices(type, state: state, data: service)
//        case let .deleteService(type, serviceIdx):
//            state = self.deleteServices(type, state: state, serviceIdx: serviceIdx)
        case .processingIsLoading(let isLoading):
            state.processingIsLoading = isLoading
        case .completedIsLoading(let isLoading):
            state.completedIsLoading = isLoading
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .notFoundCompleted:
            state.retryMoreCompleted = !state.retryMoreCompleted
        }
        return state
    }
}

extension PagingCreatedServicesViewReactor {
        
    private func refresh(_ type: SectionType) -> Observable<Mutation> {
        
//        let query = CreatedServicesConnectionQuery(swsIdx: self.swsIdx, phase: nil, status: nil, before: nil)
//        switch type {
//        case .processing:
//            query.status = [.moving, .stop, .working, .pause]
//            //진행 중 서비스를 모두 가져옴
//            query.last = 2147483647
//        case .completed:
//            query.status = [.completed, .canceledOnReady, .canceledOnWorking, .error]
//            //완료된 서비스는 페이징을 위해 제한된 개수만 가져옴
//            query.last = self.countPerLoading
//        }
//
//        return self.provider.networkManager.fetch(query)
//            .do(onNext: { [weak self] data in
//                if case .completed = type {
//                    let pageInfo = data.createdServicesConnection.pageInfo
//                    self?.startCursor = pageInfo.startCursor
//                    self?.hasPreviousPage = (pageInfo.hasPreviousPage == "1")
//                    self?.lastItem = -1
//                }
//            })
//            .map { self.convert(type, data: $0) }
//            .map {
//                switch type {
//                case .processing:
//                    return .refreshProcessing($0)
//                case .completed:
//                    return .refreshCompleted($0)
//                }
//        }
    }
    
    private func moreCompleted(_ item: Int) -> Observable<Mutation> {
        
//        let query = CreatedServicesConnectionQuery(
//            swsIdx: self.swsIdx,
//            phase: nil,
//            status: [.completed, .canceledOnReady, .canceledOnWorking, .error],
//            before: self.startCursor,
//            last: self.countPerLoading
//        )
//
//        return self.provider.networkManager.fetch(query)
//            .do(onNext: { [weak self] data in
//                let pageInfo = data.createdServicesConnection.pageInfo
//                self?.startCursor = pageInfo.startCursor
//                self?.hasPreviousPage = (pageInfo.hasPreviousPage == "1")
//            })
//            .map { self.convert(.completed, data: $0) }
//            .map { [weak self] in
//                if $0.isEmpty {
//                    self?.lastItem -= 1
//                    return .notFoundCompleted
//                }else{
//                    return .moreCompleted($0)
//                }
//            }
    }

//    private func subscription(_ result: Result<ServiceBySwsIdxSubscriptionSubscription.Data, Error>) -> Observable<Mutation> {
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
//
//    private func subscription(_ result: Result<HiddenServiceSubscriptionSubscription.Data, Error>) -> Observable<Mutation> {
//        switch result {
//        case .success(let data):
//            let subscription = data.hiddenServiceSubscription
//            if let service = subscription?.asService {
//                return .from([
//                    .deleteService(.processing, service.serviceIdx),
//                    .deleteService(.completed, service.serviceIdx)
//                ])
//            }
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//        return .empty()
//    }
}

extension PagingCreatedServicesViewReactor {

//    private func convert(_ type: SectionType, data: CreatedServicesConnectionQuery.Data) -> [ServiceCellReactor] {
//
//        let services = data.createdServicesConnection.edges.compactMap { $0.node }
//            .map{ ServiceModel($0, with: self.provider.serviceManager) }
//
//        return self.convert(type, data: services)
//    }
//
//    private func convert(_ type: SectionType, data: ServiceType) -> [ServiceCellReactor] {
//
//        let service = ServiceModel(data, with: self.provider.serviceManager)
//
//        return self.convert(type, data: [service])
//    }
//
//    private func convert(_ type: SectionType, data: [ServiceModel]) -> [ServiceCellReactor] {
//        return data
//            ///내가 생성한 서비스만 보여줌
//            .filter { $0.creator.isMe }
//            .filter {
//                switch type {
//                case .processing:
//                    return $0.isProcessing
//                case .completed:
//                    return $0.isCompleted
//                }
//            }
//            .map{
//                ServiceCellReactor(
//                    mode: .managementCreated,
//                    service: $0
//                )
//            }
//            .sorted { [weak self] in self?.sort(type, $0, $1) ?? false }
//    }
//
    private func sort(_ type: SectionType, _ lhs: ServiceCellReactor, _ rhs: ServiceCellReactor) -> Bool {
        switch type {
        case .processing:
            return lhs.currentState.service.beginAt ?? self.refDate > rhs.currentState.service.beginAt ?? self.refDate
        case .completed:
            return lhs.currentState.service.endAt ?? self.refDate > rhs.currentState.service.endAt ?? self.refDate
        }
    }
}

//extension PagingCreatedServicesViewReactor {
//
//    private func addServices(_ type: SectionType, state: State, data: [ServiceCellReactor]) -> State {
//        var state = state
//        for reactor in data {
//            switch type {
//            case .processing:
//                state.sections[0].items.insert(reactor, at: 0)
//                state.sections[0].items.sort(by: { self.sort(type, $0, $1) })
//            case .completed:
//                state.sections[1].items.insert(reactor, at: 0)
//                state.sections[1].items.sort(by: { self.sort(type, $0, $1) })
//            }
//        }
//        return state
//    }
//
//    private func updateServices(_ type: SectionType, state: State, data: ServiceCellReactor) -> State {
//        var state = state
//        let serviceIdx = data.currentState.service.serviceIdx
//        switch type {
//        case .processing:
//            if let index = state.sections[0].items.firstIndex(where: { $0.currentState.service.serviceIdx == serviceIdx }) {
//                state.sections[0].items[index] = data
//            }
//        case .completed:
//            if let index = state.sections[1].items.firstIndex(where: { $0.currentState.service.serviceIdx == serviceIdx }) {
//                state.sections[1].items[index] = data
//            }
//        }
//        return state
//    }
//
//    private func deleteServices(_ type: SectionType, state: State, serviceIdx: Int) -> State {
//        var state = state
//        switch type {
//        case .processing:
//            state.sections[0].items.removeAll { $0.currentState.service.serviceIdx == serviceIdx }
//        case .completed:
//            state.sections[1].items.removeAll { $0.currentState.service.serviceIdx == serviceIdx }
//        }
//        return state
//    }
//}
