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
            return "추가"
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
    
    enum Action: Equatable {
        case updateStop(Stop)
        case updateIsWorkWaiting(Bool)
        case updateIsLoadingStop(Bool)
        case updateDetail(String?)
        case updateReceivers([User])
        case confirm
    }
    
    enum Mutation {
        case updateServiceUnit(ServiceUnitUpdateClosure)
        case updateConfirm(Bool?)
    }
    
    struct State {
        var serviceUnit: ServiceUnit
        var isWorkWaiting: Bool?
        var isLoadingStop: Bool?
        var isConfirmed: Bool?
    }
    
    var initialState: State
    
    let provider: ManagerProviderType
    private let workspaceId: String
    let mode: ServiceCreationEditMode
    
    let templateProcess: STProcess
    
    private let disposeBag = DisposeBag()
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceUnit: ServiceUnit,
        mode: ServiceCreationEditMode,
        process: STProcess
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.mode = mode
        self.templateProcess = process
        
        self.initialState = .init(
            serviceUnit: serviceUnit,
            isWorkWaiting: nil,
            isLoadingStop: nil,
            isConfirmed: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .updateStop(let stop):
            return .just(.updateServiceUnit({ [weak self] in
                $0.stop = stop
                guard let process = self?.templateProcess else { return }
                $0.updateStopState(with: process)
            }))
        case .updateIsWorkWaiting(let flag):
            return .just(.updateServiceUnit({ $0.isWorkWaiting = flag }))
        case .updateIsLoadingStop(let flag):
            return .just(.updateServiceUnit({ $0.isLoadingStop = flag }))
        case .updateDetail(let detail):
            let isEmpty = detail?.isEmpty ?? true
            return .just(.updateServiceUnit({ $0.detail = (isEmpty ? nil: detail) }))
        case .updateReceivers(let receivers):
            return .just(.updateServiceUnit({ $0.receivers = receivers }))
        case .confirm:
            return .concat([
                .just(.updateConfirm(nil)),
                .just(.updateServiceUnit({ [weak self] in
                    $0.detail = $0.detail?.trimmingCharacters(in: .whitespacesAndNewlines)
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
            entry: .general(self.currentState.serviceUnit),
            process: self.templateProcess
        )
    }
    
    func reactorForSelectReceiver(mode: ServiceCreationEditMode) -> ServiceCreationSelectReceiverViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.currentState.serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
    
    func reactorForDetail(mode: ServiceCreationEditMode) -> ServiceCreationDetailViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.currentState.serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
}
