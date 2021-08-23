//
//  WorkspaceSearchViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class WorkspaceSearchViewReactor: Reactor {
    
    enum Action {
        case updateIsInitialOpen
        case updateCode(String)
        case confirmCode
    }
    
    enum Mutation {
        case setCode(String)
        case setLoading(Bool)
        case setResult(Result<WorkspaceInfoByCode, Error>)
    }
    
    struct State {
        var code: String?
        var errorMessage: String?
        var isLoading: Bool
        var workspaceInfo: WorkspaceListCellModel?
    }
    
    let provider: ManagerProviderType
    let initialState: State
    
    init(provider: ManagerProviderType) {
        self.provider = provider
        self.initialState = State(
            code: nil,
            errorMessage: nil,
            isLoading: false,
            workspaceInfo: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateCode(code):
            return .just(.setCode(code))
            
        case .confirmCode:
            guard let code = self.currentState.code,
                self.currentState.errorMessage == nil else {
                    return .empty()
            }

            return .concat([
                .just(.setLoading(true)),
                
                self.provider.workspaceManager
                    .serchWorkspace(by: code)
                    .map { Mutation.setResult($0) },
                
                .just(.setLoading(false))
            ])
            
        case .updateIsInitialOpen:
            let isInitialOpen = self.provider.userManager.userTB.isInitialOpen
            if isInitialOpen {
                self.provider.userManager.userTB.update {
                    $0.isInitialOpen = false
                }
            }
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setCode(code):
            state.code = code
            state.errorMessage = nil
            return state
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            state.workspaceInfo = nil
            return state
            
        case let .setResult(result):
            switch result {
            case let .success(workspaceInfo):
                let model = WorkspaceListCellModel(infoByCode: workspaceInfo)
                
                state.errorMessage = nil
                state.workspaceInfo = model
                return state
                
            case let .failure(error):
                if let _ = error as? SWSErrorCode {
                    state.errorMessage = "존재하지 않는 워크스페이스 코드입니다."
                    state.workspaceInfo = nil
                    return state
                }
                
                state.errorMessage = "네트워크/서버 연결이 원할하지 않습니다. 잠시 후 다시 시도해주세요."
                state.workspaceInfo = nil
                return state
            }
        }
    }

    func reactorForResult() -> WorkspaceSearchResultViewReactor? {
        guard let info = self.currentState.workspaceInfo else { return nil }
        
        return WorkspaceSearchResultViewReactor(
            provider: self.provider,
            workspaceListCellModel: info
        )
    }
}
