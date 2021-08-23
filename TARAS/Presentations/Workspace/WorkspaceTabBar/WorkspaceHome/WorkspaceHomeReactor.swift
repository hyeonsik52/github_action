//
//  WorkspaceHomeReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/24.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

class WorkspaceHomeReactor: Reactor {
    
    typealias ReceivedService = ReceivedServices.Service
    typealias SendedService = CreatedServices.Service
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()
    
    enum Action {
        case loadMyInfo
        case loadWorkspaceInfo
        case loadServices
        case updateLastWorkspaceIdx
        case judgeIsFromPush
        
        #if TEST
        /// 서비스 간편 생성 API 요청을 위한 '생성' 버튼 tap 액션
        case requestShortcutService(Int)
        #endif
    }
    
    enum Mutation {
        case loadedMyInfo(UserInfo?)
        case loadedWorkspaceInfo(Workspace?)
        case loadedReceivedServices([ServiceUnitModelSet])
        case loadedSendedServices([ServiceModel])
        case isLoading(Bool?) //초기 상태 nil, 로딩 시작 true, 로딩 종료 false/ nil에서 true가 된 경우일 때만 스켈레톤 뷰 출력
        case isProcessing(Bool?) //추가 로딩
        case updateIsFromPush(Bool)
    }
    
    struct State {
        var myUserInfo: UserInfo?
        var worspace: Workspace?
        var receivedServices: [ServiceUnitModelSet]
        var sendedServices: [ServiceModel]
        var isLoading: Bool?
        var isProcessing: Bool?
        var isFromPush: Bool
    }
    
    var initialState: State {
        return State(
            myUserInfo: nil,
            worspace: nil,
            receivedServices: self.provider.serviceManager.dummyServiceUnitSetList(6),
            sendedServices: self.provider.serviceManager.dummyServices(2, serviceUnitCount: 7),
            isLoading: nil,
            isProcessing: nil,
            isFromPush: false
        )
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    let pushInfo: NotificationInfomation?
    
    #if TEST
    let isPresetCreateSuccess = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()
    #endif
    
    init(provider: ManagerProviderType, swsIdx: Int, pushInfo: NotificationInfomation? = nil) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.pushInfo = pushInfo
        
        self.provider.subscriptionManager.service(by: self.swsIdx)
            .subscribe(onNext: { [weak self] result in
                self?.action.onNext(.loadServices)
                })
            .disposed(by: self.disposeBag)

        self.provider.subscriptionManager.hiddenService()
            .subscribe(onNext: { [weak self] result in
                self?.action.onNext(.loadServices)
            })
            .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadMyInfo:
            return self.provider.networkManager
                .fetch(MyUserInfoQuery(swsIdx: self.swsIdx))
                .map{ UserInfo($0.myUserInfo.asUser) }
                .map{ Mutation.loadedMyInfo($0) }
            
        case .loadWorkspaceInfo:
            return self.provider.networkManager
                .fetch(SwsBySwsIdxQuery(swsIdx: self.swsIdx))
                .map{ Workspace(sws: $0.swsBySwsIdx.asSws) }
                .map{ Mutation.loadedWorkspaceInfo($0) }
            
        case .loadServices:
            return .concat([
                .just(.isLoading(true)),
                
                self.provider.networkManager
                    .fetch(ReceivedServicesConnectionQuery(swsIdx: self.swsIdx, phase: .initiation, status: [.waitingResponse, .pause], before: nil, last: 2147483647))
                    .map{ $0.receivedServicesConnection.edges.compactMap{$0.node} }
                    .map{ $0.map{ServiceModel($0, with: self.provider.serviceManager)} }
                    .map { services -> [ServiceUnitModelSet] in
                        services
                        //서비스 요청 취소 상태가 아니어야 함
                            .filter { $0.status != .canceledOnWaiting }
                            .map { service -> [ServiceUnitModelSet] in
                                service.serviceUnitList
                                    //내가 수신자에 포함되고, 거절하지 않은 경우, 다른 그룹원이 그룹 거절하지 않고, 다른 개인이 수락하지 않은 경우
                                    .filter { $0.amIRecipient && !$0.amIRejector && !$0.isGroupRejected && !$0.isAnotherAccepted }
                                    .map{ServiceUnitModelSet(service: service, serviceUnit: $0)}
                        }.flatMap{$0}
                }
                .map { Mutation.loadedReceivedServices($0) },
                
                self.provider.networkManager
                    .fetch(CreatedServicesConnectionQuery(swsIdx: self.swsIdx, phase: .initiation, status: [.waitingResponse, .waitingRobotAssignment, .pause], last: 2147483647))
                    .map{ $0.createdServicesConnection.edges.compactMap{$0.node} }
                    .map { $0.map { ServiceModel($0, with: self.provider.serviceManager) }
                        ///내가 생성한 서비스만 보여줌
                        .filter { $0.creator.isMe }}
                    .map{ Mutation.loadedSendedServices($0) },
                
                .just(.isLoading(false))
            ])
            
        case .updateLastWorkspaceIdx:
            let userTB = self.provider.userManager.userTB
            userTB.update { $0.lastWorkspaceIdx.value ??= self.swsIdx }
            return .empty()
            
        case .judgeIsFromPush:
            let isFromPush = (self.pushInfo != nil)
            return .just(.updateIsFromPush(isFromPush))
            
        #if TEST
        case .requestShortcutService(let presetServiceIdx):
            
            let input = CreateServiceWithPresetInput(presetServiceIdx: presetServiceIdx, swsIdx: self.swsIdx)
            let mutation = CreateServiceWithPresetMutation(input: input)
            
            return .concat([
                .just(.isProcessing(true)),
                
                self.provider.networkManager.perform(mutation)
                    .map { $0.createServiceWithPresetMutation }
                    .flatMap { result -> Observable<Mutation> in
                        
                        if let typeErrorCode = result.asTypeError?.typeErrorCode {
                            let errorMessage = "타입 오류가 발생하였습니다. (Error code: \(typeErrorCode.rawValue)"
                            self.errorMessage.onNext(errorMessage)
                        }
                        
                        if let presetErrorCode = result.asCreateServiceWithPresetError?.presetErrorCode {
                            let errorMessage = "간편 생성 오류가 발생하였습니다. (Error code: \(presetErrorCode.rawValue)"
                            self.errorMessage.onNext(errorMessage)
                        }
                        
                        if let _ = result.asService?.serviceIdx {
                            let message = "간편 서비스가 생성되었습니다."
                            message.sek.showToast()
                            self.isPresetCreateSuccess.onNext(true)
                        }
                        
                        return .just(.isProcessing(false))
                    },
                
                .just(.isProcessing(false))
            ])
            #endif
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedMyInfo(info):
            state.isFromPush = false
            state.myUserInfo = info
            
        case let .loadedWorkspaceInfo(workspace):
            state.isFromPush = false
            state.worspace = workspace
            
        case let .loadedReceivedServices(services):
            state.isFromPush = false
            let temp = Date()
            //수락자는 단위서비스 당 한 명만 존재할 수 있기 때문에, 수락한 사람이 없으면 답변 대기중이라고 판단함
            state.receivedServices = services
                .filter { !$0.serviceUnit.isAcceptorExisted }
                .sorted(by: {
                    $0.service.requestAt ?? temp > $1.service.requestAt ?? temp
                })
            
        case let .loadedSendedServices(services):
            state.isFromPush = false
            let temp = Date()
            //서비스 준비중: 답변대기중, 로봇배정중, 일시정지(이전: 답변대기중, 로봇배정중)
            state.sendedServices = services
                .filter { $0.isPreparingWaiting }
                .sorted(by: {
                    $0.requestAt ?? temp > $1.requestAt ?? temp
                })
            
        case .isLoading(let loading):
            state.isFromPush = false
            state.isLoading = loading
            
        case .isProcessing(let isProcessing):
            state.isProcessing = isProcessing
            
        case let .updateIsFromPush(isFromPush):
            state.isFromPush = isFromPush
        }
        return state
    }
    
    func reactorForCreateService() -> CreateServiceViewReactor {
        return CreateServiceViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    func reactorForSelectReceivedService(serviceIdx: Int, serviceUnitIdx: Int) -> WorkRequestViewReactor {
        return WorkRequestViewReactor(provider: self.provider, swsIdx: self.swsIdx, serviceIdx: serviceIdx, serviceUnitIdx: serviceUnitIdx)
    }
    
    func reactorForReceivedRequest() -> ServiceDetailViewReactor {
        return ServiceDetailViewReactor(
            mode: .preparing,
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceIdx: self.pushInfo?.serviceIdx ?? 0,
            pushInfo: self.pushInfo
        )
    }
    
    func reactorForSelectSendedService(mode: ServiceDetailViewReactor.Mode, serviceIdx: Int) -> ServiceDetailViewReactor {
        return ServiceDetailViewReactor(mode: mode, provider: self.provider, swsIdx: self.swsIdx, serviceIdx: serviceIdx)
    }
    
    func reactorForReceivedServiceList() -> PagingReceivedRequestReactor {
        return PagingReceivedRequestReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    func reactorForSendedServiceList() -> PagingSendedRequestReactor {
        return PagingSendedRequestReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
}
