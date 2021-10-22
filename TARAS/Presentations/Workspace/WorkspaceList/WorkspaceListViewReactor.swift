//
//  WorkspaceListViewReactor.swift
//
//  Created by Suzy Park on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import RxDataSources
import RxSwift
import FirebaseMessaging

final class WorkspaceListViewReactor: Reactor {
    
    enum EntranceType {
        /// 로그인 화면에서 들어온 경우
        case signIn
        
        /// 런치스크린에서 들어온 경우 (자동 로그인)
        case launch
        
        /// 푸시 알림(워크스페이스 가입 승인, 거절)으로 들어온 경우
        case push
        
        case none
    }
    
    enum Action {
        case refresh
        case updateFCMToken
        case judgeEntrance
    }
    
    enum Mutation {
        case setSection([WorkspaceListSection])
        case updateEntrance
    }
    
    struct State {
        var isPlaceholderHidden: Bool
        var sections: [WorkspaceListSection]
        var entranceType: EntranceType
    }
    
    let provider: ManagerProviderType
    var isFrom: EntranceType
    
    let initialState: State
    
    init(provider: ManagerProviderType, isFrom: EntranceType) {
        self.provider = provider
        self.isFrom = isFrom
        
        self.initialState = .init(
            isPlaceholderHidden: true,
            sections: [WorkspaceListSection(header: "", items: [])],
            entranceType: .none
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
//            return .zip(
//                self.provider.workspaceManager.workspacesRequested(),
//                self.provider.workspaceManager.workspacesJoined()
//            ){ requested, joined in
//                let requestedItems = requested
//                    .map { WorkspaceListCellModel.init(requested: $0) }
//                    .map(WorkspaceListCellReactor.init)
//                let requestedSection = WorkspaceListSection(header: "가입 신청 중", items: requestedItems)
//
//                let joinedItems = joined
//                    .map { WorkspaceListCellModel.init(joined: $0) }
//                    .map(WorkspaceListCellReactor.init)
//                let joinedSection = WorkspaceListSection(header: "내 워크스페이스", items: joinedItems)
//
//                if requestedItems.count == 0 && joinedItems.count == 0 {
//                    return .setSection([])
//                }
//
//                if requestedItems.count != 0 && joinedItems.count == 0 {
//                    return .setSection([requestedSection])
//                }
//
//                if requestedItems.count == 0 && joinedItems.count != 0 {
//                    return .setSection([joinedSection])
//                }
//
//                return .setSection([requestedSection, joinedSection])
//            }
            return .empty()
        case .updateFCMToken:
//            Messaging.messaging().token { token, error in
//                if let token = token,
//                    let deviceUniqueKey = UIDevice.current.identifierForVendor?.uuidString,
//                    self.provider.userManager.userTB.accessToken.count > 0
//                {
//                    let input = UpdateFcmRegistrationIdInput(
//                        clientType: "ios",
//                        deviceUniqueKey: deviceUniqueKey,
//                        registrationId: token
//                    )
//
//                    Log.debug("\(input)")
//
//                    let _ = self.provider.networkManager
//                        .perform(UpdateFcmTokenMutation(input: input))
//                        .map { $0.updateFcmRegistrationIdMutation }
//                        .flatMap { data -> Observable<Mutation> in
//                            if let payload = data.asUpdateFcmRegistrationIdPayload {
//                                if payload.result.isTrue {
//                                    Log.complete("updated FCM token to server")
//                                }
//                            }
//                            if let error = data.asUpdateFcmRegistrationIdError {
//                                Log.err("failed to update FCM token to server: \(error.errorCode)")
//                            }
//                            return .empty()
//                    }
//                }
//            }
            return .empty()
            
        case .judgeEntrance:
            return .just(.updateEntrance)
            
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setSection(sections):
            state.sections = sections
            state.isPlaceholderHidden = (sections.count > 0)
            
        case .updateEntrance:
            state.entranceType = self.isFrom
        }
        return state
    }
    
    func reactorForSearch() -> WorkspaceSearchViewReactor {
        return WorkspaceSearchViewReactor(provider: self.provider)
    }
    
    func reactorForSWSHome(workspaceId: String) -> WorkspaceTabBarControllerReactor {
        return WorkspaceTabBarControllerReactor(provider: self.provider, workspaceId: workspaceId)
    }
    
    func reactorForResult(
        _ workspaceListCellReactor: WorkspaceListCellReactor
    ) -> WorkspaceSearchResultViewReactor? {
        guard let workspaceCode = workspaceListCellReactor.currentState.code else { return nil }
        return WorkspaceSearchResultViewReactor(
            provider: self.provider,
            workspaceCode: workspaceCode
        )
    }
    
    //기본 정보 설정
    func reactorForDefaultMyInfo() -> DefaultMyInfoViewReactor {
        return DefaultMyInfoViewReactor(provider: self.provider)
    }
}
