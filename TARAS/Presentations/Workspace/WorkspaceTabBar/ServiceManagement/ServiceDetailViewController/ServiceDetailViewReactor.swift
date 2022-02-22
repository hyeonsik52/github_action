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
        static let errorRequestFailed = "요청에 실패했습니다."
        static let errorServiceCanclationFailed = "서비스를 취소하지 못했습니다."
        static let errorWorkCompletionFailed = "작업을 완료하지 못했습니다."
        static let errorNetworkConnection = "서버와의 통신이 원활하지 않습니다."
    }
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refreshService
        case cancelService
        case completeServiceUnit
        case updateService(Service)
    }
    
    enum Mutation {
        case refreshService(Service)
        case updateIsLoading(Bool?)
        case updateIsProcessing(Bool?)
        case updateErrorMessage(String?)
        case updateIsServiceUnitCompleted(Bool?)
    }
    
    struct State {
        var service: Service?
        var serviceUnitReactors: [ServiceDetailServiceUnitCellReactor]
        var isLoading: Bool?
        var isProcessing: Bool?
        var errorMessage: String?
        var isServiceUnitCompleted: Bool?
    }
    
    let initialState: State = .init(
        service: nil,
        serviceUnitReactors: [],
        isLoading: nil,
        isProcessing: nil,
        errorMessage: nil,
        isServiceUnitCompleted: nil
    )
    
    let provider : ManagerProviderType
    let workspaceId: String
    let serviceId: String
    
    init(provider: ManagerProviderType, workspaceId: String, serviceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceId = serviceId
        
        self.subscription()
    }
    
    private func subscription() {
        
        self.provider.subscriptionManager
            .serviceBy(serviceId: self.serviceId)
            .compactMap { try? $0.get() }
            .compactMap(\.subscribeServiceByServiceId?.fragments.serviceFragment)
            .map(Service.init)
            .subscribe(onNext: { [weak self] service in
                self?.action.onNext(.updateService(service))
                self?.provider.notificationManager.post(UpdateService(service))
            }).disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshService:
            let query = ServiceQuery(workspaceId: self.workspaceId, serviceId: self.serviceId)
            return .concat([
                .just(.updateErrorMessage(nil)),
                .just(.updateIsLoading(true)),
                
                self.provider.networkManager.fetch(query)
                    .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node }
                    .compactMap { $0.services?.edges.first??.node?.fragments.serviceFragment }
                    .flatMapLatest { fragment -> Observable<Mutation> in
                        let service = Service(fragment)
                        var observables = [Observable<Mutation>.just(.refreshService(service))]
                        if service.status == .moving {
                            observables.append(.just(.updateIsServiceUnitCompleted(nil)))
                        }
                        return .concat(observables)
                    }.catch(self.catchClosure),
                
                .just(.updateIsLoading(false))
            ])
        case .updateService(let service):
            var observables = [Observable<Mutation>.just(.refreshService(service))]
            if service.status == .moving {
                observables.append(.just(.updateIsServiceUnitCompleted(nil)))
            }
            return .concat(observables)
        case .cancelService:
            let mutation = CancelServiceMutation(id: self.serviceId)
            return .concat([
                .just(.updateErrorMessage(nil)),
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .flatMapLatest { payload -> Observable<Mutation> in
                        if payload.cancelService?.ok == true {
                            return .just(.updateErrorMessage(nil))
                        } else {
                            return .just(.updateErrorMessage(Text.errorServiceCanclationFailed))
                        }
                    }.catch(self.catchClosure),
                
                .just(.updateIsProcessing(false))
            ])
        case .completeServiceUnit:
            guard let service = self.currentState.service else {
                return .empty()
            }
            let mutation = CompleteServiceUnitMutation(
                serviceId: self.serviceId,
                serviceStep: service.currentServiceUnitIdx
            )
            return .concat([
                .just(.updateErrorMessage(nil)),
                .just(.updateIsProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .flatMapLatest { payload -> Observable<Mutation> in
                        if payload.completeServiceUnit?.ok == true {
                            return .just(.updateIsServiceUnitCompleted(true))
                        } else {
                            return .just(.updateErrorMessage(Text.errorWorkCompletionFailed))
                        }
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
        case .updateIsLoading(let isLoading):
            state.isLoading = isLoading
        case .updateIsProcessing(let isProcessing):
            state.isProcessing = isProcessing
        case .updateErrorMessage(let message):
            state.errorMessage = message
        case .updateIsServiceUnitCompleted(let succeeded):
            state.isServiceUnitCompleted = succeeded
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
    
    func reactorForShortcutRegistration() -> ServiceShortcutRegistrationViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceId: self.serviceId
        )
    }
}
