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
        case endWorking
    }
    
    enum Mutation {
        case loaded(Service?, ServiceUnit?)
        case ended(Bool)
        case loadedMyInfo(User?)
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case isProcessing(Bool)
        case setAlertMessage(String?)
    }
    
    struct State {
        var service: Service?
        var serviceUnit: ServiceUnit?
        var isEnded: Bool?
        var myInfo: User?
        var isLoading: Bool?
        var isProcessing: Bool?
        var alertMessage: String?
    }
    
    var initialState: State {
        return State(
            service: nil,
            serviceUnit: nil,
            isEnded: nil,
            isLoading: nil,
            isProcessing: nil,
            alertMessage: nil
        )
    }
    
    let provider : ManagerProviderType
    let workspaceId: String
    let serviceId: String
    let serviceUnitId: String
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceId: String,
        serviceUnitId: String
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceId = serviceId
        self.serviceUnitId = serviceUnitId
        
        //temp
//        self.provider.subscriptionManager.service(by: self.serviceId)
//            .subscribe(onNext: { [weak self] result in
//                self?.action.onNext(.refresh)
//            })
//            .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.isLoading(true)),
                
                //temp
//                self.provider.networkManager
//                    .fetch(ServiceQuery(serviceId: self.serviceId))
//                    .compactMap { $0.hiGlovisServiceByOrderId?.fragments.serviceFragment }
//                    .compactMap { self.provider.serviceManager.convert(service: $0) }
//                    .map { ($0, $0.serviceUnits.first{$0.id == self.serviceUnitId}) }
//                    .map(Mutation.loaded),
                
                self.provider.networkManager
                    .fetch(MyUserInfoQuery())
                    .compactMap(\.signedUser?.fragments.userFragment)
                    .map{Mutation.loadedMyInfo(.init($0))},
                
                .just(.isLoading(false))
            ])
        
        case .endWorking:
            let step = currentState.serviceUnit?.orderWithinService ?? 0
            let mutation = CompleteServiceUnitMutation(serviceId: self.serviceId, serviceStep: step)
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .flatMap { data -> Observable<Mutation> in
                        if data.completeServiceUnit?.ok == true {
                            return .just(.ended(true))
                        } else {
                            return .concat([
                                .just(.ended(false)),
                                .just(.setAlertMessage("작업을 완료하지 못했습니다. 다시 시도해주세요.")),
                                .just(.setAlertMessage(nil))
                            ])
                        }
                },
                
                .just(.isProcessing(false))
            ])
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loaded(service, serviceUnit):
            state.service = service
            state.serviceUnit = serviceUnit
        case .ended(let isSuccess):
            state.isEnded = isSuccess
        case .loadedMyInfo(let info):
            state.myInfo = info
        case .isLoading(let loading):
            state.isLoading = loading
        case .isProcessing(let processing):
            state.isProcessing = processing
        case .setAlertMessage(let message):
            state.alertMessage = message
        }
        return state
    }
    
    func reactorForSwsUserInfo(userId: String) -> SWSUserInfoViewReactor {
        return SWSUserInfoViewReactor(provider: self.provider, workspaceId: self.workspaceId, userId: userId)
    }
}
