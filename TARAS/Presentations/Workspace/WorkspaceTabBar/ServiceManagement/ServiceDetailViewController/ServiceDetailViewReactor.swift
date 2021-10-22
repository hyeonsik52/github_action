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
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case loadService(refresh: Bool)
        case cancelRequest
        case deleteService
        case judgeIsFromPush
    }
    
    enum Mutation {
        case loadedService(Service)
        case requestCanceled(Bool)
        case servceDeleted(Bool)
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case isProcessing(Bool)
        case updateIsFromPush(Bool)
    }
    
    struct State {
        var serviceModel: Service?
        var requestCanceled: Bool?
        var serviceDeleted: Bool?
        var isLoading: Bool?
        var isProcessing: Bool?
        var isFromPush: Bool
    }
    
    var initialState: State {
        return State(
            serviceModel: nil,
            requestCanceled: nil,
            serviceDeleted: nil,
            isLoading: nil,
            isProcessing: nil,
            isFromPush: false
        )
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    let serviceId: String
    let pushInfo: NotificationInfo?
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceId: String,
        pushInfo: NotificationInfo? = nil
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceId = serviceId
        self.pushInfo = pushInfo

        self.provider.subscriptionManager.service(by: self.serviceId)
             .subscribe(onNext: { [weak self] result in
                 self?.action.onNext(.loadService(refresh: true))
             })
             .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadService(let refresh):
            let query = ServiceQuery(serviceId: self.serviceId)
            let request = (refresh ? self.provider.networkManager.fetch(query): self.provider.networkManager.fetch(query))
            return .concat([
                .just(.isLoading(true)),
                
                request
                    .compactMap { $0.hiGlovisServiceByOrderId?.fragments.serviceFragment }
                    .compactMap { self.provider.serviceManager.convert(service: $0) }
                    .map { Mutation.loadedService($0) },
                
                .just(.isLoading(false))
            ])
        case .cancelRequest:
//            let input = CancelServiceInput(serviceIdx: self.serviceIdx)
            return .concat([
                .just(.isProcessing(true)),
                
//                self.provider.networkManager.perform(CancelServiceMutationMutation(input: input))
//                .map { $0.cancelServiceMutation.asCancelServicePayload?.result == "1" }
//                .map { Mutation.requestCanceled($0) },
                
                .just(.isProcessing(false))
            ])
        case .deleteService:
//            let input = HideServiceInput(serviceIdx: self.serviceIdx)
            return .concat([
                .just(.isProcessing(true)),
                
//                self.provider.networkManager.perform(HideServiceMutationMutation(input: input))
//                .map { $0.hideServiceMutation.asHideServicePayload?.result == "1" }
//                .map { Mutation.servceDeleted($0) },
                
                .just(.isProcessing(false))
            ])
            
        case .judgeIsFromPush:
            let isFromPush = (self.pushInfo != nil)
            return .just(.updateIsFromPush(isFromPush))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedService(serviceModel):
            state.serviceModel = serviceModel
            state.isFromPush = false
            
        case let .requestCanceled(successed):
            state.requestCanceled = successed
            state.isFromPush = false
            
        case let .servceDeleted(successed):
            state.serviceDeleted = successed
            state.isFromPush = false
            
        case .isLoading(let loading):
            state.isLoading = loading
            state.isFromPush = false
            
        case .isProcessing(let processing):
            state.isProcessing = processing
            state.isFromPush = false
            
        case let .updateIsFromPush(isFromPush):
            state.isFromPush = isFromPush
        }
        return state
    }
    
    func reactorForBasicInfo() -> ServiceBasicInfoViewReactor {
        return ServiceBasicInfoViewReactor(provider: self.provider, workspaceId: self.workspaceId, serviceId: self.serviceId)
    }
    
    func reactorForDetailLog() -> ServiceDetailLogViewReactor {
        return ServiceDetailLogViewReactor(provider: self.provider, workspaceId: self.workspaceId, serviceId: self.serviceId)
    }
    
    func reactorForWorkRequest(with serviceUnitId: String) -> WorkRequestViewReactor {
        return WorkRequestViewReactor(provider: self.provider, workspaceId: self.workspaceId, serviceId: self.serviceId, serviceUnitId: serviceUnitId)
    }
}
