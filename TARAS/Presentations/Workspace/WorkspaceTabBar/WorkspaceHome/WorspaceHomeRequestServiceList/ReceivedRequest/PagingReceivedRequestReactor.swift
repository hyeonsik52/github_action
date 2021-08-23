//
//  PagingReceivedRequestReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import ReactorKit

class PagingReceivedRequestReactor: Reactor {
    
    enum SectionType {
        case waiting
        case accepted
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refresh
        case moreAccepted(Int)  //last row
        case notification(Result<ServiceBySwsIdxSubscriptionSubscription.Data, Error>)
        case hiddenNotification(Result<HiddenServiceSubscriptionSubscription.Data, Error>)
    }
    
    enum Mutation {
        case refreshWaiting([ServiceCellReactor])
        case refreshAccepted([ServiceCellReactor])
        case moreAccepted([ServiceCellReactor])
        ///필터링에 의해 추가 로드가 되지 않은 경우 다시 시도 플래그
        case notFoundAccepted
        
        case addService(SectionType, [ServiceCellReactor])
        case updateService(SectionType, ServiceCellReactor)
        case deleteServiceUnitIdx(SectionType, Int) //serviceUnitIdx
        case deleteServiceIdx(SectionType, Int)     //serviceIdx
        
        ///초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case waitingIsLoading(Bool?)
        case acceptedIsLoading(Bool?)
        
        ///추가 로딩
        case isProcessing(Bool?)
    }
    
    struct State {
        var sections: [ServiceModelSection]
        var waitingIsLoading: Bool?
        var acceptedIsLoading: Bool?
        var isProcessing: Bool?
        var retryMoreAccepted: Bool
    }
    
    var initialState: State {
        
        let dummyItems = self.provider.serviceManager
            .dummyServiceUnitSetList(3)
            .map { ServiceCellReactor(
                mode: .homeReceivedDetail,
                service: $0.service,
                serviceUnit: $0.serviceUnit,
                serviceUnitOffset: $0.serviceUnitOffset) }
        
        let sections: [ServiceModelSection] = [
            .init(header: "답변 대기 중 서비스", items: dummyItems),
            .init(header: "수락한 서비스", items: dummyItems)
        ]
        
        return State(
            sections: sections,
            waitingIsLoading: nil,
            acceptedIsLoading: nil,
            isProcessing: nil,
            retryMoreAccepted: false
        )
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    private let countPerLoading = 5
    
    private var startCursor: String?
    private var hasPreviousPage: Bool = true
    
    private var lastRow = -1
    
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
                .just(.waitingIsLoading(true)),
                .just(.acceptedIsLoading(true)),
                self.refresh(.waiting),
                .just(.waitingIsLoading(false)),
                self.refresh(.accepted),
                .just(.acceptedIsLoading(false))
            ])
        case .moreAccepted(let row):
            guard self.currentState.acceptedIsLoading == false else { return .empty() }
            
            if row > self.lastRow {
                self.lastRow = row
                if !self.hasPreviousPage {
                    return .empty()
                }
            }else{
                return .empty()
            }
            
            return .concat([
                .just(.isProcessing(true)),
                self.moreAccepted(row),
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
        case .refreshWaiting(let services):
            state.sections[0].items = services
        case .refreshAccepted(let services):
            state.sections[1].items = services
        case .moreAccepted(let services):
            state.sections[1].items.append(contentsOf: services)
            state.sections[1].items.sort(by: self.sort)
        case let .addService(type, services):
            state = self.addServices(type, state: state, data: services)
        case let .updateService(type, service):
            state = self.updateServices(type, state: state, data: service)
        case let .deleteServiceUnitIdx(type, serviceUnitIdx):
            state = self.deleteServiceUnits(type, state: state, serviceUnitIdx: serviceUnitIdx)
        case let .deleteServiceIdx(type, serviceIdx):
            state = self.deleteServices(type, state: state, serviceIdx: serviceIdx)
        case .waitingIsLoading(let isLoading):
            state.waitingIsLoading = isLoading
        case .acceptedIsLoading(let isLoading):
            state.acceptedIsLoading = isLoading
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .notFoundAccepted:
            state.retryMoreAccepted = !state.retryMoreAccepted
        }
        return state
    }
}

extension PagingReceivedRequestReactor {
    
    private func refresh(_ type: SectionType) -> Observable<Mutation> {
        
        let query = ReceivedServicesConnectionQuery(swsIdx: self.swsIdx, phase: .initiation, response: nil, status: nil, before: nil)
        switch type {
        case .waiting:
            query.status = [.waitingResponse, .pause]
            //응답 대기 중 서비스를 모두 가져옴
            query.last = 2147483647
        case .accepted:
            query.status = [.waitingResponse, .waitingRobotAssignment, .pause]
            //수락한 서비스는 페이징을 위해 제한된 개수만 가져옴
            query.last = self.countPerLoading
        }
        
        return self.provider.networkManager.fetch(query)
            .do(onNext: { [weak self] data in
                if case .accepted = type {
                    let pageInfo = data.receivedServicesConnection.pageInfo
                    self?.startCursor = pageInfo.startCursor
                    self?.hasPreviousPage = (pageInfo.hasPreviousPage == "1")
                    self?.lastRow = -1
                }
            })
            .map { self.convert(type, data: $0) }
            .map {
                switch type {
                case .waiting:
                    return .refreshWaiting($0)
                case .accepted:
                    return .refreshAccepted($0)
                }
            }
    }
    
    private func moreAccepted(_ row: Int) -> Observable<Mutation> {
        
        let query = ReceivedServicesConnectionQuery(
            swsIdx: self.swsIdx,
            phase: .initiation,
            response: nil,
            status: [.waitingResponse, .waitingRobotAssignment, .pause],
            before: self.startCursor,
            last: self.countPerLoading
        )
        
        return self.provider.networkManager.fetch(query)
            .do(onNext: { [weak self] data in
                let pageInfo = data.receivedServicesConnection.pageInfo
                self?.startCursor = pageInfo.startCursor
                self?.hasPreviousPage = (pageInfo.hasPreviousPage == "1")
            })
            .map { self.convert(.accepted, data: $0) }
            .map { [weak self] in
                if $0.isEmpty {
                    self?.lastRow -= 1
                    return .notFoundAccepted
                }else{
                    return .moreAccepted($0)
                }
            }
    }
    
    private func subscription(_ result: Result<ServiceBySwsIdxSubscriptionSubscription.Data, Error>) -> Observable<Mutation> {
        switch result {
        case .success(let data):
            let subscription = data.serviceBySwsIdxSubscription
            if let created = subscription?.asServiceCreated?.item {
                
                var mutations = [Mutation]()
                
                let waiting = self.convert(.waiting, data: created)
                
                for item in waiting {
                    let itemServiceUnitIdx = item.currentState.serviceUnit?.serviceUnitIdx
                    
                    if self.currentState.sections[0].items.contains(where: { $0.currentState.serviceUnit?.serviceUnitIdx == itemServiceUnitIdx }) {
                        //이미 존재하면 업데이트
                        mutations.append(.updateService(.waiting, item))
                    }else{
                        //같은 항목이 없다면 추가
                        mutations.append(.addService(.waiting, [item]))
                    }
                }
                
                return (mutations.isEmpty ? .empty(): .concat(mutations.map {.just($0)}))
                
            }else if let updated = subscription?.asServiceUpdated?.item {
                
                var mutations = [Mutation]()
                
                let original = [ServiceModel(updated, with: self.provider.serviceManager)]
                    .map { service in service.serviceUnitList.map { (service: service, serviceUnit: $0) } }
                    .flatMap{ $0 }
                    .map { ServiceUnitModelSet(service: $0.service, serviceUnit: $0.serviceUnit) }
                    .map{
                        ServiceCellReactor(
                            mode: .homeReceivedDetail,
                            service: $0.service,
                            serviceUnit: $0.serviceUnit,
                            serviceUnitOffset: $0.serviceUnitOffset
                        )
                    }
            
                let waiting = self.convert(.waiting, data: updated)
                let accepted = self.convert(.accepted, data: updated)
                
                let originalSet = Set(original)
                
                //갱신된 서비스 인덱스가 필터링 된 대기 중 목록에 있다면 추가 또는 업데이트
                if waiting.isEmpty {
                    //없다면 원본 전체를 목록에서 삭제
                    let deletes =  original.compactMap { $0.currentState.serviceUnit?.serviceUnitIdx }
                        .map { Mutation.deleteServiceUnitIdx(.waiting, $0) }
                    if !deletes.isEmpty {
                        mutations.append(contentsOf: deletes)
                    }
                }else{
                    for item in waiting {
                        let itemServiceUnitIdx = item.currentState.serviceUnit?.serviceUnitIdx
                        
                        if self.currentState.sections[0].items.contains(where: { $0.currentState.serviceUnit?.serviceUnitIdx == itemServiceUnitIdx }) {
                            //이미 존재하면 업데이트
                            mutations.append(.updateService(.waiting, item))
                        }else{
                            //같은 항목이 없다면 추가
                            mutations.append(.addService(.waiting, [item]))
                        }
                    }
                    
                    //해당되지 않는 항목 삭제
                    let deletes = Array(originalSet.subtracting(waiting)).compactMap { $0.currentState.serviceUnit?.serviceUnitIdx }
                        .map { Mutation.deleteServiceUnitIdx(.waiting, $0) }
                    if !deletes.isEmpty {
                        mutations.append(contentsOf: deletes)
                    }
                }
                
                //갱신된 서비스 인덱스가 필터링 된 취소된 목록에 있다면 추가 또는 업데이트
                if accepted.isEmpty {
                    //없다면 원본 전체를 목록에서 삭제
                    let deletes = original.compactMap { $0.currentState.serviceUnit?.serviceUnitIdx }
                        .map { Mutation.deleteServiceUnitIdx(.waiting, $0) }
                    if !deletes.isEmpty {
                        mutations.append(contentsOf: deletes)
                    }
                }else{
                    for item in accepted {
                        let itemServiceUnitIdx = item.currentState.serviceUnit?.serviceUnitIdx
                        
                        if self.currentState.sections[1].items.contains(where: { $0.currentState.serviceUnit?.serviceUnitIdx == itemServiceUnitIdx }) {
                            //이미 존재하면 업데이트
                            mutations.append(.updateService(.accepted, item))
                        }else{
                            //같은 항목이 없다면 추가
                            mutations.append(.addService(.accepted, [item]))
                        }
                    }
                    
                    //해당되지 않는 항목 삭제
                    let deletes = Array(originalSet.subtracting(accepted)).compactMap { $0.currentState.serviceUnit?.serviceUnitIdx }
                        .map { Mutation.deleteServiceUnitIdx(.accepted, $0) }
                    if !deletes.isEmpty {
                        mutations.append(contentsOf: deletes)
                    }
                }
                
                //삭제 시 서비스의 상태가 서비스 요청 대기 중이 아닐 때로 필터링 하고 있는데,
                //단위서비스 조작 후 알림으로 오는 값에 서비스 상태가 서비스 요청 대기 중이라서 삭제 로직이 불능이 됨.
                return (mutations.isEmpty ? .empty(): .from(mutations))
                
            }else if let deleted = subscription?.asServiceDeleted {
                return .from([
                    .deleteServiceIdx(.waiting, deleted.serviceIdx),
                    .deleteServiceIdx(.accepted, deleted.serviceIdx)
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
                    .deleteServiceIdx(.waiting, service.serviceIdx),
                    .deleteServiceIdx(.accepted, service.serviceIdx)
                ])
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
        return .empty()
    }
}

extension PagingReceivedRequestReactor {
    
    private func convert(_ type: SectionType, data: ReceivedServicesConnectionQuery.Data) -> [ServiceCellReactor] {
        
        let services = data.receivedServicesConnection.edges.compactMap { $0.node }
            .map{ ServiceModel($0, with: self.provider.serviceManager) }
        
        return self.convert(type, data: services)
    }
    
    private func convert(_ type: SectionType, data: ServiceType) -> [ServiceCellReactor] {
        
        let service = ServiceModel(data, with: self.provider.serviceManager)
        
        return self.convert(type, data: [service])
    }
    
    private func convert(_ type: SectionType, data: [ServiceModel]) -> [ServiceCellReactor] {
        return data
            .map { service in service.serviceUnitList.map { (service: service, serviceUnit: $0) } }
            .flatMap{ $0 }
            //내가 수신자에 포함되고, 거절하지 않은 경우, 다른 그룹원이 그룹 거절하지 않고, 다른 개인이 수락하지 않은 경우
            .filter { $0.serviceUnit.amIRecipient && !$0.serviceUnit.amIRejector &&
                !$0.serviceUnit.isGroupRejected && !$0.serviceUnit.isAnotherAccepted }
            .map { ServiceUnitModelSet(service: $0.service, serviceUnit: $0.serviceUnit) }
            .filter {
                switch type {
                case .waiting:
                    //수락자는 단위서비스 당 한 명만 존재할 수 있기 때문에, 수락한 사람이 없으면 답변 대기중이라고 판단함
                    return !$0.serviceUnit.isAcceptorExisted
                case .accepted:
                    //내가 수락한 경우, 다른 그룹원이 그룹 수락한 경우, 로봇 배정중인 경우(일시정지 포함)
                    //거절된 단위서비스를 포함하지 않아야 함
                    let containedReject = $0.service.serviceUnitList.contains{ $0.status == .rejected }
                    return !containedReject &&
                        $0.service.isPreparingWaiting &&
                        ($0.serviceUnit.amIAcceptor ||
                        $0.serviceUnit.isGroupAccepted)
                }
            }
            .map{
                ServiceCellReactor(
                    mode: .homeReceivedDetail,
                    service: $0.service,
                    serviceUnit: $0.serviceUnit,
                    serviceUnitOffset: $0.serviceUnitOffset
                )
            }
            .sorted(by: { [weak self] in self?.sort($0, $1) ?? false })
    }
    
    private func sort(_ lhs: ServiceCellReactor, _ rhs: ServiceCellReactor) -> Bool {
        return ((lhs.currentState.service.createAt, rhs.currentState.serviceUnitOffset ?? 0) > (rhs.currentState.service.createAt, lhs.currentState.serviceUnitOffset ?? 0))
    }
}

extension PagingReceivedRequestReactor {
    
    private func addServices(_ type: SectionType, state: State, data: [ServiceCellReactor]) -> State {
        var state = state
        for reactor in data {
            switch type {
            case .waiting:
                state.sections[0].items.insert(reactor, at: 0)
                state.sections[0].items.sort(by: self.sort)
            case .accepted:
                state.sections[1].items.insert(reactor, at: 0)
                state.sections[1].items.sort(by: self.sort)
            }
        }
        return state
    }
    
    private func updateServices(_ type: SectionType, state: State, data: ServiceCellReactor) -> State {
        var state = state
        let serviceUnitIdx = data.currentState.serviceUnit?.serviceUnitIdx
        switch type {
        case .waiting:
            if let index = state.sections[0].items.firstIndex(where: { $0.currentState.serviceUnit?.serviceUnitIdx == serviceUnitIdx }) {
                state.sections[0].items[index] = data
            }
        case .accepted:
            if let index = state.sections[1].items.firstIndex(where: { $0.currentState.serviceUnit?.serviceUnitIdx == serviceUnitIdx }) {
                state.sections[1].items[index] = data
            }
        }
        return state
    }
    
    private func deleteServiceUnits(_ type: SectionType, state: State, serviceUnitIdx: Int) -> State {
        var state = state
        switch type {
        case .waiting:
            state.sections[0].items.removeAll { $0.currentState.serviceUnit?.serviceUnitIdx == serviceUnitIdx }
        case .accepted:
            state.sections[1].items.removeAll { $0.currentState.serviceUnit?.serviceUnitIdx == serviceUnitIdx }
        }
        return state
    }
    
    private func deleteServices(_ type: SectionType, state: State, serviceIdx: Int) -> State {
        var state = state
        switch type {
        case .waiting:
            state.sections[0].items.removeAll { $0.currentState.service.serviceIdx == serviceIdx }
        case .accepted:
            state.sections[1].items.removeAll { $0.currentState.service.serviceIdx == serviceIdx }
        }
        return state
    }
}

extension PagingReceivedRequestReactor {
    
    func reactorForSelectReceivedService(serviceIdx: Int, serviceUnitIdx: Int) -> WorkRequestViewReactor {
        return WorkRequestViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceIdx: serviceIdx,
            serviceUnitIdx: serviceUnitIdx
        )
    }
}
