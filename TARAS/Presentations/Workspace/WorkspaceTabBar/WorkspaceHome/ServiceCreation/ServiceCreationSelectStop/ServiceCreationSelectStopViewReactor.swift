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
    typealias StopModel = ServiceUnitTargetModel
    typealias StopUpdateClosure = ([StopModel]) -> [StopModel]
    typealias StopReactor = ServiceUnitTargetCellReactor
    
    enum Entry {
        case general(ServiceUnit)
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case refresh(term: String?)
//        case select(model: StopModel)
        case confirm(with: StopModel)
    }
    
    enum Mutation {
        case reloadStops([StopReactor])
        case updateLoading(Bool)
//        case updateStop(StopUpdateClosure)
        case updateConfirm(Bool?)
        case updatePlaceholderState(PlaceholderStateType?)
    }
    
    struct State {
        var stops: [StopReactor]
        var isLoading: Bool
        var isConfirmed: Bool?
        var placeholderState: PlaceholderStateType?
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
        case .refresh(let term):
            return .concat([
                .just(.updateLoading(true)),
                self.refresh(term: term),
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
        case .updatePlaceholderState(let placeholderState):
            state.placeholderState = placeholderState
        }
        if state.placeholderState != .networkDisconnected {
            state.placeholderState = (state.stops.isEmpty ? .resultNotFound: nil)
        }
        return state
    }
}

extension ServiceCreationSelectStopViewReactor {
    
    func refresh(term: String?) -> Observable<Mutation> {
        
        if case .general = self.entry {
            
            if self.templateProcess.peek(with: "ID")?.asArgument?.from == .stationGroup {
                let isGeneralLoading = self.templateProcess.isServiceTypeLS
                
                return self.provider.networkManager.fetch(StopListQuery(workspaceId: self.workspaceId, name: term))
                    .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node?.stationGroups }
                    .map { $0.edges.compactMap { $0?.node?.fragments.stopFragment }.map(Stop.init) }
                    .map {
                        return $0.map {
                            var stop = StopModel(id: $0.id, name: $0.name)
                            stop.isSelected = (stop == self.serviceUnit.stop)
                            stop.isLoadingStop = $0.stopType.isLoading
                            return .init(
                                model: stop,
                                selectionType: .check,
                                isEnabled: !$0.stopType.isLoading || isGeneralLoading,
                                isIconVisibled: false,
                                highlightRanges: (term == nil ? []: $0.name.ranges(of: term!))
                            )
                        }
                    }.flatMapLatest { stops -> Observable<Mutation> in
                        return .concat([
                            .just(.updatePlaceholderState(nil)),
                            .just(.reloadStops(stops))
                        ])
                    }.catch { error in
                        guard let multipleError = error as? MultipleError,
                              let _ = multipleError.graphQLErrors
                        else {
                            return .concat([
                                .just(.reloadStops([])),
                                .just(.updatePlaceholderState(.networkDisconnected))
                            ])
                        }
                        return .empty()
                    }
            }
        }
        
        return .just(.reloadStops([]))
    }
}

extension ServiceCreationSelectStopViewReactor {
    
    func reactorForSelectReceivers(
        mode: ServiceCreationEditMode,
        stop: StopModel
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
        stop: StopModel
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
