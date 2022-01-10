//
//  ServiceCreationSummaryViewReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/02.
//

import ReactorKit
import Foundation

enum ServiceCreationEditMode {
    case create
    case update
    
    var text: String {
        switch self {
        case .create:
            return "생성"
        case .update:
            return "수정"
        }
    }
}

class ServiceCreationSummaryViewReactor: Reactor {
    
    typealias ServiceUnit = ServiceUnitCreationModel
    typealias Stop = ServiceUnitTargetModel
    typealias User = ServiceUnitTargetModel
    typealias ServiceUnitUpdateClosure = (inout ServiceUnit) -> Void
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action {
        case updateStop(Stop)
        case updateReceivers([User])
        case updateDetail(ServiceUnit)
        case confirm
    }
    
    enum Mutation {
        case updateServiceUnit(ServiceUnitUpdateClosure)
        case updateConfirm(Bool?)
    }
    
    struct State {
        var serviceUnit: ServiceUnit
        var isConfirmed: Bool?
    }
    
    var initialState: State
    
    let provider: ManagerProviderType
    private let workspaceId: String
    let mode: ServiceCreationEditMode
    
    private let disposeBag = DisposeBag()
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceUnit: ServiceUnit,
        mode: ServiceCreationEditMode
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.mode = mode
        
        self.initialState = .init(
            serviceUnit: serviceUnit,
            isConfirmed: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .updateStop(let stop):
            return .just(.updateServiceUnit({ $0.stop = stop }))
        case .updateReceivers(let receivers):
            return .just(.updateServiceUnit({ $0.receivers = receivers }))
        case .updateDetail(let serviceUnit):
            return .just(.updateServiceUnit({ $0 = serviceUnit }))
        case .confirm:
            return .concat([
                .just(.updateConfirm(nil)),
                .just(.updateServiceUnit({ [weak self] in
                    self?.provider.notificationManager.post(AddOrUpdateServiceUnit($0))
                })),
                .just(.updateConfirm(true))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateServiceUnit(let update):
            update(&state.serviceUnit)
        case .updateConfirm(let isConfirmed):
            state.isConfirmed = isConfirmed
        }
        return state
    }
}

extension ServiceCreationSummaryViewReactor {
    
    func reactorForSelectStop(mode: ServiceCreationEditMode) -> ServiceCreationSelectStopViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            mode: mode,
            entry: .general(self.currentState.serviceUnit)
        )
    }
    
    func reactorForSelectReceiver(mode: ServiceCreationEditMode) -> ServiceCreationSelectReceiverViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.currentState.serviceUnit,
            mode: mode
        )
    }
    
    func reactorForDetail(mode: ServiceCreationEditMode) -> ServiceCreationDetailViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.currentState.serviceUnit,
            mode: mode
        )
    }
}
