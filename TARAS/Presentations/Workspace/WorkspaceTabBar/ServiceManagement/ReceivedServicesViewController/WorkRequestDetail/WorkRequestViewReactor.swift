//
//  WorkRequestViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa

class WorkRequestViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case refresh
        
        case accept(ServiceUnitResponseType)
        
        case reject(ServiceUnitResponseType)
        
        case beginWorking
        case endWorking
        //1단계 기능 제외
//        case retryWorking
//        case setRemainTime
    }
    
    enum Mutation {
        case loaded(ServiceModel?, ServiceUnitModel?)
        case accepted(Bool)
        case rejected(Bool)
        case started(Bool)
        case ended(Bool)
        //1단계 기능 제외
//        case retried(Bool)
        case loadedMyInfo(UserInfo?)
        //1단계 기능 제외
//        case retryTimeout(TimeInterval)
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case isProcessing(Bool)
        case setAlertMessage(String?)
    }
    
    struct State {
        var service: ServiceModel?
        var serviceUnit: ServiceUnitModel?
        var isAccepted: Bool?
        var isRejected: Bool?
        var isStarted: Bool?
        var isEnded: Bool?
        //1단계 기능 제외
//        var isRetry: Bool?
        var myInfo: UserInfo?
        //1단계 기능 제외
//        var retryTimeout: TimeInterval?
        var isLoading: Bool?
        var isProcessing: Bool?
        var alertMessage: String?
    }
    
    var initialState: State {
        return State(
            service: nil,
            serviceUnit: nil,
            isAccepted: nil,
            isRejected: nil,
            isStarted: nil,
            isEnded: nil,
            //1단계 기능 제외
//            isRetry: nil,
//            retryTimeout: nil,
            isLoading: nil,
            isProcessing: nil,
            alertMessage: nil
        )
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    let serviceIdx: Int
    let serviceUnitIdx: Int
    
    private var referenceTime: TimeInterval = 0
    
    init(
        provider: ManagerProviderType,
        swsIdx: Int,
        serviceIdx: Int,
        serviceUnitIdx: Int
    ) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceIdx = serviceIdx
        self.serviceUnitIdx = serviceUnitIdx

        self.provider.subscriptionManager.service(by: self.serviceIdx, swsIdx: self.swsIdx)
            .subscribe(onNext: { [weak self] result in
                self?.action.onNext(.refresh)
            })
            .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.isLoading(true)),
                
                self.provider.networkManager
                    .fetch(ServiceByServiceIdxQuery(swsIdx: self.swsIdx, serviceIdx: self.serviceIdx))
                    .compactMap { $0.serviceByServiceIdx.asService }
                    .map { ServiceModel($0, with: self.provider.serviceManager) }
                    .map { ($0, $0.serviceUnitList.first{$0.serviceUnitIdx == self.serviceUnitIdx}) }
                    .map(Mutation.loaded),
                
                self.provider.networkManager
                    .fetch(MyUserInfoQuery(swsIdx: self.swsIdx))
                    .map{UserInfo($0.myUserInfo.asUser)}
                    .map{Mutation.loadedMyInfo($0)},
                
                .just(.isLoading(false))
            ])
        case .accept(let type):
            let input = AcceptServiceUnitInput(responseType: type, serviceUnitIdx: self.serviceUnitIdx, stopIdx: self.currentState.serviceUnit?.place.idx)
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager
                    .perform(AcceptServiceUnitMutationMutation(input: input))
                    .map { $0.acceptServiceUnitMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let payload = data.asAcceptServiceUnitPayload {
                            let result = (payload.result == "1")
                            return .just(.accepted(result))
                        }else if let error = data.asAcceptServiceUnitError {
                            return .concat([
                                .just(.accepted(false)),
                                .just(.setAlertMessage(error.errorCode.message)),
                                .just(.setAlertMessage(nil))
                            ])
                        }
                        return .just(.accepted(false))
                },
                
                .just(.isProcessing(false))
            ])
        case .reject(let type):
            let input = RejectServiceUnitInput(responseType: type, serviceUnitIdx: self.serviceUnitIdx)
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager
                    .perform(RejectServiceUnitMutationMutation(input: input))
                    .map { $0.rejectServiceUnitMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let payload = data.asRejectServiceUnitPayload {
                            let result = (payload.result == "1")
                            return .just(.rejected(result))
                        }else if let error = data.asRejectServiceUnitError {
                            return .concat([
                                .just(.rejected(false)),
                                .just(.setAlertMessage(error.errorCode.message)),
                                .just(.setAlertMessage(nil))
                            ])
                        }
                        return .just(.rejected(false))
                },
                
                .just(.isProcessing(false))
            ])
        case .beginWorking:
            let input = StartServiceUnitInput(serviceUnitIdx: self.serviceUnitIdx)
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager
                    .perform(StartServiceUnitMutationMutation(input: input))
                    .map { $0.startServiceUnitMutation }
                    .flatMap { data -> Observable<Mutation> in
                        if let payload = data.asStartServiceUnitPayload {
                            let result = (payload.result == "1")
                            return .just(.started(result))
                        }else if let error = data.asStartServiceUnitError {
                            return .concat([
                                .just(.started(false)),
                                .just(.setAlertMessage(error.errorCode.message)),
                                .just(.setAlertMessage(nil))
                            ])
                        }
                        return .just(.started(false))
                },
                
                .just(.isProcessing(false))
            ])
        case .endWorking:
            let input = CompleteServiceUnitInput(serviceUnitIdx: self.serviceUnitIdx)
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager
                    .perform(CompleteServiceUnitMutationMutation(input: input))
                    .map { $0.completeServiceUnitMutation }
                    .flatMap { [weak self] data -> Observable<Mutation> in
                        if let payload = data.asCompleteServiceUnitPayload {
                            let result = (payload.result == "1")
                            if result {
                                self?.referenceTime = Date().timeIntervalSince1970
                                return .just(.ended(true))
                            }else{
                                return .just(.ended(false))
                            }
                        }else if let error = data.asCompleteServiceUnitError {
                            return .concat([
                                .just(.ended(false)),
                                .just(.setAlertMessage(error.errorCode.message)),
                                .just(.setAlertMessage(nil))
                            ])
                        }
                        return .just(.ended(false))
                },
                
                .just(.isProcessing(false))
            ])
            
            //1단계 기능 제외
//        case .retryWorking:
//            let input = CancelServiceUnitCompletionInput(serviceUnitIdx: self.serviceUnitIdx)
//            return .concat([
//                .just(.isProcessing(true)),
//
//                self.provider.networkManager
//                    .perform(CancelServiceUnitCompletionMutationMutation(input: input))
//                    .map { $0.cancelServiceUnitCompletionMutation }
//                    .flatMap { data -> Observable<Mutation> in
//                        if let payload = data.asCancelServiceUnitCompletionPayload {
//                            let result = (payload.result == "1")
//                            return .just(.retried(result))
//                        }else if let error = data.asCancelServiceUnitCompletionError {
//                            return .concat([
//                                .just(.retried(false)),
//                                .just(.setAlertMessage(error.errorCode.message)),
//                                .just(.setAlertMessage(nil))
//                            ])
//                        }
//                        return .just(.retried(false))
//                },
//
//                .just(.isProcessing(false))
//            ])
//        case .setRemainTime:
//            let timeout: TimeInterval = 10//Int(self.currentState.service?.retryTimeout ?? 10)
//            let interval = timeout - (Date().timeIntervalSince1970 - self.referenceTime)
//            return (interval >= -1 ? .just(.retryTimeout(interval)): .empty())
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loaded(service, serviceUnit):
            state.service = service
            state.serviceUnit = serviceUnit
        case .accepted(let isSuccess):
            state.isAccepted = isSuccess
        case .rejected(let isSuccess):
            state.isRejected = isSuccess
        case .started(let isSuccess):
            state.isStarted = isSuccess
        case .ended(let isSuccess):
            state.isEnded = isSuccess
            //1단계 기능 제외
//        case .retried(let isSuccess):
//            state.isRetry = isSuccess
        case .loadedMyInfo(let info):
            state.myInfo = info
            //1단계 기능 제외
//        case .retryTimeout(let count):
//            state.retryTimeout = count
        case .isLoading(let loading):
            state.isLoading = loading
        case .isProcessing(let processing):
            state.isProcessing = processing
        case .setAlertMessage(let message):
            state.alertMessage = message
        }
        return state
    }
    
    func reactorForChangeWorkPlace(_ type: ServiceUnitResponseType) -> ChangeWorkPlaceViewReactor {
        let mySwsInfo = self.currentState.myInfo?.swsUserInfo
        let place = mySwsInfo?.place ?? mySwsInfo?.groupPlace ?? self.currentState.serviceUnit?.place
        return ChangeWorkPlaceViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitIdx: self.serviceUnitIdx,
            acceptType: type,
            place: place
        )
    }
    
    func reactorForWorkTargetList() -> WorkTargetsViewControllerReactor? {
        guard let serviceUnit = self.currentState.serviceUnit else { return nil }
        return WorkTargetsViewControllerReactor(provider: self.provider, swsIdx: self.swsIdx, serviceUnit: serviceUnit)
    }
    
    func reactorForServiceDetail(mode: ServiceDetailViewReactor.Mode) -> ServiceDetailViewReactor {
        return ServiceDetailViewReactor(mode: mode, provider: self.provider, swsIdx: self.swsIdx, serviceIdx: self.serviceIdx)
    }
    
    func reactorForSwsUserInfo(userIdx: Int) -> SWSUserInfoViewReactor {
        return SWSUserInfoViewReactor(provider: self.provider, swsIdx: self.swsIdx, userIdx: userIdx)
    }
}
