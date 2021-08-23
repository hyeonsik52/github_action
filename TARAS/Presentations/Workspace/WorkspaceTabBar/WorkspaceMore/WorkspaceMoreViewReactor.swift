//
//  WorkspaceMoreViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/25.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import ReactorKit

class WorkspaceMoreViewReactor: Reactor {
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    enum Action {
        case refresh
        case requestQuitSWS
    }
    
    enum Mutation {
        case loadedUserInfo(UserInfo?)
        case loadedWorkspaceInfo(Workspace?)
        case setLoading(Bool?)
        case updateDidQuitSWS(Bool)
        case updateAlertMessage(String)
    }
    
    struct State {
        var userInfo: UserInfo?
        var workspace: Workspace?
        var isLoading: Bool?
        var alertMessage: String
        var didQuitSWS: Bool
    }
    
    var initialState: State {
        return .init(userInfo: nil, workspace: nil, isLoading: nil, alertMessage: "", didQuitSWS: false)
    }
    
    let provider : ManagerProviderType
    let swsIdx: Int
    
    init(provider: ManagerProviderType, swsIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.setLoading(true)),
                
                self.provider.networkManager
                    .fetch(MyUserInfoQuery(swsIdx: self.swsIdx))
                    .map{UserInfo($0.myUserInfo.asUser)}
                    .map{Mutation.loadedUserInfo($0)},
                
                self.provider.networkManager
                    .fetch(SwsBySwsIdxQuery(swsIdx: self.swsIdx))
                    .map{ Workspace(sws: $0.swsBySwsIdx.asSws) }
                    .map{ Mutation.loadedWorkspaceInfo($0) },
                
                .just(.setLoading(false))
            ])
            
        case .requestQuitSWS:
            let input = RequestQuitSWSInput(swsIdx: self.swsIdx)
            
            return self.provider.networkManager.perform(RequestQuitSwsMutation(input: input))
                .map { $0.requestQuitSwsMutation }
                .flatMap { data -> Observable<Mutation> in
                    if let payload = data.asRequestQuitSwsPayload {
                        if payload.result == "1" {
                            self.provider.userManager.userTB.update {
                                $0.lastWorkspaceIdx.value = nil
                            }
                            return .just(.updateDidQuitSWS(true))
                        }
                    }
                    if let errorCode = data.asRequestQuitSwsError?.errorCode {
                        if errorCode == .swsNotExist {
                            return .just(.updateAlertMessage("존재하지 않는 워크스페이스입니다."))
                        } else if errorCode == .forbidden {
                            return .just(.updateAlertMessage("이미 탈퇴한 워크스페이스입니다."))
                        }
                    }
                    return .empty()
            }.catchErrorJustReturn(.updateAlertMessage("네트워크 상태가 원활하지 않습니다. (잠시 후에 다시 시도해 주세요.)"))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadedUserInfo(info):
            state.userInfo = info
            
        case let .loadedWorkspaceInfo(workspace):
            state.workspace = workspace
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .updateAlertMessage(alertMessage):
            state.alertMessage = alertMessage
            
        case let .updateDidQuitSWS(didQuitSWS):
            state.didQuitSWS = didQuitSWS
        }
        return state
    }
    
    //워크스페이스 정보
    func reactorForWorkspaceInfo() -> WorkspaceInfoViewReactor {
        return WorkspaceInfoViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    //프로필 이미지 변경
    func reactorForProfileImageUpdate() -> WorkspaceMoreViewReactor {
        return WorkspaceMoreViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    //이름 변경
    func reactorForNameUpdate() -> UpdateNameViewReactor {
        return UpdateNameViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            placeholder: self.currentState.userInfo?.swsUserInfo?.name ?? ""
        )
    }
    
    //이메일 변경
    func reactorForEmailUpdate() -> UpdateEmailViewReactor {
        return UpdateEmailViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            placeholder: self.currentState.userInfo?.swsUserInfo?.email ?? ""
        )
    }
    
    //전화번호 변경
    func reactorForPhoneNumberUpdate() -> UpdatePhoneNumberViewReactor {
        let phoneNumber = self.currentState.userInfo?.swsUserInfo?.phoneNumber ?? ""
        let placeholder = self.provider.userManager.denationalizePhoneNumber(phoneNumber)
        
        return UpdatePhoneNumberViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            placeholder: placeholder
        )
    }
    
    //내가 속한 그룹
    func reactorForGroups() -> BelongingGroupListViewReactor {
        return BelongingGroupListViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    //기본 위치 선택
    func reactorForSelectDefaultPlace() -> SelectDefaultPlaceViewReactor {
        return SelectDefaultPlaceViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    //워크스페이스 탈퇴
    func reactorForWithdrawWorkspace() -> WorkspaceMoreViewReactor {
        return WorkspaceMoreViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
    
    //기본 정보 설정
    func reactorForDefaultMyInfo() -> DefaultMyInfoViewReactor {
        return DefaultMyInfoViewReactor(provider: self.provider)
    }
    
//    //도움말
//    func reactorForHelp() -> Hel {
//        return WorkspaceMoreViewReactor(provider: self.provider, swsIdx: self.swsIdx)
//    }
    
    //문의하기
    func reactorForContact() -> WorkspaceMoreViewReactor {
        return WorkspaceMoreViewReactor(provider: self.provider, swsIdx: self.swsIdx)
    }
}
