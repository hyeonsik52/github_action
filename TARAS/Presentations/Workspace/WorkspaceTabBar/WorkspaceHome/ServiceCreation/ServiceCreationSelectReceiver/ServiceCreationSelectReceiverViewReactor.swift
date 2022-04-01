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
    typealias UserReactorUpdateClosure = ([UserReactor]) -> [UserReactor]
    typealias UserReactor = ServiceUnitTargetCellReactor
    
    let scheduler: Scheduler = SerialDispatchQueueScheduler(qos: .userInteractive)
    
    enum Action: Equatable {
        case refresh(term: String?)
        case select(model: User)
    }
    
    enum Mutation {
        case reloadUsers([UserReactor])
        case updateLoading(Bool)
        case updateUser(UserReactorUpdateClosure)
        case updatePlaceholderState(PlaceholderStateType?)
    }
    
    struct State {
        var selectedUsers: [User]
        var users: [UserReactor]
        var isLoading: Bool
        var placeholderState: PlaceholderStateType?
    }
    
    var initialState: State = .init(
        selectedUsers: [],
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
        case .refresh(let term):
            return .concat([
                .just(.updateLoading(true)),
                self.refresh(term: term),
                .just(.updateLoading(false))
            ])
        case .select(let model):
            return .just(.updateUser({ reactors in
                var users = reactors.map(\.initialState)
                let newState = !model.isSelected
                if let newSelectIndex = users.firstIndex(where: { $0 == model }) {
                    users[newSelectIndex].isSelected = newState
                }
                self.serviceUnit.receivers.removeAll { $0 == model }
                if newState {
                    self.serviceUnit.receivers.append(model)
                }
                return reactors.enumerated().map { .init(
                    model: users[$0.offset],
                    selectionType: $0.element.selectionType,
                    highlightRanges: $0.element.highlightRanges,
                    isSeparated: $0.element.isSeparated
                ) }
            }))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadUsers(let users):
            state.users = users
            state.selectedUsers = self.serviceUnit.receivers
        case .updateLoading(let isLoading):
            state.isLoading = isLoading
        case .updateUser(let update):
            state.users = update(state.users)
            state.selectedUsers = self.serviceUnit.receivers
        case .updatePlaceholderState(let placeholderState):
            state.placeholderState = placeholderState
        }
        if state.placeholderState != .networkDisconnected {
            state.placeholderState = (state.users.isEmpty ? .resultNotFound: nil)
        }
        return state
    }
}

extension ServiceCreationSelectReceiverViewReactor {
    
    func refresh(term: String?) -> Observable<Mutation> {
        
        if self.templateProcess.peek(with: "receivers.ID")?.asArgument?.from == .user {
            
            let myUserID = self.provider.userManager.userTB.ID
            
            return self.provider.networkManager.fetch(UserListQuery(workspaceId: self.workspaceId, displayName: term))
                .compactMap { $0.signedUser?.joinedWorkspaces?.edges.first??.node?.members }
                .map { $0.edges.compactMap { $0?.node?.fragments.memberFragment } }
                .map {
                    $0.compactMap { payload -> UserReactor? in
                        guard let name = payload.displayName else { return nil }
                        let isMe = (payload.id == myUserID)
                        var user = User(id: payload.id, name: name)
                        user.isSelected = self.serviceUnit.receivers.contains(user)
                        return .init(
                            model: user,
                            selectionType: .check,
                            highlightRanges: (term == nil ? []: name.ranges(of: term!)),
                            isSeparated: isMe
                        )
                    }.sorted { lhs, rhs in
                        let islhsMe = (lhs.initialState.id == myUserID ? 0: 1)
                        let isrhsMe = (rhs.initialState.id == myUserID ? 0: 1)
                        return islhsMe < isrhsMe
                    }
                }.flatMapLatest { users -> Observable<Mutation> in
                    return .concat([
                        .just(.updatePlaceholderState(nil)),
                        .just(.reloadUsers(users))
                    ])
                }.catch { error in
                    guard let multipleError = error as? MultipleError,
                          let _ = multipleError.graphQLErrors
                    else {
                        return .concat([
                            .just(.reloadUsers([])),
                            .just(.updatePlaceholderState(.networkDisconnected))
                        ])
                    }
                    return .empty()
                }
        }
        
        return .just(.reloadUsers([]))
    }
}

extension ServiceCreationSelectReceiverViewReactor {
    
    func reactorForSummary(mode: ServiceCreationEditMode) -> ServiceCreationSummaryViewReactor {
        return .init(
            provider: self.provider,
            workspaceId: self.workspaceId,
            serviceUnit: self.serviceUnit,
            mode: mode,
            process: self.templateProcess
        )
    }
}
