//
//  ServiceCreationDetailViewReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/02.
//

import ReactorKit
import Foundation

class ServiceCreationDetailViewReactor: Reactor {
    
    typealias ServiceUnit = ServiceUnitCreationModel
    
    enum Action {
//        case setPicture(String?)
        case confirm(String?)
    }
    
    enum Mutation {
//        case updatePicture(String?)
        case updateConfirm(Bool?)
    }
    
    struct State {
        var picture: String?
        var isConfirmed: Bool?
    }
    
    var initialState: State = .init(
        picture: nil,
        isConfirmed: nil
    )
    
    let provider: ManagerProviderType
    private let workspaceId: String
    var serviceUnit: ServiceUnit
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
        self.serviceUnit = serviceUnit
        self.mode = mode
        self.templateProcess = process
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case .setPicture(let fileName):
//            if fileName == nil, let existed = self.serviceUnit.attachmentId {
////                Caching.instance.delete(fileName: existed)
//            }
//            self.serviceUnit.attachmentId = fileName
//            return .just(.updatePicture(fileName))
        case .confirm(let detail):
            let isEmpty = detail?.isEmpty ?? true
            self.serviceUnit.detail = (isEmpty ? nil: detail)
            return .concat([
                .just(.updateConfirm(nil)),
                .just(.updateConfirm(true))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
//        case .updatePicture(let fileName):
//            state.picture = fileName
        case .updateConfirm(let isConfirmed):
            state.isConfirmed = isConfirmed
        }
        return state
    }
}

extension ServiceCreationDetailViewReactor {
    
    func reactorForSummary(mode: ServiceCreationEditMode) -> ServiceCreationSummaryViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
}
