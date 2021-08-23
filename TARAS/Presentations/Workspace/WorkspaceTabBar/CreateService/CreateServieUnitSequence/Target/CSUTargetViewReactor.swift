//
//  CSUTargetViewReactor.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

import Apollo
import ReactorKit

/// CSU 는 Create Service Unit(단위서비스 생성) 의 약자입니다.
class CSUTargetViewReactor: Reactor {
    
    enum Action {
        case setInitialPage
    }
    
    enum Mutation {
        case updateInitialPage(ServiceUnitTargetType?)
    }
    
    struct State {
        /// targetType 의 값에 따라 pageViewController의 초기 설정을 분기합니다.
        /// - 최초 '대상 선택' 인 경우: nil
        /// - 기존 '대상 선택' 에서 '회원 및 그룹'을 선택 (수신자 우선 선택) 한 경우: .recipient
        /// - 기존 '대상 선택' 에서 '정차지'를 선택 (정차지 우선 선택) 한 경우: .stop
        var targetType: ServiceUnitTargetType?
    }
    
    var initialState: State {
        return .init(targetType: nil)
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
        switch action {
        case .setInitialPage:
            // 기존 '단위서비스'를 수정하는 경우라면
            // 해당 '단위서비스'의 targetType 으로 pageViewController의 초기 설정을 진행합니다.
            if let serviceUnitModel = self.serviceUnitModel {
                return .just(.updateInitialPage(serviceUnitModel.serviceUnit.info.targetType))
            }
            
            // 새로운 '단위서비스'를 생성하는 경우라면
            // nil 을 전달하여 pageViewController의 초기 설정을 진행합니다.
            return .just(.updateInitialPage(nil))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateInitialPage(targetType):
            state.targetType = targetType
        }
        return state
    }
    
    func reactorForTargetMemeber() -> TargetMemberViewReactor {
        return TargetMemberViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel
        )
    }
    
    func reactorForTargetStop() -> TargetStopViewReactor {
        return TargetStopViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: self.serviceUnitModel
        )
    }
    
    func reactorForFreight(
        _ serviceUnitModel: CreateServiceUnitModel
    ) -> CSUFreightsViewReactor? {
        return CSUFreightsViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: serviceUnitModel,
            freightType: .load
        )
    }

    func reactorForRecipients(
        _ serviceUnitModel: CreateServiceUnitModel
    ) -> CSURecipientViewReactor? {
        return CSURecipientViewReactor(
            provider: self.provider,
            swsIdx: self.swsIdx,
            serviceUnitModel: serviceUnitModel
        )
    }
}
