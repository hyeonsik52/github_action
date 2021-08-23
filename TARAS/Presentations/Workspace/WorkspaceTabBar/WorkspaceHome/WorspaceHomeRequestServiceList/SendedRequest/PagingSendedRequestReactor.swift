//
//  PagingSendedRequestReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class PagingSendedRequestReactor: Reactor {
    
    enum SectionType {
        case preparing
        case canceled
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refresh
        case moreCanceled(Int)  //last item
        case notification(Result<ServiceBySwsIdxSubscriptionSubscription.Data, Error>)
        case hiddenNotification(Result<HiddenServiceSubscriptionSubscription.Data, Error>)
    }
    
    enum Mutation {
        case refreshPreparing([ServiceCellReactor])
        case refreshCanceled([ServiceCellReactor])
        case moreCanceled([ServiceCellReactor])
        ///필터링에 의해 추가 로드가 되지 않은 경우 다시 시도 플래그
        case notFoundCanceled
        
        case addService(SectionType, [ServiceCellReactor])
        case updateService(SectionType, ServiceCellReactor)
        case deleteService(SectionType, Int) //serviceIdx
        
        ///초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case preparingIsLoading(Bool?)
        case canceledIsLoading(Bool?)
        
        ///추가 로딩
        case isProcessing(Bool?)
    }
    
    struct State {
        var sections: [ServiceModelSection]
        var preparingIsLoading: Bool?
        var canceledIsLoading: Bool?
        var isProcessing: Bool?
        var retryMoreCanceled: Bool
    }
    
    var initialState: State {
        
        let dummyItems = self.provider.serviceManager
            .dummyServices(1, serviceUnitCount: 3)
            .map { ServiceCellReactor(mode: .homeSendedDetail, service: $0) }
        
        let sections: [ServiceModelSection] = [
            .init(header: "서비스 준비 중", items: dummyItems),
            .init(header: "취소된 서비스", items: dummyItems)
        ]
        
        return State(
            sections: sections,
            preparingIsLoading: nil,
            canceledIsLoading: nil,
            isProcessing: nil,
            retryMoreCanceled: false
        )
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    private let countPerLoading = 5
    
    private var startCursor: String?
    private var hasPreviousPage: Bool = true
    
    private var lastItem = -1
    
    init(provider: ManagerProviderType, swsIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.bind()
    }
    
    private func bind() {
        
        self.provider.subscriptionManager.service(by: self.swsIdx)
            .subscribe(onNext: { [weak self] result in
                self?.action.onNext(.notification(result))
            })
            .disposed(by: self.disposeBag)
        
        self.provider.subscriptionManager.hiddenService()
            .subscribe(onNext: { [weak self] result in
                self?.action.onNext(.hiddenNotification(result))
            })
            .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return .concat([
                .just(.preparingIsLoading(true)),
                .just(.canceledIsLoading(true)),
                self.refresh(.preparing),
                .just(.preparingIsLoading(false)),
                self.refresh(.canceled),
                .just(.canceledIsLoading(false))
            ])
        case .moreCanceled(let item):
            guard self.currentState.canceledIsLoading == false else { return .empty() }
            
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
                self.moreCanceled(item),
                .just(.isProcessing(false))
            ])
        case .notification(let result):
            return self.subscription(result)
        case .hiddenNotification(let result):
            return self.subscription(result)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .refreshPreparing(let services):
            state.sections[0].items = services
        case .refreshCanceled(let services):
            state.sections[1].items = services
        case .moreCanceled(let services):
            state.sections[1].items.append(contentsOf: services)
            state.sections[1].items.sort(by: self.sort)
        case let .addService(type, services):
            state = self.addServices(type, state: state, data: services)
        case let .updateService(type, service):
            state = self.updateServices(type, state: state, data: service)
        case let .deleteService(type, serviceIdx):
            state = self.deleteServices(type, state: state, serviceIdx: serviceIdx)
        case .preparingIsLoading(let isLoading):
            state.preparingIsLoading = isLoading
        case .canceledIsLoading(let isLoading):
            state.canceledIsLoading = isLoading
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .notFoundCanceled:
            state.retryMoreCanceled = !state.retryMoreCanceled
        }
        return state
    }
}

extension PagingSendedRequestReactor {
        
    private func refresh(_ type: SectionType) -> Observable<Mutation> {
        
        let query = CreatedServicesConnectionQuery(swsIdx: self.swsIdx, phase: .initiation, status: nil, before: nil)
        switch type {
        case .preparing:
            query.status = [.waitingResponse, .waitingRobotAssignment, .pause]
            //서비스 준비 중 서비스를 모두 가져옴
            query.last = 2147483647
        case .canceled:
            query.status = [.canceledOnWaiting, .pause]
            //취소된 서비스는 페이징을 위해 제한된 개수만 가져옴
            query.last = self.countPerLoading
        }
        
        return self.provider.networkManager.fetch(query)
            .do(onNext: { [weak self] data in
                if case .canceled = type {
                    let pageInfo = data.createdServicesConnection.pageInfo
                    self?.startCursor = pageInfo.startCursor
                    self?.hasPreviousPage = (pageInfo.hasPreviousPage == "1")
                    self?.lastItem = -1
                }
            })
            .map { self.convert(type, data: $0) }
            .map {
                switch type {
                case .preparing:
                    return .refreshPreparing($0)
                case .canceled:
                    return .refreshCanceled($0)
                }
        }
    }
    
    private func moreCanceled(_ item: Int) -> Observable<Mutation> {
        
        let query = CreatedServicesConnectionQuery(
            swsIdx: self.swsIdx,
            phase: .initiation,
            status: [.canceledOnWaiting, .pause],
            before: self.startCursor,
            last: self.countPerLoading
        )
        
        return self.provider.networkManager.fetch(query)
            .do(onNext: { [weak self] data in
                let pageInfo = data.createdServicesConnection.pageInfo
                self?.startCursor = pageInfo.startCursor
                self?.hasPreviousPage = (pageInfo.hasPreviousPage == "1")
            })
            .map { self.convert(.canceled, data: $0) }
            .map { [weak self] in
                if $0.isEmpty {
                    self?.lastItem -= 1
                    return .notFoundCanceled
                }else{
                    return .moreCanceled($0)
                }
            }
    }
        
    private func subscription(_ result: Result<ServiceBySwsIdxSubscriptionSubscription.Data, Error>) -> Observable<Mutation> {
        switch result {
        case .success(let data):
        let subscription = data.serviceBySwsIdxSubscription
        if let created = subscription?.asServiceCreated?.item {
            
            var mutations = [Mutation]()
            
            let preparing = self.convert(.preparing, data: created)
            
                for item in preparing {
                    let itemServiceIdx = item.currentState.service.serviceIdx
                    
                    if self.currentState.sections[0].items.contains(where: { $0.currentState.service.serviceIdx == itemServiceIdx }) {
                        //이미 존재하면 업데이트
                        mutations.append(.updateService(.preparing, item))
                    }else{
                        //같은 항목이 없다면 추가
                        mutations.append(.addService(.preparing, [item]))
                    }
                }
            
            return (mutations.isEmpty ? .empty(): .concat(mutations.map {.just($0)}))
            
        }else if let updated = subscription?.asServiceUpdated?.item {
            
            var mutations = [Mutation]()
            
            let preparing = self.convert(.preparing, data: updated)
            let canceled = self.convert(.canceled, data: updated)
            
            //갱신된 서비스 인덱스가 필터링 된 대기 중 목록에 있다면 추가 또는 업데이트
            if preparing.isEmpty {
                //없다면 목록에서 삭제
                mutations.append(.deleteService(.preparing, updated.serviceIdx))
            }else{
                for item in preparing {
                    let itemServiceIdx = item.currentState.service.serviceIdx
                    
                    if self.currentState.sections[0].items.contains(where: { $0.currentState.service.serviceIdx == itemServiceIdx }) {
                        //이미 존재하면 업데이트
                        mutations.append(.updateService(.preparing, item))
                    }else{
                        //같은 항목이 없다면 추가
                        mutations.append(.addService(.preparing, [item]))
                    }
                }
            }
            
            //갱신된 서비스 인덱스가 필터링 된 수락된 목록에 있다면 추가 또는 업데이트
            if canceled.isEmpty {
                //없다면 목록에서 삭제
                mutations.append(.deleteService(.canceled, updated.serviceIdx))
            }else{
                for item in canceled {
                    let itemServiceIdx = item.currentState.service.serviceIdx
                    
                    if self.currentState.sections[1].items.contains(where: { $0.currentState.service.serviceIdx == itemServiceIdx }) {
                        //이미 존재하면 업데이트
                        mutations.append(.updateService(.canceled, item))
                    }else{
                        //같은 항목이 없다면 추가
                        mutations.append(.addService(.canceled, [item]))
                    }
                }
            }
            
            return (mutations.isEmpty ? .empty(): .from(mutations))
            
        }else if let deleted = subscription?.asServiceDeleted {
            return .from([
                .deleteService(.preparing, deleted.serviceIdx),
                .deleteService(.canceled, deleted.serviceIdx)
            ])
        }
        case .failure(let error):
            print(error.localizedDescription)
        }
        return .empty()
    }
    
    private func subscription(_ result: Result<HiddenServiceSubscriptionSubscription.Data, Error>) -> Observable<Mutation> {
        switch result {
        case .success(let data):
            let subscription = data.hiddenServiceSubscription
            if let service = subscription?.asService {
                return .from([
                    .deleteService(.preparing, service.serviceIdx),
                    .deleteService(.canceled, service.serviceIdx)
                ])
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
        return .empty()
    }
}

extension PagingSendedRequestReactor {
    
    private func convert(_ type: SectionType, data: CreatedServicesConnectionQuery.Data) -> [ServiceCellReactor] {
        
        let services = data.createdServicesConnection.edges.compactMap { $0.node }
            .map{ ServiceModel($0, with: self.provider.serviceManager) }
        
        return self.convert(type, data: services)
    }
    
    private func convert(_ type: SectionType, data: ServiceType) -> [ServiceCellReactor] {
        
        let service = ServiceModel(data, with: self.provider.serviceManager)
        
        return self.convert(type, data: [service])
    }
    
    private func convert(_ type: SectionType, data: [ServiceModel]) -> [ServiceCellReactor] {
        return data
            ///내가 생성한 서비스만 보여줌
            .filter { $0.creator.isMe }
            .filter {
                switch type {
                case .preparing:
                    //서비스 준비중: 답변대기중, 로봇배정중, 일시정지(이전: 답변대기중, 로봇배정중)
                    return $0.isPreparingWaiting
                case .canceled:
                    //취소된 서비스: 서비스요청취소, 일시정지(이전: 서비스요청취소)
                    return $0.isPreparingCanceled
                }
            }
            .map{
                ServiceCellReactor(
                    mode: .homeSendedDetail,
                    service: $0
                )
            }
            .sorted(by: { [weak self] in self?.sort($0, $1) ?? false })
    }
    
    private func sort(_ lhs: ServiceCellReactor, _ rhs: ServiceCellReactor) -> Bool {
        return (lhs.currentState.service.createAt > rhs.currentState.service.createAt)
    }
}

extension PagingSendedRequestReactor {
    
    private func addServices(_ type: SectionType, state: State, data: [ServiceCellReactor]) -> State {
        var state = state
        for reactor in data {
            switch type {
            case .preparing:
                state.sections[0].items.insert(reactor, at: 0)
                state.sections[0].items.sort(by: self.sort)
            case .canceled:
                state.sections[1].items.insert(reactor, at: 0)
                state.sections[1].items.sort(by: self.sort)
            }
        }
        return state
    }
    
    private func updateServices(_ type: SectionType, state: State, data: ServiceCellReactor) -> State {
        var state = state
        let serviceIdx = data.currentState.service.serviceIdx
        switch type {
        case .preparing:
            if let index = state.sections[0].items.firstIndex(where: { $0.currentState.service.serviceIdx == serviceIdx }) {
                state.sections[0].items[index] = data
            }
        case .canceled:
            if let index = state.sections[1].items.firstIndex(where: { $0.currentState.service.serviceIdx == serviceIdx }) {
                state.sections[1].items[index] = data
            }
        }
        return state
    }
    
    private func deleteServices(_ type: SectionType, state: State, serviceIdx: Int) -> State {
        var state = state
        switch type {
        case .preparing:
            state.sections[0].items.removeAll { $0.currentState.service.serviceIdx == serviceIdx }
        case .canceled:
            state.sections[1].items.removeAll { $0.currentState.service.serviceIdx == serviceIdx }
        }
        return state
    }
}

extension PagingSendedRequestReactor {
    
    func reactorForSelectSendedService(mode: ServiceDetailViewReactor.Mode, serviceIdx: Int) -> ServiceDetailViewReactor {
        return ServiceDetailViewReactor(
            mode: mode,
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceIdx: serviceIdx
        )
    }
}
