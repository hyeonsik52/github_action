//
//  ServiceCreationSelectReceiverViewReactor.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/01.
//

import ReactorKit
import Foundation

class ServiceCreationSelectReceiverViewReactor: Reactor {
    
    typealias ServiceUnit = ServiceUnitCreationModel
    typealias User = ServiceUnitTargetModel
    typealias UserUpdateClosure = ([User]) -> [User]
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action {
        case refresh
        case select(model: User)
    }
    
    enum Mutation {
        case reloadUsers([User])
        case updateLoading(Bool)
        case updateUser(UserUpdateClosure)
    }
    
    struct State {
        var users: [User]
        var isLoading: Bool
    }
    
    var initialState: State = .init(
        users: [],
        isLoading: false
    )
    
    let provider: ManagerProviderType
    private let workspaceId: String
    private var serviceUnit: ServiceUnit
    let mode: ServiceCreationEditMode
    
    let templateProcess: STProcess
    
    private let disposeBag = DisposeBag()
    
    init(
        provider: ManagerProviderType,
        workspaceId: String,
        serviceUnit: ServiceUnit,
        mode: ServiceCreationEditMode,
        process: STProcess
    ) {
        self.provider = provider
        self.workspaceId = workspaceId
        self.serviceUnit = serviceUnit
        self.mode = mode
        self.templateProcess = process
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return .concat([
                .just(.updateLoading(true)),
                self.refresh(),
                .just(.updateLoading(false))
            ])
        case .select(let model):
            return .just(.updateUser({ users in
                var users = users
                if let newSelectIndex = users.firstIndex(where: { $0 == model }) {
                    users[newSelectIndex].isSelected = !users[newSelectIndex].isSelected
                }
                self.serviceUnit.receivers = users.filter(\.isSelected)
                return users
            }))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadUsers(let users):
            state.users = users
        case .updateLoading(let isLoading):
            state.isLoading = isLoading
        case .updateUser(let update):
            state.users = update(state.users)
        }
        return state
    }
}

extension ServiceCreationSelectReceiverViewReactor {
    
    func refresh() -> Observable<Mutation> {
        
        if self.templateProcess.peek(with: "receivers.ID")?.toArgument?.from == .user {
            
            let myUserID = self.provider.userManager.userTB.ID
            
            return self.provider.networkManager.fetch(UserListQuery(workspaceId: self.workspaceId))
                .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node?.members }
                .map { $0.edges.compactMap { $0?.node?.fragments.memberFragment } }
                .map {
                    $0.compactMap { payload -> User? in
                        guard let name = payload.displayName else { return nil }
                        let isMe = (payload.id == myUserID)
                        let displayName = (isMe ? "\(name)(나)": name)
                        var user = User(id: payload.id, name: displayName)
                        user.isSelected = self.serviceUnit.receivers.contains(user)
                        return user
                    }.sorted { lhs, rhs in
                        let islhsMe = (lhs.id == myUserID ? 0: 1)
                        let isrhsMe = (rhs.id == myUserID ? 0: 1)
                        return islhsMe < isrhsMe
                    }
                }.map { .reloadUsers($0) }
        }
        
        return .just(.reloadUsers([]))
    }
}

extension ServiceCreationSelectReceiverViewReactor {
    
    func reactorForDetail(mode: ServiceCreationEditMode) -> ServiceCreationDetailViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
}
