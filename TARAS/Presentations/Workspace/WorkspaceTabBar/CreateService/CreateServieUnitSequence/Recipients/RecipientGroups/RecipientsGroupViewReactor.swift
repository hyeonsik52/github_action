//
//  RecipientsGroupViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import Apollo

class RecipientsGroupViewReactor: Reactor {
    
    enum Action {
        case setTableViewSection
    }
    
    enum Mutation {
        case setLoading(Bool)
        case updateTableViewSection(RecipientGroupSection)
    }
    
    struct State {
        var isLoading: Bool
        var tableViewSection: [RecipientGroupSection]
    }
    
    var initialState: State {
        return .init(isLoading: false, tableViewSection: [])
    }
    
    let provider: ManagerProviderType
    
    let swsIdx: Int
    
    var serviceUnitModel: CreateServiceUnitModel
    
    init(provider: ManagerProviderType, swsIdx: Int, serviceUnitModel: CreateServiceUnitModel) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceUnitModel = serviceUnitModel
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setTableViewSection:
            return .concat([
                .just(.setLoading(true)),
                
                self.provider.networkManager
                    .fetch(GroupListQuery(first: .max32, swsIdx: self.swsIdx))
                    .map { $0.swsGroupsConnection.edges }
                    .flatMap { edges -> Observable<Mutation> in
                        let items = edges
                            .compactMap { RecipientCellModel(group: $0.node) }
                            .sorted { $0.name.koreanCompare($1.name) }
                            .map(RecipientGroupCellReactor.init)
                        let section = RecipientGroupSection(items: items)
                        return .just(.updateTableViewSection(section))
                    },
                
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case let .updateTableViewSection(section):
            state.tableViewSection = [section]
            return state
        }
    }
    
    func updateCreateServiceUnitModel(_ reactor: RecipientGroupCellReactor) -> CreateServiceUnitModel {
        var serviceUnitModel = self.serviceUnitModel
        
        let recipient = reactor.currentState
        let selectedRecipient = CreateRecipientInput(targetIdx: recipient.idx, targetType: .group)
        
        // 선택된 recipient 로 업데이트 합니다.
        
        // isBypass 디폴트 값으로 초기화
        serviceUnitModel.serviceUnit.info.isBypass = "false"
        // isStopFixed 디폴트 값으로 초기화 (정차지를 먼저 선택한 경우 => true)
        serviceUnitModel.serviceUnit.info.isStopFixed = "true"
        // 선택된 recipient 로 업데이트
        serviceUnitModel.serviceUnit.info.recipients = [selectedRecipient]
        // stopType 디폴트 값으로 초기화
        serviceUnitModel.serviceUnit.info.stopType = .startingPoint
        // targetType 디폴트 값으로 초기화 (작업 위치를 장소이름으로 표기 할 때는 stop)
        serviceUnitModel.serviceUnit.info.targetType = .stop
        
        return serviceUnitModel
    }
}
