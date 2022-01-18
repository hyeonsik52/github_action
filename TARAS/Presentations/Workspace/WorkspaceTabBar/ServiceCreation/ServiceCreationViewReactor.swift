//
//  ServiceCreationViewReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import ReactorKit
import Foundation

class ServiceCreationViewReactor: Reactor {
    
    enum Text {
        static let errorNetworkConnection = "서버와의 통신이 원활하지 않습니다."
        static let errorRequestFailed = "서비스 생성에 실패했습니다."
    }
    
    typealias ServiceUnit = ServiceUnitCreationModel
    typealias ServiceUnitUpdateClosure = ([ServiceUnit]) -> [ServiceUnit]
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action {
        case addOrUpdate(ServiceUnit)
        case move(Int, Int)
        case remove(ServiceUnit)
        case request(repeat: Int?)
    }
    
    enum Mutation {
        case updateServiceUnits(ServiceUnitUpdateClosure)
        case updateProcessing(Bool)
        case updateRequestSuccess(Bool?)
        case updateErrorMessage(String?)
    }
    
    struct State {
        var serviceUnits: [ServiceUnit]
        var isProcessing: Bool
        var isRequestSuccess: Bool?
        var errorMessage: String?
    }
    
    var initialState: State = .init(
        serviceUnits: [],
        isProcessing: false,
        isRequestSuccess: nil,
        errorMessage: nil
    )
    
    private let provider: ManagerProviderType
    private let workspaceId: String
    
    let templateProcess: STProcess
    
    private let disposeBag = DisposeBag()
    
    init(provider: ManagerProviderType, workspaceId: String, process: STProcess) {
        
        self.provider = provider
        self.workspaceId = workspaceId
        self.templateProcess = process
        
        self.observe()
    }
    
    private func observe() {
        
        self.provider.notificationManager
            .observe(to: AddOrUpdateServiceUnit.self)
            .map(Action.addOrUpdate)
            .bind(to: self.action)
            .disposed(by: self.disposeBag)

        self.provider.notificationManager
            .observe(to: RemoveServiceUnit.self)
            .map(Action.remove)
            .bind(to: self.action)
            .disposed(by: self.disposeBag)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addOrUpdate(let serviceUnit):
            return .just(.updateServiceUnits({ serviceUnits in
                var serviceUnits = serviceUnits
                if let index = serviceUnits.firstIndex(of: serviceUnit) {
                    serviceUnits[index] = serviceUnit
                } else {
                    serviceUnits.append(serviceUnit)
                }
                return serviceUnits
            }))
        case let .move(from, to):
            return .just(.updateServiceUnits({ serviceUnits in
                var serviceUnits = serviceUnits
                let serviceUnit = serviceUnits.remove(at: from)
                serviceUnits.insert(serviceUnit, at: to)
                return serviceUnits
            }))
        case .remove(let serviceUnit):
            return .just(.updateServiceUnits({ serviceUnits in
                var serviceUnits = serviceUnits
                serviceUnits.removeAll { $0 == serviceUnit }
                return serviceUnits
            }))
        case .request(let repeatCount):
            let builder = self.templateProcess.serviceBuilder
            
            let jsonValue = builder.generateServiceTemplateInputJsonValue(
                with: self.currentState.serviceUnits,
                repeatCount: repeatCount
            )
            let json = try! GenericScalar(jsonValue: jsonValue)
            
            let input = CreateServiceWithServiceTemplateInput(
                serviceTemplateId: self.templateProcess.templateId,
                input: json
            )
            
            return .concat([
                .just(.updateErrorMessage(nil)),
                .just(.updateRequestSuccess(nil)),
                .just(.updateProcessing(true)),
                
                self.provider.networkManager.perform(CreateServiceMutation(input: input))
                    .map { $0.createServiceWithServiceTemplate?.fragments.serviceFragment }
                    .map {
                        if let _ = $0 {
                            return .updateRequestSuccess(true)
                        } else {
                            return .updateErrorMessage(Text.errorRequestFailed)
                        }
                    }.catch { error in
                        guard let multipleError = error as? MultipleError,
                              let errors = multipleError.graphQLErrors else {
                            return .just(.updateErrorMessage(Text.errorNetworkConnection))
                        }
                        for error in errors {
                            guard let message = error.message, !message.isEmpty else { continue }
                            return .just(.updateErrorMessage(message))
                        }
                        return .just(.updateErrorMessage(Text.errorRequestFailed))
                    },
                
                .just(.updateProcessing(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateServiceUnits(let update):
            state.serviceUnits = update(state.serviceUnits)
        case .updateProcessing(let status):
            state.isProcessing = status
        case .updateRequestSuccess(let success):
            state.isRequestSuccess = success
        case .updateErrorMessage(let message):
            state.errorMessage = message
        }
        return state
    }
}

extension ServiceCreationViewReactor {
    
    func reactorForCell(_ serviceUnit: ServiceUnitCreationModel, destinationType: ServiceCreationCellReactor.DestinationType) -> ServiceCreationCellReactor {
        return .init(provider: self.provider, model: serviceUnit, destinationType: destinationType)
    }
    
    func reactorForSelectStop(
        _ serviceUnit: ServiceUnitCreationModel = .init(),
        mode: ServiceCreationEditMode
    ) -> ServiceCreationSelectStopViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            mode: mode,
            entry: .general(serviceUnit),
            process: self.templateProcess
        )
    }
    
    func reactorForSummary(
        _ serviceUnit: ServiceUnitCreationModel,
        mode: ServiceCreationEditMode
    ) -> ServiceCreationSummaryViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
}
