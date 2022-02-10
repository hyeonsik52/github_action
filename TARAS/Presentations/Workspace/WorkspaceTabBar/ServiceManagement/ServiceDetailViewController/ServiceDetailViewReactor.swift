//
//  ServiceDetailViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class ServiceDetailViewReactor: Reactor {
    
    enum Text {
        static let errorRequestFailed = "서비스를 취소하지 못했습니다."
        static let errorNetworkConnection = "서버와의 통신이 원활하지 않습니다."
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refreshService
        case cancelService
    }
    
    enum Mutation {
        case refreshService(Service)
        case updateIsCanceled(Bool)
        case updateIsLoading(Bool?)
        case updateIsProcessing(Bool?)
        case updateErrorMessage(String?)
    }
    
    struct State {
        var service: Service?
        var serviceUnitReactors: [ServiceDetailServiceUnitCellReactor]
        var isCanceled: Bool?
        var isLoading: Bool?
        var isProcessing: Bool?
        var errorMessage: String?
    }
    
    let initialState: State = .init(
        service: nil,
        serviceUnitReactors: [],
        isCanceled: nil,
        isLoading: nil,
        isProcessing: nil,
        errorMessage: nil
    )
    
    let provider : ManagerProviderType
    let workspaceId: String
    let serviceId: String
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceId: String
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceId = serviceId
    }
    
    private func bind() {
        //temp
//        self.provider.subscriptionManager.service(by: self.serviceId)
//            .subscribe(onNext: { [weak self] result in
//                self?.action.onNext(.refreshService)
//            }).disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshService:
            let query = ServiceQuery(workspaceId: self.workspaceId, serviceId: self.serviceId)
            return .concat([
                .just(.updateIsLoading(true)),
                
                self.provider.networkManager.fetch(query)
                    .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node }
                    .compactMap { $0.services?.edges.first??.node?.fragments.serviceFragment }
                    .map { .refreshService(.init($0)) }
                    .catch(self.catchClosure),
                
                .just(.updateIsLoading(false))
            ])
        case .cancelService:
            let mutation = CancelServiceMutation(id: self.serviceId)
            return .concat([
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .flatMapLatest { payload -> Observable<Mutation> in
                        let isCanceled = payload.cancelService?.ok == true
                        return .just(.updateIsCanceled(isCanceled))
                    }.catch(self.catchClosure),
                
                .just(.updateIsProcessing(false))
            ])
        }
    }
    
    var catchClosure: ((Error) throws -> Observable<Mutation>) {
        return { error in
            guard let multipleError = error as? MultipleError,
                  let errors = multipleError.graphQLErrors else {
                return .just(.updateErrorMessage(Text.errorNetworkConnection))
            }
            for error in errors {
                guard let message = error.message, !message.isEmpty else { continue }
                return .just(.updateErrorMessage(message))
            }
            return .just(.updateErrorMessage(Text.errorRequestFailed))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .refreshService(let model):
            state.service = model
            state.serviceUnitReactors = self.convertServiceUnitCellReactors(model)
        case .updateIsCanceled(let isCanceled):
            state.isCanceled = isCanceled
        case .updateIsLoading(let isLoading):
            state.isLoading = isLoading
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateErrorMessage(let message):
            state.errorMessage = message
        }
        return state
    }
    
    private func convertServiceUnitCellReactors(_ service: Service) -> [ServiceDetailServiceUnitCellReactor] {
        
        let myUserId = self.provider.userManager.userTB.ID
        let isServiceInProgress = (service.phase == .waiting || service.phase == .delivering)
        let isServicePreparing = (service.phase == .waiting && service.currentServiceUnitIdx == 0)
        
        return service.serviceUnits.map {
            
            var robotArrivalState: ServiceUnitRobotArrivalState = .passed
            
            if $0.orderWithinService > service.currentServiceUnitIdx {
                robotArrivalState = .waiting
            } else if $0.orderWithinService == service.currentServiceUnitIdx {
                if service.status == .waiting {
                    robotArrivalState = .waiting
                } else if service.status == .moving {
                    robotArrivalState = .departure
                } else if service.status == .arrived {
                    robotArrivalState = .arrival
                }
            }
            
            return .init(
                serviceUnit: $0,
                userId: myUserId,
                isServiceInProgress: isServiceInProgress,
                isServicePreparing: isServicePreparing,
                robotArrivalState: robotArrivalState
            )
        }
    }
}

extension ServiceDetailViewReactor {
    
    func reactorForBasicInfo() -> ServiceBasicInfoViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceId: self.serviceId
        )
    }
    
    func reactorForDetailLog() -> ServiceDetailLogViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceId: self.serviceId
        )
    }
    
    func reactorForWorkRequest(with serviceUnitId: String) -> WorkRequestViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceId: self.serviceId,
            serviceUnitId: serviceUnitId
        )
    }
}
