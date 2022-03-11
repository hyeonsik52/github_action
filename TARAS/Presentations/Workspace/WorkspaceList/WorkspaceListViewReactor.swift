//
//  WorkspaceListViewReactor.swift
//
//  Created by Suzy Park on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class WorkspaceListViewReactor: Reactor {
    
    enum Text {
        static let joinRequesting = "가입 신청 중"
        static let joined = "내 워크스페이스"
    }
    
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
            sections: [],
            entranceType: .none
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return self.provider.networkManager.fetch(MyWorkspacesQuery())
                .compactMap { $0.signedUser }
                .map { result -> Mutation in
                    
                    let joinRequestingWorkspaces = result.awaitingToJoinWorkspaces?.edges
                        .compactMap(\.?.node?.fragments.onlyWorkspaceFragment)
                        .map(Workspace.init)
                        .sorted(by: { $0.name < $1.name })
                        .map(WorkspaceListCellReactor.init) ?? []
                    
                    let joinedWorkspaces = result.joinedWorkspaces?.edges
                        .compactMap(\.?.node?.fragments.workspaceFragment)
                        .map(Workspace.init)
                        .sorted(by: { $0.name < $1.name })
                        .map(WorkspaceListCellReactor.init) ?? []
                    
                    var sections = [WorkspaceListSection]()
                    
                    if !joinRequestingWorkspaces.isEmpty {
                        sections.append(.init(header: Text.joinRequesting, items: joinRequestingWorkspaces))
                    }
                    if !joinedWorkspaces.isEmpty {
                        sections.append(.init(header: Text.joined, items: joinedWorkspaces))
                    }
                    
                    return .setSection(sections)
                }
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
        let workspaceCode = workspaceListCellReactor.currentState.code
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
