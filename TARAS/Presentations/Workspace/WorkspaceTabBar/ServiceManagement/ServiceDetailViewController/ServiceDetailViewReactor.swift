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
    
    enum Mode {
        case none
        
        /// 서비스 준비중 상태에서 사용 (서비스 요청 탭)
        case preparing
        
        /// 서비스 진행 상태 ('작업요청서 > 목적지' 에서만 사용)
        case processing
        
        /// 서비스 진행중~완료 상태에서 사용 (내 서비스 탭)
        case preview
    }
    
    enum Action {
        case loadService(refresh: Bool)
        case cancelRequest
        case deleteService
        case judgeIsFromPush
    }
    
    enum Mutation {
        case loadedService(ServiceModel)
        case requestCanceled(Bool)
        case servceDeleted(Bool)
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case isProcessing(Bool)
        case updateIsFromPush(Bool)
    }
    
    struct State {
        var serviceModel: ServiceModel?
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
    let swsIdx: Int
    let serviceIdx: Int
    let mode: Mode
    let pushInfo: NotificationInfomation?
    
    init(
        mode: Mode,
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceIdx: Int,
        pushInfo: NotificationInfomation? = nil
    ) {
        self.mode = mode
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceIdx = serviceIdx
        self.pushInfo = pushInfo

        self.provider.subscriptionManager.service(by: self.serviceIdx, swsIdx: self.swsIdx)
             .subscribe(onNext: { [weak self] result in
                 self?.action.onNext(.loadService(refresh: true))
             })
             .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadService(let refresh):
            let query = ServiceByServiceIdxQuery(swsIdx: self.swsIdx, serviceIdx: self.serviceIdx)
            let request = (refresh ? self.provider.networkManager.fetch(query): self.provider.networkManager.fetch(query))
            return .concat([
                .just(.isLoading(true)),
                
                request
                    .compactMap { $0.serviceByServiceIdx.asService }
                    .map { ServiceModel($0, with: self.provider.serviceManager) }
                    .map { Mutation.loadedService($0) },
                
                .just(.isLoading(false))
            ])
        case .cancelRequest:
            let input = CancelServiceInput(serviceIdx: self.serviceIdx)
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager.perform(CancelServiceMutationMutation(input: input))
                .map { $0.cancelServiceMutation.asCancelServicePayload?.result == "1" }
                .map { Mutation.requestCanceled($0) },
                
                .just(.isProcessing(false))
            ])
        case .deleteService:
            let input = HideServiceInput(serviceIdx: self.serviceIdx)
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager.perform(HideServiceMutationMutation(input: input))
                .map { $0.hideServiceMutation.asHideServicePayload?.result == "1" }
                .map { Mutation.servceDeleted($0) },
                
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
        return ServiceBasicInfoViewReactor(provider: self.provider, swsIdx: self.swsIdx, serviceIdx: self.serviceIdx)
    }
    
    func reactorForDetailLog() -> ServiceDetailLogViewReactor {
        return ServiceDetailLogViewReactor(provider: self.provider, swsIdx: self.swsIdx, serviceIdx: self.serviceIdx)
    }
    
    func reactorForWorkRequest(with serviceUnitIdx: Int) -> WorkRequestViewReactor {
        return WorkRequestViewReactor(provider: self.provider, swsIdx: self.swsIdx, serviceIdx: self.serviceIdx, serviceUnitIdx: serviceUnitIdx)
    }
}
