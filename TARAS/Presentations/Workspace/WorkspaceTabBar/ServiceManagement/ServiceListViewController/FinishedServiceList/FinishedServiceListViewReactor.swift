//
//  FinishedServiceListViewReactor.swift
//  TARAS
//
//  Created by nexmond on 2022/02/04.
//

import ReactorKit

class FinishedServiceListViewReactor: Reactor {
    
    typealias Notification = ServiceByWorkspaceIdSubscription.Data.SubscribeServiceChangeset
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refresh
        case moreFind(IndexPath)  //last item
        case notification(Notification)
    }
    
    enum Mutation {
        case refresh([Service])
        case more([Service])
        ///필터링에 의해 추가 로드가 되지 않은 경우 다시 시도 플래그
        case notFoundMore

        case addService(Service)
        case updateService(Service)
        case deleteService(String) //serviceId
        
        case isLoading(Bool?)
        case isProcessing(Bool?)
    }
    
    struct State {
        var services: [Service]
        var serviceSections: [ServiceModelSection]
        var isLoading: Bool?
        var isProcessing: Bool?
        var retryMoreFind: Bool
    }
    
    var initialState: State {
        return State(
            services: [],
            serviceSections: [],
            isLoading: nil,
            isProcessing: nil,
            retryMoreFind: false
        )
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    
    private let countPerLoading = 12

    private var endCursor: String?
    private var hasNextPage: Bool = true

    private var lastIndexPath = IndexPath(item: -1, section: 0)
    
    init(provider: ManagerProviderType, workspaceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.bind()
    }
    
    private func bind() {
        
        //TODO: 화면에 표시되는 항목의 변경사항만 추적하여 업데이트하도록 개선
//        self.provider.subscriptionManager.serviceBy(workspaceId: self.workspaceId)
//            .subscribe(onNext: { [weak self] result in
//                self?.action.onNext(.notification(result))
//            }).disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return .concat([
                .just(.isLoading(true)),
                self.refresh(),
                .just(.isLoading(false)),
            ])
        case .moreFind(let indexPath):
            guard self.currentState.isLoading == false else { return .empty() }

            if indexPath.section > self.lastIndexPath.section ||
                (indexPath.section == self.lastIndexPath.section &&
                indexPath.item > self.lastIndexPath.item) {
                self.lastIndexPath = indexPath
                if !self.hasNextPage {
                    return .empty()
                }
            }else{
                return .empty()
            }

            return .concat([
                .just(.isProcessing(true)),
                self.moreFind(indexPath),
                .just(.isProcessing(false))
            ])
        case .notification(let result):
            return self.subscription(result)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .refresh(let services):
            let services = services.filter(self.filter)
            state.services = services
            state.serviceSections = self.sectioned(services)
        case .more(let services):
            state.services.append(contentsOf: services)
            state.services.sort(by: self.sort)
            state.serviceSections = self.sectioned(state.services)
        case let .addService(service):
            state = self.addServices(state: state, data: service)
            state.services = state.services.filter(self.filter)
            state.serviceSections = self.sectioned(state.services)
        case let .updateService(service):
            state = self.updateServices(state: state, data: service)
            state.services = state.services.filter(self.filter)
            state.serviceSections = self.sectioned(state.services)
        case let .deleteService(serviceId):
            state = self.deleteServices(state: state, serviceId: serviceId)
            state.services = state.services.filter(self.filter)
            state.serviceSections = self.sectioned(state.services)
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .isLoading(let isLoading):
            state.isLoading = isLoading
        case .notFoundMore:
            state.retryMoreFind = !state.retryMoreFind
        }
        return state
    }
}

extension FinishedServiceListViewReactor {

    private func refresh() -> Observable<Mutation> {
        
        let query = ServicesQuery(
            workspaceId: self.workspaceId,
            after: nil,
            first: self.countPerLoading,
            phases: [ServicePhase.completed.toString!, ServicePhase.canceled.toString!]
        )
        
        return self.provider.networkManager.fetch(query)
            .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node?.services }
            .do(onNext: { [weak self] data in
                let pageInfo = data.pageInfo
                self?.endCursor = pageInfo.endCursor
                self?.hasNextPage = pageInfo.hasNextPage
                self?.lastIndexPath = .init(item: -1, section: 0)
            })
            .compactMap { $0.edges.compactMap { $0?.node?.fragments.serviceFragment }.map(Service.init) }
            .map { $0.sorted(by: self.sort) }
            .map { .refresh($0) }
    }

    private func moreFind(_ indexPath: IndexPath) -> Observable<Mutation> {
        
        let query = ServicesQuery(
            workspaceId: self.workspaceId,
            after: self.endCursor,
            first: self.countPerLoading,
            phases: [ServicePhase.completed.toString!, ServicePhase.canceled.toString!]
        )
        
        return self.provider.networkManager.fetch(query)
            .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node?.services }
            .do(onNext: { [weak self] data in
                let pageInfo = data.pageInfo
                self?.endCursor = pageInfo.endCursor
                self?.hasNextPage = pageInfo.hasNextPage
            })
            .compactMap { $0.edges.compactMap { $0?.node?.fragments.serviceFragment }.map(Service.init) }
            .map { $0.sorted(by: self.sort) }
            .map { [weak self] services in
                if services.isEmpty {
                    if let lastIndexPath = self?.lastIndexPath {
                        self?.lastIndexPath = .init(item: lastIndexPath.item-1, section: lastIndexPath.section)
                    }
                    return .notFoundMore
                } else {
                    return .more(services)
                }
            }
    }

    private func subscription(_ notification: Notification) -> Observable<Mutation> {
        if let eventType = notification.eventType,
           let fragment = notification.service?.fragments.serviceFragment,
           fragment.type != "RECALL" {
            let service = Service(fragment)
            Log.debug("\(eventType)")
            switch eventType {
            case .serviceCreated:
                return .just(.addService(service))
            case .serviceUpdated:
                return .just(.updateService(service))
            case .serviceDeleted:
                return .just(.deleteService(service.id))
            default:
                Log.error("serviceSubscription error: unknowned eventType")
            }
        } else {
            Log.error("serviceSubscription error: not fount eventType or data")
        }
        return .empty()
    }
}

extension FinishedServiceListViewReactor {

    private func sort(_ lhs: Service, _ rhs: Service) -> Bool {
        return (lhs.phase.sortOrder, lhs.requestedAt) > (rhs.phase.sortOrder, rhs.requestedAt)
    }
    
    private func filter(_ item: Service) -> Bool {
        return (item.type != .recall && item.type != .unknown) && (item.phase == .completed || item.phase == .canceled)
    }
    
    private func sectioned(_ services: [Service]) -> [ServiceModelSection] {
        var map: [String: [Service]] = [:]
        for model in services {
            let dateString = model.requestedAt.toString("yy.MM.dd E")
            if let array = map[dateString] {
                var array = array
                array.insert(model, at: 0)
                map[dateString] = array.sorted(by: { $0.requestedAt > $1.requestedAt })
            } else {
                map[dateString] = [model]
            }
        }
        return map.sorted(by: { $0.key > $1.key })
            .map { ($0, $1.map(self.reactorForServiceCell)) }
            .map(ServiceModelSection.init)
    }
}

extension FinishedServiceListViewReactor {

    private func addServices(state: State, data: Service) -> State {
        var state = state
        if state.services.contains(data) {
            state = self.updateServices(state: state, data: data)
        } else {
            state.services.insert(data, at: 0)
            state.services.sort(by: self.sort)
        }
        return state
    }

    private func updateServices(state: State, data: Service) -> State {
        var state = state
        if let index = state.services.firstIndex(of: data) {
            let prev = state.services[index]
            if data.hashValue != prev.hashValue {
                state.services[index] = data
            }
        }
        return state
    }

    private func deleteServices(state: State, serviceId: String) -> State {
        var state = state
        state.services.removeAll { $0.id == serviceId }
        return state
    }
}

extension FinishedServiceListViewReactor {
    
    func reactorForServiceDetail(serviceId: String) -> ServiceDetailViewReactor {
        return .init(provider: self.provider, workspaceId: self.workspaceId, serviceId: serviceId)
    }
    
    func reactorForServiceCell(service: Service) -> ServiceCellReactor {
        return .init(service: service, myUserId: self.provider.userManager.userTB.ID)
    }
}
