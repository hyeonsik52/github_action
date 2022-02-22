//
//  ServiceCreationCellReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import ReactorKit

class ServiceCreationCellReactor: Reactor {
    typealias Mutation = NoMutation
    
    enum DestinationType {
        case startingPoint
        case wayPoint(Int)
        case destination
        
        var description: String {
            switch self {
            case .startingPoint:
                return "출발지"
            case .wayPoint(let ordinal):
                return "경유지 \(ordinal)"
            case .destination:
                return "도착지"
            }
        }
    }
    
    enum Action {
        case remove
    }
    
    private let provider: ManagerProviderType
    let initialState: ServiceUnitCreationModel    
    let destinationType: DestinationType
    
    init(provider: ManagerProviderType, model: ServiceUnitCreationModel, destinationType: DestinationType = .destination) {
        self.provider = provider
        self.initialState = model
        self.destinationType = destinationType
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
