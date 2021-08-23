//
//  CSURecipientViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import Apollo
import ReactorKit

class CSURecipientViewReactor: Reactor {

    enum Action {
        case setInitialPage
    }
    
    enum Mutation {
        case updateInitialPage(ServiceUnitRecipientType?)
    }
    
    struct State {
        /// recipientType 의 값에 따라 pageViewController 초기 설정을 분기합니다.
        /// - 최초 '수신자 선택' 일 때는 nil
        /// - 기존 '수신자 선택' 에서 '회원'을 선택한 경우 .user
        /// - 기존 '수신자 선택' 에서 '그룹'을 선택한 경우 .group
        var recipientType: ServiceUnitRecipientType?
    }
    
    var initialState: State {
        return .init(recipientType: nil)
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
        case .setInitialPage:
            if let recipient = self.serviceUnitModel.serviceUnit.info.recipients.compactMap({ $0 }).first {
                return .just(.updateInitialPage(recipient.targetType))
            }
            return .just(.updateInitialPage(nil))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateInitialPage(recipientType):
            state.recipientType = recipientType
            return state
        }
    }
    
    func reactorForRecipientUsers() -> RecipientUserViewReactor {
        return RecipientUserViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel
        )
    }

    func reactorForRecipientGroup() -> RecipientsGroupViewReactor {
        return RecipientsGroupViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel
        )
    }
    
    func reactorForFreight(_ serviceUnitModel: CreateServiceUnitModel) -> CSUFreightsViewReactor {
        return CSUFreightsViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: serviceUnitModel,
            freightType: .load
        )
    }
}
