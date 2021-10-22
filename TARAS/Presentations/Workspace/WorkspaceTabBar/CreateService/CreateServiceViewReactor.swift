//
//  CreateServiceViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import MobileCoreServices

class CreateServiceViewReactor: Reactor {

    enum Action {
        case appendServiceUnit(CreateServiceUnitModel)
        case deleteServiceUnit(IndexPath)
        case updateServiceUnit(IndexPath, CreateServiceUnitModel)
        case moveServiceUnit(IndexPath, IndexPath)
        case setRequest
    }

    enum Mutation {
        
        case insertSectionItem(IndexPath, CreateServiceSection.Item)
        case updateSectionItem(IndexPath, CreateServiceSection.Item)
        case deleteSectionItem(IndexPath)
        case moveSectionItem(IndexPath, IndexPath)
        case updateServiceId(String)
        case updateIsLoading(Bool)
        case updateIsNetworking(Bool)
        case scrollToFooter(Bool)
    }

    struct State {
        var section: [CreateServiceSection]
        
        /// 서비스 생성 요청의 payload 입니다.
        /// 서비스가 정상적으로 생성되었음을 확인하고 안내 팝업을 띄우는 용도로 사용합니다.
        var serviceId: String?
        
        /// activity indicator 의 작동 상태입니다.
        var isLoading: Bool
        
        /// '서비스 생성' 통신 중인지를 나타내는 상태입니다.
        var isNetworking: Bool
        
        var scrollToFooter: Bool
    }

    var initialState: State {
        return .init(
            section: [CreateServiceSection(items: [])],
            serviceId: nil,
            isLoading: false,
            isNetworking: false,
            scrollToFooter: false
        )
    }

    let provider: ManagerProviderType
    
    var workspaceId: String
    
    var serviceUnits = [CreateServiceUnitModel]()

    var draggedModel: CreateServiceSection.Item?

    init(provider: ManagerProviderType, workspaceId: String) {
        self.provider = provider
        self.workspaceId = workspaceId
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .appendServiceUnit(serviceUnitModel):
            self.serviceUnits.append(serviceUnitModel)
            
            let indexPath = IndexPath(row: self.serviceUnits.count - 1, section: 0)
            let item = CreateServiceCellReactor(
                provider: self.provider,
                workspaceId: self.workspaceId,
                serviceUnitModel: serviceUnitModel
            )
            
            return .concat([
                .just(.scrollToFooter(true)),
                .just(.insertSectionItem(indexPath, item))
            ])

        case let .deleteServiceUnit(indexPath):
            self.serviceUnits.remove(at: indexPath.row)
            return .concat([
                .just(.scrollToFooter(false)),
                .just(.deleteSectionItem(indexPath))
            ])

        case let .updateServiceUnit(indexPath, serviceUnitModel):
            self.serviceUnits[indexPath.row] = serviceUnitModel
            
            let item = CreateServiceCellReactor(
                provider: self.provider,
                workspaceId: self.workspaceId,
                serviceUnitModel: serviceUnitModel
            )
            return .concat([
                .just(.scrollToFooter(false)),
                .just(.updateSectionItem(indexPath, item))
            ])
        
        case let .moveServiceUnit(sourceIndexPath, destinationIndexPath):
            
            let movedItem = self.serviceUnits.remove(at: sourceIndexPath.row)
            self.serviceUnits.insert(movedItem, at: destinationIndexPath.row)
            
            return .concat([
                .just(.scrollToFooter(false)),
                .just(.moveSectionItem(sourceIndexPath, destinationIndexPath))
            ])

        case .setRequest:
            print()
            
//            // 서버 측 모델 형태로 풀기 전, 목적지의 stopType 을 일괄 업데이트합니다.
//            let serviceUnits = self.updateStopType(of: self.serviceUnits)
//
//            // 서버 측 모델 형태로 풉니다.
//            let serviceUnitInputs = self.serviceUnitInputs(from: serviceUnits)
//
//            let serviceInput = CreateServiceInput(
//                mode: serviceMode,
//                serviceUnits: serviceUnitInputs,
//                swsIdx: self.swsIdx
//            )
//
//            Log.info("SERVICE WILL BE REQUESTED: \(serviceInput)")
//
//            return .concat([
//                    .just(.updateIsLoading(true)),
//                    .just(.updateIsNetworking(true)),
//
//                self.provider.networkManager
//                    .perform(CreateServiceMutation(input: serviceInput))
//                    .compactMap { $0.createServiceMutation.asService }
//                    .map { Mutation.updateServiceIdx($0.serviceIdx) }
//                    .catchErrorJustReturn(.updateIsLoading(false))
//                    .catchErrorJustReturn(.updateIsNetworking(false)),
//
//                    .just(.updateIsLoading(false)),
//                    .just(.updateIsNetworking(false))
//            ])
            return .empty()
        }
    }
    
//    func serviceUnitInputs(from serviceUnitModels: [CreateServiceUnitModel]) -> [CreateServiceUnitInput] {
//        var serviceUnitInputs = [CreateServiceUnitInput]()
//
//        for model in serviceUnitModels {
//            let input = model.serviceUnit.info
//            serviceUnitInputs.append(input)
//        }
//
//        return serviceUnitInputs
//    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .insertSectionItem(indexPath, item):
            
            state.section[indexPath.section].items.insert(item, at: indexPath.row)

        case let .updateSectionItem(indexPath, item):
            state.section[indexPath.section].items[indexPath.row] = item
            
        case let .deleteSectionItem(indexPath):
            state.section[indexPath.section].items.remove(at: indexPath.row)

        case let .moveSectionItem(sourceIndexPath, destinationIndexPath):
            let sectionItem = state.section[sourceIndexPath.section].items.remove(at: sourceIndexPath.row)
            state.section[destinationIndexPath.section].items.insert(sectionItem, at: destinationIndexPath.row)
            
        case let .updateServiceId(serviceId):
            state.serviceId = serviceId

        case let .updateIsLoading(isLoading):
            state.isLoading = isLoading
            
        case let .updateIsNetworking(isNetworking):
            state.isNetworking = isNetworking
            
        case let .scrollToFooter(scrollToFooter):
            state.scrollToFooter = scrollToFooter
        }
        return state
    }

    func reactorForTarget() -> CSUTargetViewReactor {
        return CSUTargetViewReactor(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnitModel: nil
        )
    }

    func reactorForTargetChanging(rowIndex: Int) -> CSUTargetViewReactor {
        return CSUTargetViewReactor(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnitModel: self.serviceUnits[rowIndex]
        )
    }
    
    func reactorForDetail(_ indexPath: IndexPath) -> CSUDetailViewReactor {
        return CSUDetailViewReactor(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnitModel: self.serviceUnits[indexPath.row],
            isEditing: true,
            indexOfEditingRow: indexPath.row
        )
    }

    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let model = self.currentState.section[0].items[indexPath.row]
        self.draggedModel = model

        let name = model.serviceUnitModel.serviceUnit.targetName
        let data = name.data(using: .utf8)
        let itemProvider = NSItemProvider()

        itemProvider.registerDataRepresentation(
            forTypeIdentifier: kUTTypePlainText as String,
            visibility: .all
        ) { completion in
            completion(data, nil)
            return nil
        }
        return [UIDragItem(itemProvider: itemProvider)]
    }

    func draggedItem(session: UIDropSession) -> Bool {
        guard let model = self.draggedModel else { return false }
        return model.canHandle(session)
    }
}
