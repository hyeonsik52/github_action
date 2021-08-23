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
        case deleteBypass(IndexPath)
        case updateServiceUnit(IndexPath, CreateServiceUnitModel)
        case moveServiceUnit(IndexPath, IndexPath)
        case setRequest(ServiceMode)
        
//        case updateWaypointChange(Int, Int)
//        case updateWaypointAdded(Int, Int)
    }

    enum Mutation {
        
        case insertSectionItem(IndexPath, CreateServiceSection.Item)
        case updateSectionItem(IndexPath, CreateServiceSection.Item)
        case deleteSectionItem(IndexPath)
        case moveSectionItem(IndexPath, IndexPath)
        case updateServiceIdx(Int)
        case updateIsLoading(Bool)
        case updateIsNetworking(Bool)
        case scrollToFooter(Bool)
    }

    struct State {
        var section: [CreateServiceSection]
        
        /// 서비스 생성 요청의 payload 입니다.
        /// 서비스가 정상적으로 생성되었음을 확인하고 안내 팝업을 띄우는 용도로 사용합니다.
        var serviceIdx: Int?
        
        /// activity indicator 의 작동 상태입니다.
        var isLoading: Bool
        
        /// '서비스 생성' 통신 중인지를 나타내는 상태입니다.
        var isNetworking: Bool
        
        var scrollToFooter: Bool
    }

    var initialState: State {
        return .init(
            section: [CreateServiceSection(items: [])],
            serviceIdx: nil,
            isLoading: false,
            isNetworking: false,
            scrollToFooter: false
        )
    }

    let provider: ManagerProviderType
    
    var swsIdx: Int
    
    var serviceUnits = [CreateServiceUnitModel]()

    // TODO
//    var isWaypointIndexZero: Bool {
//        if let firstUnit = self.serviceInput.serviceUnits.first {
//            return firstUnit.isBypass == "true"
//        }
//        return false
//    }

    // TODO
//    var isAutoModeEnable: Bool {
//        let isWaypointExist = self.serviceInput.serviceUnits.contains(where: { $0.isBypass == "true" })
//        let isMoreThanFour = self.serviceInput.serviceUnits.count > 3
//        return !isWaypointExist && isMoreThanFour
//    }

    var draggedModel: CreateServiceSection.Item?

//    var serviceInput = CreateServiceInput(
//        mode: .auto,
//        serviceUnits: [],
//        swsIdx: 0
//    )

    init(provider: ManagerProviderType, swsIdx: Int) {
        self.provider = provider
        self.swsIdx = swsIdx
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .appendServiceUnit(serviceUnitModel):
            self.serviceUnits.append(serviceUnitModel)
            
            let indexPath = IndexPath(row: self.serviceUnits.count - 1, section: 0)
            let item = CreateServiceCellReactor(
                provider: self.provider,
                swsIdx: self.swsIdx,
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
            
//            let section = sectionFromRawData()
//            let selectedItem = section.items[rowIndex]
//            let originIdx = selectedItem.originIdx
//
//            if let _ = selectedItem.waypoint {
//                self.serviceInput.serviceUnits.removeSubrange(originIdx - 1 ... originIdx)
//            } else {
//                self.serviceInput.serviceUnits.remove(at: originIdx)
//            }
//
//            let newSection = sectionFromRawData()
//
//            return .concat([
//                .just(.scrollToFooter(false)),
//                .just(.updateSection(newSection))
//            ])

        case let .deleteBypass(indexPath):
            var serviceUnitModel = self.serviceUnits[indexPath.row]
            serviceUnitModel.bypass = nil
            // 이렇게 하면 self.serviceUnits 의 bypass 가 nil 이 되는지 확인 필요
            
            let item = CreateServiceCellReactor(
                provider: self.provider,
                swsIdx: self.swsIdx,
                serviceUnitModel: serviceUnitModel
            )
            
            return .concat([
                .just(.scrollToFooter(false)),
                .just(.updateSectionItem(indexPath, item))
            ])

        case let .updateServiceUnit(indexPath, serviceUnitModel):
            self.serviceUnits[indexPath.row] = serviceUnitModel
            
            let item = CreateServiceCellReactor(
                provider: self.provider,
                swsIdx: self.swsIdx,
                serviceUnitModel: serviceUnitModel
            )
//            let section = sectionFromRawData()
//            let selectedItem = section.items[rowIndex]
//            let originIdx = selectedItem.originIdx
//            self.serviceInput.serviceUnits[originIdx] = unitInput
//            let newSection = sectionFromRawData()
            return .concat([
                .just(.scrollToFooter(false)),
                .just(.updateSectionItem(indexPath, item))
            ])

//        case let .updateWaypointChange(prevStopIdx, stopIdx):
//            let waypointIdx = self.serviceInput.serviceUnits
//                .firstIndex(where: { $0.isBypass == "true" && $0.stopIdx == prevStopIdx })
//
//            if let waypointIdx = waypointIdx {
//                self.serviceInput.serviceUnits[waypointIdx].stopIdx = stopIdx
//            }
//
//            let newSection = sectionFromRawData()
//            return .concat([
//                .just(.scrollToFooter(false)),
//                .just(.updateSection(newSection))
//            ])
//
//        case let .updateWaypointAdded(cellIdx, stopIdx):
//            let section = sectionFromRawData()
//            let selectedItem = section.items[cellIdx]
//            let originIdx = selectedItem.originIdx
//
//            let waypoint = CreateServiceUnitInput(
//                freights: [],
//                isBypass: "true",
//                isStopFixed: "true",
//                message: nil,
//                recipients: [],
//                stopIdx: stopIdx,
//                stopType: .stopover,
//                targetType: .stop)
//
//            self.serviceInput.serviceUnits.insert(waypoint, at: originIdx)
//            let newSection = sectionFromRawData()
//            return .concat([
//                .just(.scrollToFooter(false)),
//                .just(.updateSection(newSection))
//            ])
        
        case let .moveServiceUnit(sourceIndexPath, destinationIndexPath):
            
            let movedItem = self.serviceUnits.remove(at: sourceIndexPath.row)
            self.serviceUnits.insert(movedItem, at: destinationIndexPath.row)
            
            return .concat([
                .just(.scrollToFooter(false)),
                .just(.moveSectionItem(sourceIndexPath, destinationIndexPath))
            ])

//        case let .moveUnit(sourceIndexPath, destinationIndexPath):
//            var section = sectionFromRawData()
//            let selectedItem = section.items.remove(at: sourceIndexPath.row)
//            section.items.insert(selectedItem, at: destinationIndexPath.row)
//
//            var tempUnits = [CreateServiceUnitInput]()
//
//            for item in section.items {
//                if let waypoint = item.waypoint {
//                    tempUnits.append(waypoint)
//                }
//                tempUnits.append(item.unitInput)
//            }
//
//            self.serviceInput.serviceUnits = tempUnits
//
//            let newSection = sectionFromRawData()
//            return .concat([
//                .just(.scrollToFooter(false)),
//                .just(.updateSection(newSection))
//            ])
        
        

        case let .setRequest(serviceMode):
            
            // 서버 측 모델 형태로 풀기 전, 목적지의 stopType 을 일괄 업데이트합니다.
            let serviceUnits = self.updateStopType(of: self.serviceUnits)
            
            // 서버 측 모델 형태로 풉니다.
            let serviceUnitInputs = self.serviceUnitInputs(from: serviceUnits)
            
            let serviceInput = CreateServiceInput(
                mode: serviceMode,
                serviceUnits: serviceUnitInputs,
                swsIdx: self.swsIdx
            )
            
            Log.info("SERVICE WILL BE REQUESTED: \(serviceInput)")

            return .concat([
                    .just(.updateIsLoading(true)),
                    .just(.updateIsNetworking(true)),

                self.provider.networkManager
                    .perform(CreateServiceMutation(input: serviceInput))
                    .compactMap { $0.createServiceMutation.asService }
                    .map { Mutation.updateServiceIdx($0.serviceIdx) }
                    .catchErrorJustReturn(.updateIsLoading(false))
                    .catchErrorJustReturn(.updateIsNetworking(false)),

                    .just(.updateIsLoading(false)),
                    .just(.updateIsNetworking(false))
            ])
        }
    }
    
    func serviceUnitInputs(from serviceUnitModels: [CreateServiceUnitModel]) -> [CreateServiceUnitInput] {
        var serviceUnitInputs = [CreateServiceUnitInput]()
        
        for model in serviceUnitModels {
            if let input = model.bypass?.info {
                // 여기 input 이 isBypass == true 인지 확인할 것 (경유지 셋팅이 맞는지)
                serviceUnitInputs.append(input)
            }
            let input = model.serviceUnit.info
            serviceUnitInputs.append(input)
        }
        
        return serviceUnitInputs
    }
    
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
            
        case let .updateServiceIdx(serviceIdx):
            state.serviceIdx = serviceIdx

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
            swsIdx: self.swsIdx,
            serviceUnitModel: nil
        )
    }

    func reactorForAddWaypoint() -> AddWaypointViewReactor {
        return AddWaypointViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            section: self.currentState.section)
    }

    func reactorForTargetChanging(rowIndex: Int) -> CSUTargetViewReactor {
        return CSUTargetViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnits[rowIndex]
        )
    }
    
    func reactorForDetail(_ indexPath: IndexPath) -> CSUDetailViewReactor {
        return CSUDetailViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnits[indexPath.row],
            isEditing: true,
            indexOfEditingRow: indexPath.row
        )
    }

    func reactorForWaypoint(index: Int) -> WaypointViewReactor {
//        let section = sectionFromRawData()
//        let selectedItem = section.items[index]
//        let originIdx = selectedItem.originIdx
//        let selectedWaypoint = self.serviceInput.serviceUnits[originIdx - 1]
        
        let selectedWaypoint = self.serviceUnits[index].bypass?.info

        return WaypointViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            waypointInput: selectedWaypoint
        )
    }

    func updateStopType(of serviceUnits: [CreateServiceUnitModel]) -> [CreateServiceUnitModel] {
        var serviceUnits = serviceUnits
        let serviceUnitsCount = serviceUnits.count

        for i in 0 ..< serviceUnitsCount {
            if i == 0 {
                serviceUnits[i].serviceUnit.info.stopType = .startingPoint
            } else if i == serviceUnitsCount - 1 {
                serviceUnits[i].serviceUnit.info.stopType = .destination
            } else {
                serviceUnits[i].serviceUnit.info.stopType = .stopover
            }
        }
        
        return serviceUnits
    }

//    func sectionFromRawData() -> CreateServiceSection {
//        let units = self.serviceInput.serviceUnits
//        var tempWayPoint: CreateServiceUnitInput?
//        var items = [CreateServiceCellReactor]()
//
//        var index = 0
//
//        for unit in units {
//            if unit.isBypass != "true"
//            {
//                // 경유지가 아닌 경우
//                let model = CreateServiceCellReactor(
//                    provider: self.provider,
//                    swsIdx: self.serviceInput.swsIdx,
//                    unitInput: unit,
//                    waypoint: tempWayPoint,
//                    originIdx: index
//                )
//
//                // tempWayPoint nil 처리
//                tempWayPoint = nil
//                items.append(model)
//            }
//            else if unit.isBypass == "true"
//            {
//                tempWayPoint = unit
//            }
//            index += 1
//        }
//
//        return CreateServiceSection(items: items)
//    }

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
