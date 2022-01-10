//
//  ServiceCreationCellReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import ReactorKit

class ServiceCreationCellReactor: Reactor {
    typealias Mutation = NoMutation
    
    enum Action {
        case remove
    }
    
    private let provider: ManagerProviderType
    let initialState: ServiceUnitCreationModel
    
    init(provider: ManagerProviderType, model: ServiceUnitCreationModel) {
        self.provider = provider
        self.initialState = model
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .remove:
            self.provider.notificationManager
                .post(RemoveServiceUnit(self.initialState))
            return .empty()
        }
    }
}

final class RemoveServiceUnit: Notification<ServiceUnitCreationModel> {}
