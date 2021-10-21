//
//  TargetUserViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import Apollo

class TargetStopViewReactor: Reactor {
    
    enum Action {
        case loadSections
        case refreshSections
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSections([TargetStopSection])
    }
    
    struct State {
        var isLoading: Bool
        var sections: [TargetStopSection]
    }
    
    var initialState: State {
        return .init(isLoading: false, sections: [])
    }
    
    let provider: ManagerProviderType
    
    let workspaceId: String
    
    var serviceUnitModel: CreateServiceUnitModel?
    
    init(provider: ManagerProviderType, workspaceId: String, serviceUnitModel: CreateServiceUnitModel?) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceUnitModel = serviceUnitModel
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        func loadSection() -> Observable<Mutation> {
            return self.provider.networkManager
                .fetch(StopsByWorkspaceIdQuery(workspaceId: self.workspaceId))
                .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first }
                .compactMap(\.?.node?.stationGroups?.edges)
                .flatMap { [weak self] edges -> Observable<Mutation> in

                    let serviceUnitInfo = self?.serviceUnitModel?.serviceUnit
                    let stopId = serviceUnitInfo?.targetId

                    let items = edges.compactMap(\.?.node?.fragments.stopFragment)
                        .compactMap { TargetStopCellModel(stop: $0, selectedTargetStopId: stopId) }
                        .sorted(by: { $0.name < $1.name })
                        .map(TargetStopCellReactor.init)

                    let section = TargetStopSection(items: items)
                    return .just(.setSections([section]))
            }
        }
        
        switch action {
        case .loadSections:
            return .concat([
                .just(.setLoading(true)),
                loadSection(),
                .just(.setLoading(false))
                ])
            
        case .refreshSections:
            return loadSection()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoding):
            state.isLoading = isLoding
            return state
            
        case let .setSections(sections):
            state.sections = sections
            return state
        }
    }
    
    func updateCreateServiceUnitInput(
        _ cellReactor: TargetStopCellReactor
    ) -> CreateServiceUnitModel {
        let target = cellReactor.currentState
        
        guard var serviceUnitModel = self.serviceUnitModel else {
            // 최초 '대상 선택' 인 경우, 새 unitInput 을 반환
//            let info = CreateServiceUnitInput(
//                message: nil,
//                recipients: [],
//                stopId: target.stopId
//            )
            
            return CreateServiceUnitModel(
                targetId: target.stopId,
                serviceUnitTargetName: target.name
            )
        }

        // 기존 unitInput이 있는 경우,
        
        serviceUnitModel.serviceUnit.targetName = target.name
//        // 기존 recipient 디폴트 값으로 초기화
//        serviceUnitModel.serviceUnit.info.recipients = []
//        // 선택된 정차지 위치로 업데이트
//        serviceUnitModel.serviceUnit.info.stopId = target.stopId

        return serviceUnitModel
    }
}
