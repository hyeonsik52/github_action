//
//  ServiceCreationSelectStopViewReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/01.
//

import ReactorKit
import Foundation

enum ServiceUnitTargetSelectionType {
    case radio
    case check
}

class ServiceCreationSelectStopViewReactor: Reactor {
    
    typealias ServiceUnit = ServiceUnitCreationModel
    typealias Stop = ServiceUnitTargetModel
    typealias StopUpdateClosure = ([Stop]) -> [Stop]
    
    enum Entry {
        case general(ServiceUnit)
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action {
        case refresh
//        case select(model: Stop)
        case confirm(with: Stop)
    }
    
    enum Mutation {
        case reloadStops([Stop])
        case updateLoading(Bool)
//        case updateStop(StopUpdateClosure)
        case updateConfirm(Bool?)
    }
    
    struct State {
        var stops: [Stop]
        var isLoading: Bool
        var isConfirmed: Bool?
    }
    
    var initialState: State = .init(
        stops: [],
        isLoading: false
    )
    
    let provider: ManagerProviderType
    private let workspaceId: String
    private var serviceUnit: ServiceUnit
    let mode: ServiceCreationEditMode
    let entry: Entry
    
    let templateProcess: STProcess
    
    private let disposeBag = DisposeBag()
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        mode: ServiceCreationEditMode,
        entry: Entry,
        process: STProcess
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        if case .general(let serviceUnit) = entry {
            self.serviceUnit = serviceUnit
        } else {
            self.serviceUnit = .init()
        }
        self.mode = mode
        self.entry = entry
        self.templateProcess = process
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.updateLoading(true)),
                self.refresh(),
                .just(.updateLoading(false))
            ])
//        case .select(let model):
//            return .just(.updateStop({ stops in
//                var stops = stops
//                if let newSelectIndex = stops.firstIndex(where: { $0 == model }) {
//                    if let prevSelectIndex = stops.firstIndex(where: { $0 == self.serviceUnit.stop }) {
//                        stops[prevSelectIndex].isSelected = false
//                    }
//                    stops[newSelectIndex].isSelected = true
//                }
//                self.serviceUnit.stop = model
//                return stops
//            }))
        case .confirm(let stop):
            self.serviceUnit.stop = stop
            self.serviceUnit.updateStopState(with: self.templateProcess)
            self.provider.notificationManager.post(AddOrUpdateServiceUnit(self.serviceUnit))
            return .concat([
                .just(.updateConfirm(nil)),
                .just(.updateConfirm(true))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadStops(let stops):
            state.stops = stops
        case .updateLoading(let isLoading):
            state.isLoading = isLoading
//        case .updateStop(let update):
//            state.stops = update(state.stops)
        case .updateConfirm(let isConfirmed):
            state.isConfirmed = isConfirmed
        }
        return state
    }
}

extension ServiceCreationSelectStopViewReactor {
    
    func refresh() -> Observable<Mutation> {
        
        if case .general = self.entry {
            
            if self.templateProcess.peek(with: "ID")?.asArgument?.from == .stationGroup {
                
                return self.provider.networkManager.fetch(StopListQuery(workspaceId: self.workspaceId))
                    .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node?.stationGroups }
                    .map { $0.edges.compactMap { $0?.node?.fragments.stopFragment } }
                    .map {
                        $0.compactMap { payload -> Stop? in
                            var stop = Stop(id: payload.id, name: payload.name)
                            stop.isSelected = (stop == self.serviceUnit.stop)
                            return stop
                        }
                    }.map { .reloadStops($0) }
            }
        }
        
        return .just(.reloadStops([]))
    }
}

extension ServiceCreationSelectStopViewReactor {
    
    func reactorForSelectReceivers(
        mode: ServiceCreationEditMode,
        stop: Stop
    ) -> ServiceCreationSelectReceiverViewReactor {
        self.serviceUnit.stop = stop
        self.serviceUnit.updateStopState(with: self.templateProcess)
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
    
    func reactorForSummary(
        mode: ServiceCreationEditMode,
        stop: Stop
    ) -> ServiceCreationSummaryViewReactor {
        self.serviceUnit.stop = stop
        self.serviceUnit.updateStopState(with: self.templateProcess)
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
}
