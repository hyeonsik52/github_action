//
//  RecipientsUsersViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import Apollo

class RecipientUserViewReactor: Reactor {

    enum Action {
        case setTableViewSection
        case setCollectionViewSection
        case didSelectTableViewCell(IndexPath)
        case didSelectCollectionViewCell(String)
    }

    enum Mutation {
        case setLoading(Bool)
        case updateTableViewSection(RecipientUserSection)
        case updateCollectionViewSection
        case updateTableViewSectionItem(IndexPath, RecipientUserSection.Item)
    }

    struct State {
        var isLoading: Bool
        var tableViewSection: [RecipientUserSection]
        var collectionViewSection: [RecipientUserCollectionViewSection]
    }

    var initialState: State {
        return .init(isLoading: false, tableViewSection: [], collectionViewSection: [])
    }

    let provider: ManagerProviderType
    
    let workspaceId: String
    
    var serviceUnitModel: CreateServiceUnitModel

    init(provider: ManagerProviderType, workspaceId: String, serviceUnitModel: CreateServiceUnitModel) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceUnitModel = serviceUnitModel
    }

    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .setTableViewSection:

            return .concat([
                .just(.setLoading(true)),

                self.provider.networkManager
                    .fetch(UsersByWorkspaceIdQuery(workspaceId: self.workspaceId))
                    .compactMap { $0.signedUser?.joinedWorkspaces?.edges.compactMap { $0?.node }.first }
                    .compactMap { $0.members?.edges.compactMap { $0?.node } }
                    .compactMap { $0.map { $0.fragments.memberFragment } }
                    .flatMap { members -> Observable<Mutation> in
                        let items = members
                            .compactMap { RecipientCellModel(user: $0) }
                            .sorted { $0.name.koreanCompare($1.name) }
                            .map(RecipientUserCellReactor.init)

                        let section = RecipientUserSection(items: items)
                        return .just(.updateTableViewSection(section))
                },

                .just(.setLoading(false))
            ])

        case .setCollectionViewSection:
            return .just(.updateCollectionViewSection)

        case let .didSelectTableViewCell(indexPath):
            let user = self.currentState.tableViewSection[indexPath.section].items[indexPath.row]
            user.initialState.isSelected = !user.initialState.isSelected

            return .concat([
                    .just(.updateTableViewSectionItem(indexPath, user)),
                    .just(.updateCollectionViewSection)
                ])
            
        case let .didSelectCollectionViewCell(id):
            if let rowIndex = self.currentState.tableViewSection[0].items.firstIndex(where: { $0.initialState.id == id }) {
                let user = self.currentState.tableViewSection[0].items[rowIndex]
                user.initialState.isSelected = !user.initialState.isSelected
                
                return .concat([
                    .just(.updateTableViewSectionItem(IndexPath.init(row: rowIndex, section: 0), user)),
                    .just(.updateCollectionViewSection)
                ])
            }
            return .empty()
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

        case .updateCollectionViewSection:
            let collectionViewSection = self.collectionViewSection()
            state.collectionViewSection = [collectionViewSection]
            return state

        case let .updateTableViewSectionItem(indexPath, item):
            state.tableViewSection[indexPath.section].items[indexPath.row] = item
            return state
        }
    }

    func collectionViewSection() -> RecipientUserCollectionViewSection {
        let collectionViewItems = self.currentState.tableViewSection.first?.items
            .filter { $0.initialState.isSelected == true }
            .map { RecipientUserCollectionViewCellReactor($0.initialState) }

        return RecipientUserCollectionViewSection(items: collectionViewItems ?? [])
    }


    func updateCreateServiceUnitModel() -> CreateServiceUnitModel {
        var serviceUnitModel = self.serviceUnitModel
        
//        let selectedRecipients = self.currentState.collectionViewSection.first?.items
//            .filter({ $0.initialState.isSelected == true })
//            .compactMap { CreateRecipientInput(targetIdx: $0.initialState.idx, targetType: .user) }
        
//        // isBypass 디폴트 값으로 초기화
//        serviceUnitModel.serviceUnit.info.isBypass = "false"
//        // isStopFixed 디폴트 값으로 초기화 (정차지를 먼저 선택한 경우 => true)
//        serviceUnitModel.serviceUnit.info.isStopFixed = "true"
//        // 선택된 recipient 로 업데이트
//        serviceUnitModel.serviceUnit.info.recipients = selectedRecipients ?? []
//        // stopType 디폴트 값으로 초기화
//        serviceUnitModel.serviceUnit.info.stopType = .startingPoint
//        // targetType 디폴트 값으로 초기화 (작업 위치를 장소이름으로 표기 할 때는 stop)
//        serviceUnitModel.serviceUnit.info.targetType = .stop
        
        serviceUnitModel.serviceUnit.recipients = self.currentState.collectionViewSection.first?.items
            .map { $0.initialState }
            .filter { $0.isSelected }
            .map { .init(id: $0.id, userName: $0.ID, displayName: $0.name, email: nil, phonenumber: nil) } ?? []
        
        return serviceUnitModel
    }
}
