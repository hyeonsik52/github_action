//
//  TargetMemberViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import ReactorKit
import Apollo

class TargetMemberViewReactor: Reactor {

    enum Action {
        /// indicator activity 를 사용합니다.
        case loadSections
        
        /// tableView 의 refreshControl 을 사용합니다.
        case refreshSections
    }

    enum Mutation {
        case setLoading(Bool)
        case setSections([TargetMemeberSection])
    }

    struct State {
        var isLoading: Bool
        var sections: [TargetMemeberSection]
    }

    var initialState: State {
        return .init(isLoading: false, sections: [])
    }

    let provider: ManagerProviderType
    
    let swsIdx: Int
    
    var serviceUnitModel: CreateServiceUnitModel?

    init(provider: ManagerProviderType, swsIdx: Int, serviceUnitModel: CreateServiceUnitModel?) {
        self.provider = provider
        self.swsIdx = swsIdx
        self.serviceUnitModel = serviceUnitModel
    }

    func mutate(action: Action) -> Observable<Mutation> {
        
        func loadSection() -> Observable<Mutation> {
            return .zip(
                // 대상 선택 > 회원 및 그룹 > 그룹
                self.provider.networkManager
                    .fetch(GroupListQuery(first: .max32, swsIdx: self.swsIdx))
                    .map { $0.swsGroupsConnection.edges },

                // 대상 선택 > 회원 및 그룹 > 회원
                self.provider.networkManager
                    .fetch(UserListQuery(first: .max32, swsIdx: self.swsIdx))
                    .map { $0.swsUsersConnection.edges }
            ) { groups, users in
                
                // 기존에 선택된 대상이 있다면 해당 셀을 하이라이트 처리합니다.
                let targetInfo = self.serviceUnitModel?.serviceUnit.info.recipients.compactMap { $0 }.first
                let selectedTarget: SelectedTargetMember? = (targetInfo == nil) ? nil : (targetInfo!.targetIdx, targetInfo!.targetType)
                
                // 대상-정차지 선택 후 수신자로 '박수지', '김주원'을 선택한 경우,
                // 대상 수정 시, 대상-회원 및 그룹 화면에서 '박수지' 가 하이라이트 되어보이는 현상을 방지합니다.
                let member = (self.serviceUnitModel?.serviceUnit.info.targetType == .stop) ? nil: selectedTarget
                
                let groupsItems = groups
                    .compactMap { TargetMemberCellModel(group: $0.node, selectedTargetMember: member) }
                    .sorted(by: { $0.name.koreanCompare($1.name) })
                    .map(TargetMemberCellReactor.init)
                let groupsSection = TargetMemeberSection(header: "그룹", items: groupsItems)

                let usersItems = users
                    .compactMap { TargetMemberCellModel(user: $0.node, selectedTargetMember: member) }
                    .sorted(by: { $0.name.koreanCompare($1.name) })
                    .map(TargetMemberCellReactor.init)
                let usersSection = TargetMemeberSection(header: "회원", items: usersItems)

                return Mutation.setSections([groupsSection, usersSection])
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
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state

        case let .setSections(sections):
            state.sections = sections
            return state
        }
    }
    
    func updateCreateServiceUnitModel(
        with reactor: TargetMemberCellReactor
    ) -> CreateServiceUnitModel {
        let target = reactor.currentState

        // 선택된 대상(회원-단수 또는 그룹-단수)의 정보(인덱스와 타입) 입니다.
        let targetInfo = CreateRecipientInput(
            targetIdx: target.idx,
            targetType: target.recipientType
        )

        let serviceUnitInfo = CreateServiceUnitInput(
            freights: [],
            isBypass: "false",
            isStopFixed: "false",
            message: nil,
            recipients: [targetInfo],
            stopIdx: target.stopIdx,
            stopType: .startingPoint,
            targetType: .recipient
        )

        // 최초 '대상 선택' 인 경우, 새 unitInput 을 반환합니다.
        guard var serviceUnitModel = self.serviceUnitModel else {
            return CreateServiceUnitModel(
                serviceUnitTargetName: target.name,
                serviceUnitTargetGroupName: target.groupName,
                serviceUnitInfo: serviceUnitInfo
            )
        }
        
        serviceUnitModel.serviceUnit.targetName = target.name
        serviceUnitModel.serviceUnit.targetGroupName = target.groupName
        serviceUnitModel.serviceUnit.info.isBypass = "false"
        serviceUnitModel.serviceUnit.info.isStopFixed = "false"
        serviceUnitModel.serviceUnit.info.recipients = [targetInfo]
        serviceUnitModel.serviceUnit.info.stopIdx = target.stopIdx
        serviceUnitModel.serviceUnit.info.stopType = .startingPoint
        serviceUnitModel.serviceUnit.info.targetType = .recipient

//        // 기존 serviceUnitModel이 있는 경우
//        // 변경된 정보를 반영합니다.
//        serviceUnitModel.updateServiceUnit(
//            // 선택된 대상의 이름 반영
//            targetName: target.name,
//            // 선택된 대상이 속한 그룹의 이름 반영
//            targetGroupName: target.groupName,
//            // isBypass 디폴트 값으로 초기화
//            isBypass: "false",
//            // isStopFixed 디폴트 값으로 초기화 (대상-회원을 선택한 경우 => false)
//            isStopFixed: "false",
//            // 선택된 recipient 반영
//            recipients: [targetInfo],
//            // 선택된 recipient 의 기본 위치 반영
//            stopIdx: target.stopIdx,
//            // stopType 디폴트 값으로 초기화
//            stopType: .startingPoint,
//            // targetType 디폴트 값으로 초기화 (대상-회원을 선택한 경우 => recipient)
//            targetType: .recipient
//        )

//        // > 선택된 대상의 이름 반영
//        serviceUnit.targetName = target.name
//        // > 선택된 대상이 속한 그룹의 이름 반영
//        serviceUnit.targetGroupName = target.groupName
//        // > 선택된 recipient 반영
//        serviceUnit.info.recipients = [targetInfo]
//        // > 선택된 recipient 의 기본 위치 반영
//        serviceUnit.info.stopIdx = target.stopIdx

//        // 그 외 정보 초기화
//        // > isBypass 디폴트 값으로 초기화
//        serviceUnit.info.isBypass = "false"
//        // > isStopFixed 디폴트 값으로 초기화 (대상-회원을 선택한 경우 => false)
//        serviceUnit.info.isStopFixed = "false"
//        // > stopType 디폴트 값으로 초기화
//        serviceUnit.info.stopType = .startingPoint
//        // > targetType 디폴트 값으로 초기화 (대상-회원을 선택한 경우 => recipient)
//        serviceUnit.info.targetType = .recipient
        
        return serviceUnitModel
    }
}
