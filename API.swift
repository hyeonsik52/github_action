// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct CreateUserMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - username
  ///   - password
  ///   - displayName
  ///   - email
  ///   - phoneNumber
  ///   - remark
  public init(username: String, password: String, displayName: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil, remark: Swift.Optional<String?> = nil) {
    graphQLMap = ["username": username, "password": password, "displayName": displayName, "email": email, "phoneNumber": phoneNumber, "remark": remark]
  }

  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var displayName: Swift.Optional<String?> {
    get {
      return graphQLMap["displayName"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "displayName")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var phoneNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["phoneNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var remark: Swift.Optional<String?> {
    get {
      return graphQLMap["remark"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "remark")
    }
  }
}

public struct UpdateUserMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - username
  ///   - password
  ///   - displayName
  ///   - email
  ///   - phoneNumber
  public init(username: String, password: Swift.Optional<String?> = nil, displayName: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil) {
    graphQLMap = ["username": username, "password": password, "displayName": displayName, "email": email, "phoneNumber": phoneNumber]
  }

  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var password: Swift.Optional<String?> {
    get {
      return graphQLMap["password"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var displayName: Swift.Optional<String?> {
    get {
      return graphQLMap["displayName"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "displayName")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var phoneNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["phoneNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }
}

public final class ServicesByWorkspaceIdSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription servicesByWorkspaceId($workspaceId: String) {
      subscribeHiGlovisServices(workspaceId: $workspaceId) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...ServiceFragment
          }
        }
      }
    }
    """

  public let operationName: String = "servicesByWorkspaceId"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceFragment.fragmentDefinition)
    document.append("\n" + RobotFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitFragment.fragmentDefinition)
    document.append("\n" + StopFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("subscribeHiGlovisServices", arguments: ["workspaceId": GraphQLVariable("workspaceId")], type: .object(SubscribeHiGlovisService.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(subscribeHiGlovisServices: SubscribeHiGlovisService? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "subscribeHiGlovisServices": subscribeHiGlovisServices.flatMap { (value: SubscribeHiGlovisService) -> ResultMap in value.resultMap }])
    }

    public var subscribeHiGlovisServices: SubscribeHiGlovisService? {
      get {
        return (resultMap["subscribeHiGlovisServices"] as? ResultMap).flatMap { SubscribeHiGlovisService(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "subscribeHiGlovisServices")
      }
    }

    public struct SubscribeHiGlovisService: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["HiGlovisServiceNodeConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge?]) {
        self.init(unsafeResultMap: ["__typename": "HiGlovisServiceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Contains the nodes in this connection.
      public var edges: [Edge?] {
        get {
          return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["HiGlovisServiceNodeEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "HiGlovisServiceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge
        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["HiGlovisServiceNode"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(ServiceFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var serviceFragment: ServiceFragment {
              get {
                return ServiceFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }
}

public final class ServiceByServiceIdSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription serviceByServiceId($serviceId: ID) {
      subscribeHiGlovisServiceByServiceId(serviceId: $serviceId) {
        __typename
        ...ServiceFragment
      }
    }
    """

  public let operationName: String = "serviceByServiceId"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceFragment.fragmentDefinition)
    document.append("\n" + RobotFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitFragment.fragmentDefinition)
    document.append("\n" + StopFragment.fragmentDefinition)
    return document
  }

  public var serviceId: GraphQLID?

  public init(serviceId: GraphQLID? = nil) {
    self.serviceId = serviceId
  }

  public var variables: GraphQLMap? {
    return ["serviceId": serviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("subscribeHiGlovisServiceByServiceId", arguments: ["serviceId": GraphQLVariable("serviceId")], type: .object(SubscribeHiGlovisServiceByServiceId.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(subscribeHiGlovisServiceByServiceId: SubscribeHiGlovisServiceByServiceId? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "subscribeHiGlovisServiceByServiceId": subscribeHiGlovisServiceByServiceId.flatMap { (value: SubscribeHiGlovisServiceByServiceId) -> ResultMap in value.resultMap }])
    }

    public var subscribeHiGlovisServiceByServiceId: SubscribeHiGlovisServiceByServiceId? {
      get {
        return (resultMap["subscribeHiGlovisServiceByServiceId"] as? ResultMap).flatMap { SubscribeHiGlovisServiceByServiceId(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "subscribeHiGlovisServiceByServiceId")
      }
    }

    public struct SubscribeHiGlovisServiceByServiceId: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["HiGlovisServiceNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ServiceFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var serviceFragment: ServiceFragment {
          get {
            return ServiceFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class MyUserInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query myUserInfo {
      signedUser {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "myUserInfo"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("signedUser", type: .object(SignedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signedUser: SignedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    public var signedUser: SignedUser? {
      get {
        return (resultMap["signedUser"] as? ResultMap).flatMap { SignedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "signedUser")
      }
    }

    public struct SignedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, username: String, displayName: String, email: String? = nil, phoneNumber: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "id": id, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class SignUpMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation signUp($input: CreateUserMutationInput!) {
      createUser(input: $input) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "signUp"

  public var input: CreateUserMutationInput

  public init(input: CreateUserMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createUser", arguments: ["input": GraphQLVariable("input")], type: .object(CreateUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createUser: CreateUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createUser": createUser.flatMap { (value: CreateUser) -> ResultMap in value.resultMap }])
    }

    public var createUser: CreateUser? {
      get {
        return (resultMap["createUser"] as? ResultMap).flatMap { CreateUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class UpdateUserInfoMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation updateUserInfo($input: UpdateUserMutationInput!) {
      updateUser(input: $input) {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "updateUserInfo"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var input: UpdateUserMutationInput

  public init(input: UpdateUserMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateUser", arguments: ["input": GraphQLVariable("input")], type: .object(UpdateUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateUser: UpdateUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateUser": updateUser.flatMap { (value: UpdateUser) -> ResultMap in value.resultMap }])
    }

    public var updateUser: UpdateUser? {
      get {
        return (resultMap["updateUser"] as? ResultMap).flatMap { UpdateUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateUser")
      }
    }

    public struct UpdateUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, username: String, displayName: String, email: String? = nil, phoneNumber: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "id": id, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userFragment: UserFragment {
          get {
            return UserFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class AllMyWorkspacesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query allMyWorkspaces {
      signedUser {
        __typename
        joinedWorkspaces {
          __typename
          edges {
            __typename
            node {
              __typename
              ...WorkspaceFragment
            }
          }
        }
      }
    }
    """

  public let operationName: String = "allMyWorkspaces"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + WorkspaceFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("signedUser", type: .object(SignedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signedUser: SignedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    public var signedUser: SignedUser? {
      get {
        return (resultMap["signedUser"] as? ResultMap).flatMap { SignedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "signedUser")
      }
    }

    public struct SignedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("joinedWorkspaces", type: .object(JoinedWorkspace.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(joinedWorkspaces: JoinedWorkspace? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "joinedWorkspaces": joinedWorkspaces.flatMap { (value: JoinedWorkspace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var joinedWorkspaces: JoinedWorkspace? {
        get {
          return (resultMap["joinedWorkspaces"] as? ResultMap).flatMap { JoinedWorkspace(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "joinedWorkspaces")
        }
      }

      public struct JoinedWorkspace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["WorkspaceNodeConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge?]) {
          self.init(unsafeResultMap: ["__typename": "WorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Contains the nodes in this connection.
        public var edges: [Edge?] {
          get {
            return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["WorkspaceNodeEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "WorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["WorkspaceNode"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(WorkspaceFragment.self),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, name: String, createdAt: String? = nil, isRequiredToAcceptToJoin: Bool, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "id": id, "name": name, "createdAt": createdAt, "isRequiredToAcceptToJoin": isRequiredToAcceptToJoin, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var workspaceFragment: WorkspaceFragment {
                get {
                  return WorkspaceFragment(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class LeaveWorkspaceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation leaveWorkspace($workspaceId: String) {
      leaveWorkspace(workspaceId: $workspaceId)
    }
    """

  public let operationName: String = "leaveWorkspace"

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("leaveWorkspace", arguments: ["workspaceId": GraphQLVariable("workspaceId")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(leaveWorkspace: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "leaveWorkspace": leaveWorkspace])
    }

    public var leaveWorkspace: Bool? {
      get {
        return resultMap["leaveWorkspace"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "leaveWorkspace")
      }
    }
  }
}

public final class SearchWorkspaceByCodeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query searchWorkspaceByCode($code: String) {
      linkedWorkspaces(code: $code) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...WorkspaceFragment
          }
        }
      }
    }
    """

  public let operationName: String = "searchWorkspaceByCode"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + WorkspaceFragment.fragmentDefinition)
    return document
  }

  public var code: String?

  public init(code: String? = nil) {
    self.code = code
  }

  public var variables: GraphQLMap? {
    return ["code": code]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("linkedWorkspaces", arguments: ["code": GraphQLVariable("code")], type: .object(LinkedWorkspace.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(linkedWorkspaces: LinkedWorkspace? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "linkedWorkspaces": linkedWorkspaces.flatMap { (value: LinkedWorkspace) -> ResultMap in value.resultMap }])
    }

    public var linkedWorkspaces: LinkedWorkspace? {
      get {
        return (resultMap["linkedWorkspaces"] as? ResultMap).flatMap { LinkedWorkspace(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "linkedWorkspaces")
      }
    }

    public struct LinkedWorkspace: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["WorkspaceNodeConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge?]) {
        self.init(unsafeResultMap: ["__typename": "WorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Contains the nodes in this connection.
      public var edges: [Edge?] {
        get {
          return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["WorkspaceNodeEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "WorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge
        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["WorkspaceNode"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(WorkspaceFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String, createdAt: String? = nil, isRequiredToAcceptToJoin: Bool, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool) {
            self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "id": id, "name": name, "createdAt": createdAt, "isRequiredToAcceptToJoin": isRequiredToAcceptToJoin, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var workspaceFragment: WorkspaceFragment {
              get {
                return WorkspaceFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }
}

public final class WorkspaceByIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query workspaceById($workspaceId: String) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              ...WorkspaceFragment
            }
          }
        }
      }
    }
    """

  public let operationName: String = "workspaceById"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + WorkspaceFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("signedUser", type: .object(SignedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signedUser: SignedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    public var signedUser: SignedUser? {
      get {
        return (resultMap["signedUser"] as? ResultMap).flatMap { SignedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "signedUser")
      }
    }

    public struct SignedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("joinedWorkspaces", arguments: ["id": GraphQLVariable("workspaceId")], type: .object(JoinedWorkspace.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(joinedWorkspaces: JoinedWorkspace? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "joinedWorkspaces": joinedWorkspaces.flatMap { (value: JoinedWorkspace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var joinedWorkspaces: JoinedWorkspace? {
        get {
          return (resultMap["joinedWorkspaces"] as? ResultMap).flatMap { JoinedWorkspace(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "joinedWorkspaces")
        }
      }

      public struct JoinedWorkspace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["WorkspaceNodeConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge?]) {
          self.init(unsafeResultMap: ["__typename": "WorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Contains the nodes in this connection.
        public var edges: [Edge?] {
          get {
            return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["WorkspaceNodeEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "WorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["WorkspaceNode"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(WorkspaceFragment.self),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, name: String, createdAt: String? = nil, isRequiredToAcceptToJoin: Bool, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "id": id, "name": name, "createdAt": createdAt, "isRequiredToAcceptToJoin": isRequiredToAcceptToJoin, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }

            public struct Fragments {
              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public var workspaceFragment: WorkspaceFragment {
                get {
                  return WorkspaceFragment(unsafeResultMap: resultMap)
                }
                set {
                  resultMap += newValue.resultMap
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class RequestToJoinWorkspaceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation requestToJoinWorkspace($workspaceId: String) {
      requestToJoinWorkspace(workspaceId: $workspaceId)
    }
    """

  public let operationName: String = "requestToJoinWorkspace"

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("requestToJoinWorkspace", arguments: ["workspaceId": GraphQLVariable("workspaceId")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(requestToJoinWorkspace: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "requestToJoinWorkspace": requestToJoinWorkspace])
    }

    public var requestToJoinWorkspace: Bool? {
      get {
        return resultMap["requestToJoinWorkspace"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "requestToJoinWorkspace")
      }
    }
  }
}

public final class CancelToJoinWorkspaceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation cancelToJoinWorkspace($workspaceId: String) {
      cancelToJoinWorkspace(workspaceId: $workspaceId)
    }
    """

  public let operationName: String = "cancelToJoinWorkspace"

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("cancelToJoinWorkspace", arguments: ["workspaceId": GraphQLVariable("workspaceId")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(cancelToJoinWorkspace: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "cancelToJoinWorkspace": cancelToJoinWorkspace])
    }

    public var cancelToJoinWorkspace: Bool? {
      get {
        return resultMap["cancelToJoinWorkspace"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "cancelToJoinWorkspace")
      }
    }
  }
}

public final class UserListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query userList($workspaceId: String) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              members {
                __typename
                edges {
                  __typename
                  node {
                    __typename
                    ...MemberFragment
                  }
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "userList"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MemberFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("signedUser", type: .object(SignedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signedUser: SignedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    public var signedUser: SignedUser? {
      get {
        return (resultMap["signedUser"] as? ResultMap).flatMap { SignedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "signedUser")
      }
    }

    public struct SignedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("joinedWorkspaces", arguments: ["id": GraphQLVariable("workspaceId")], type: .object(JoinedWorkspace.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(joinedWorkspaces: JoinedWorkspace? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "joinedWorkspaces": joinedWorkspaces.flatMap { (value: JoinedWorkspace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var joinedWorkspaces: JoinedWorkspace? {
        get {
          return (resultMap["joinedWorkspaces"] as? ResultMap).flatMap { JoinedWorkspace(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "joinedWorkspaces")
        }
      }

      public struct JoinedWorkspace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["WorkspaceNodeConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge?]) {
          self.init(unsafeResultMap: ["__typename": "WorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Contains the nodes in this connection.
        public var edges: [Edge?] {
          get {
            return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["WorkspaceNodeEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "WorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["WorkspaceNode"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("members", type: .object(Member.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(members: Member? = nil) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "members": members.flatMap { (value: Member) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var members: Member? {
              get {
                return (resultMap["members"] as? ResultMap).flatMap { Member(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "members")
              }
            }

            public struct Member: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["MemberNodeConnection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(edges: [Edge?]) {
                self.init(unsafeResultMap: ["__typename": "MemberNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Contains the nodes in this connection.
              public var edges: [Edge?] {
                get {
                  return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["MemberNodeEdge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("node", type: .object(Node.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(node: Node? = nil) {
                  self.init(unsafeResultMap: ["__typename": "MemberNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The item at the end of the edge
                public var node: Node? {
                  get {
                    return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["MemberNode"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLFragmentSpread(MemberFragment.self),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: GraphQLID, displayName: String) {
                    self.init(unsafeResultMap: ["__typename": "MemberNode", "id": id, "displayName": displayName])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }

                  public struct Fragments {
                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public var memberFragment: MemberFragment {
                      get {
                        return MemberFragment(unsafeResultMap: resultMap)
                      }
                      set {
                        resultMap += newValue.resultMap
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class StopsByWorkspaceIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query stopsByWorkspaceId($workspaceId: String) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              stationGroups {
                __typename
                edges {
                  __typename
                  node {
                    __typename
                    ...StopFragment
                  }
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "stopsByWorkspaceId"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + StopFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("signedUser", type: .object(SignedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signedUser: SignedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    public var signedUser: SignedUser? {
      get {
        return (resultMap["signedUser"] as? ResultMap).flatMap { SignedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "signedUser")
      }
    }

    public struct SignedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("joinedWorkspaces", arguments: ["id": GraphQLVariable("workspaceId")], type: .object(JoinedWorkspace.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(joinedWorkspaces: JoinedWorkspace? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "joinedWorkspaces": joinedWorkspaces.flatMap { (value: JoinedWorkspace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var joinedWorkspaces: JoinedWorkspace? {
        get {
          return (resultMap["joinedWorkspaces"] as? ResultMap).flatMap { JoinedWorkspace(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "joinedWorkspaces")
        }
      }

      public struct JoinedWorkspace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["WorkspaceNodeConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge?]) {
          self.init(unsafeResultMap: ["__typename": "WorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Contains the nodes in this connection.
        public var edges: [Edge?] {
          get {
            return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["WorkspaceNodeEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "WorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["WorkspaceNode"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("stationGroups", type: .object(StationGroup.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(stationGroups: StationGroup? = nil) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "stationGroups": stationGroups.flatMap { (value: StationGroup) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var stationGroups: StationGroup? {
              get {
                return (resultMap["stationGroups"] as? ResultMap).flatMap { StationGroup(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "stationGroups")
              }
            }

            public struct StationGroup: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["StationGroupNodeConnection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(edges: [Edge?]) {
                self.init(unsafeResultMap: ["__typename": "StationGroupNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Contains the nodes in this connection.
              public var edges: [Edge?] {
                get {
                  return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["StationGroupNodeEdge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("node", type: .object(Node.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(node: Node? = nil) {
                  self.init(unsafeResultMap: ["__typename": "StationGroupNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The item at the end of the edge
                public var node: Node? {
                  get {
                    return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["StationGroupNode"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLFragmentSpread(StopFragment.self),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: GraphQLID, name: String, isStop: Bool) {
                    self.init(unsafeResultMap: ["__typename": "StationGroupNode", "id": id, "name": name, "isStop": isStop])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }

                  public struct Fragments {
                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public var stopFragment: StopFragment {
                      get {
                        return StopFragment(unsafeResultMap: resultMap)
                      }
                      set {
                        resultMap += newValue.resultMap
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class ServicesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query services($workspaceId: String, $before: String, $last: Int) {
      hiGlovisServices(workspaceId: $workspaceId, before: $before, last: $last) {
        __typename
        pageInfo {
          __typename
          startCursor
          hasPreviousPage
        }
        edges {
          __typename
          cursor
          node {
            __typename
            ...ServiceFragment
          }
        }
      }
    }
    """

  public let operationName: String = "services"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceFragment.fragmentDefinition)
    document.append("\n" + RobotFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitFragment.fragmentDefinition)
    document.append("\n" + StopFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String?
  public var before: String?
  public var last: Int?

  public init(workspaceId: String? = nil, before: String? = nil, last: Int? = nil) {
    self.workspaceId = workspaceId
    self.before = before
    self.last = last
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId, "before": before, "last": last]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("hiGlovisServices", arguments: ["workspaceId": GraphQLVariable("workspaceId"), "before": GraphQLVariable("before"), "last": GraphQLVariable("last")], type: .object(HiGlovisService.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(hiGlovisServices: HiGlovisService? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "hiGlovisServices": hiGlovisServices.flatMap { (value: HiGlovisService) -> ResultMap in value.resultMap }])
    }

    public var hiGlovisServices: HiGlovisService? {
      get {
        return (resultMap["hiGlovisServices"] as? ResultMap).flatMap { HiGlovisService(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "hiGlovisServices")
      }
    }

    public struct HiGlovisService: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["HiGlovisServiceNodeConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(pageInfo: PageInfo, edges: [Edge?]) {
        self.init(unsafeResultMap: ["__typename": "HiGlovisServiceNodeConnection", "pageInfo": pageInfo.resultMap, "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Pagination data for this connection.
      public var pageInfo: PageInfo {
        get {
          return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
        }
      }

      /// Contains the nodes in this connection.
      public var edges: [Edge?] {
        get {
          return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PageInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("startCursor", type: .scalar(String.self)),
            GraphQLField("hasPreviousPage", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(startCursor: String? = nil, hasPreviousPage: Bool) {
          self.init(unsafeResultMap: ["__typename": "PageInfo", "startCursor": startCursor, "hasPreviousPage": hasPreviousPage])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// When paginating backwards, the cursor to continue.
        public var startCursor: String? {
          get {
            return resultMap["startCursor"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startCursor")
          }
        }

        /// When paginating backwards, are there more items?
        public var hasPreviousPage: Bool {
          get {
            return resultMap["hasPreviousPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasPreviousPage")
          }
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["HiGlovisServiceNodeEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("cursor", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(cursor: String, node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "HiGlovisServiceNodeEdge", "cursor": cursor, "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A cursor for use in pagination
        public var cursor: String {
          get {
            return resultMap["cursor"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cursor")
          }
        }

        /// The item at the end of the edge
        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["HiGlovisServiceNode"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(ServiceFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var serviceFragment: ServiceFragment {
              get {
                return ServiceFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }
}

public final class CompleteServiceUnitMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation completeServiceUnit($serviceId: String, $serviceStep: Int) {
      completeServiceUnit(serviceId: $serviceId, serviceStep: $serviceStep) {
        __typename
        ok
      }
    }
    """

  public let operationName: String = "completeServiceUnit"

  public var serviceId: String?
  public var serviceStep: Int?

  public init(serviceId: String? = nil, serviceStep: Int? = nil) {
    self.serviceId = serviceId
    self.serviceStep = serviceStep
  }

  public var variables: GraphQLMap? {
    return ["serviceId": serviceId, "serviceStep": serviceStep]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("completeServiceUnit", arguments: ["serviceId": GraphQLVariable("serviceId"), "serviceStep": GraphQLVariable("serviceStep")], type: .object(CompleteServiceUnit.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(completeServiceUnit: CompleteServiceUnit? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "completeServiceUnit": completeServiceUnit.flatMap { (value: CompleteServiceUnit) -> ResultMap in value.resultMap }])
    }

    public var completeServiceUnit: CompleteServiceUnit? {
      get {
        return (resultMap["completeServiceUnit"] as? ResultMap).flatMap { CompleteServiceUnit(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "completeServiceUnit")
      }
    }

    public struct CompleteServiceUnit: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CompleteServiceUnit"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("ok", type: .scalar(Bool.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ok: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "CompleteServiceUnit", "ok": ok])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ok: Bool? {
        get {
          return resultMap["ok"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "ok")
        }
      }
    }
  }
}

public final class ServiceQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query service($serviceId: String) {
      hiGlovisServiceByOrderId(orderId: $serviceId) {
        __typename
        ...ServiceFragment
      }
    }
    """

  public let operationName: String = "service"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceFragment.fragmentDefinition)
    document.append("\n" + RobotFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitFragment.fragmentDefinition)
    document.append("\n" + StopFragment.fragmentDefinition)
    return document
  }

  public var serviceId: String?

  public init(serviceId: String? = nil) {
    self.serviceId = serviceId
  }

  public var variables: GraphQLMap? {
    return ["serviceId": serviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("hiGlovisServiceByOrderId", arguments: ["orderId": GraphQLVariable("serviceId")], type: .object(HiGlovisServiceByOrderId.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(hiGlovisServiceByOrderId: HiGlovisServiceByOrderId? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "hiGlovisServiceByOrderId": hiGlovisServiceByOrderId.flatMap { (value: HiGlovisServiceByOrderId) -> ResultMap in value.resultMap }])
    }

    public var hiGlovisServiceByOrderId: HiGlovisServiceByOrderId? {
      get {
        return (resultMap["hiGlovisServiceByOrderId"] as? ResultMap).flatMap { HiGlovisServiceByOrderId(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "hiGlovisServiceByOrderId")
      }
    }

    public struct HiGlovisServiceByOrderId: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["HiGlovisServiceNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ServiceFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var serviceFragment: ServiceFragment {
          get {
            return ServiceFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UserByIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query userById($workspaceId: String) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              members {
                __typename
                edges {
                  __typename
                  node {
                    __typename
                    ...MemberFragment
                  }
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "userById"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MemberFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("signedUser", type: .object(SignedUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(signedUser: SignedUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    public var signedUser: SignedUser? {
      get {
        return (resultMap["signedUser"] as? ResultMap).flatMap { SignedUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "signedUser")
      }
    }

    public struct SignedUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("joinedWorkspaces", arguments: ["id": GraphQLVariable("workspaceId")], type: .object(JoinedWorkspace.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(joinedWorkspaces: JoinedWorkspace? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "joinedWorkspaces": joinedWorkspaces.flatMap { (value: JoinedWorkspace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var joinedWorkspaces: JoinedWorkspace? {
        get {
          return (resultMap["joinedWorkspaces"] as? ResultMap).flatMap { JoinedWorkspace(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "joinedWorkspaces")
        }
      }

      public struct JoinedWorkspace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["WorkspaceNodeConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge?]) {
          self.init(unsafeResultMap: ["__typename": "WorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Contains the nodes in this connection.
        public var edges: [Edge?] {
          get {
            return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["WorkspaceNodeEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "WorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["WorkspaceNode"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("members", type: .object(Member.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(members: Member? = nil) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "members": members.flatMap { (value: Member) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var members: Member? {
              get {
                return (resultMap["members"] as? ResultMap).flatMap { Member(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "members")
              }
            }

            public struct Member: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["MemberNodeConnection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(edges: [Edge?]) {
                self.init(unsafeResultMap: ["__typename": "MemberNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Contains the nodes in this connection.
              public var edges: [Edge?] {
                get {
                  return (resultMap["edges"] as! [ResultMap?]).map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
                }
                set {
                  resultMap.updateValue(newValue.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["MemberNodeEdge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("node", type: .object(Node.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(node: Node? = nil) {
                  self.init(unsafeResultMap: ["__typename": "MemberNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The item at the end of the edge
                public var node: Node? {
                  get {
                    return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["MemberNode"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLFragmentSpread(MemberFragment.self),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(id: GraphQLID, displayName: String) {
                    self.init(unsafeResultMap: ["__typename": "MemberNode", "id": id, "displayName": displayName])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(unsafeResultMap: resultMap)
                    }
                    set {
                      resultMap += newValue.resultMap
                    }
                  }

                  public struct Fragments {
                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public var memberFragment: MemberFragment {
                      get {
                        return MemberFragment(unsafeResultMap: resultMap)
                      }
                      set {
                        resultMap += newValue.resultMap
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public struct UserFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserFragment on UserNode {
      __typename
      id
      username
      displayName
      email
      phoneNumber
    }
    """

  public static let possibleTypes: [String] = ["UserNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("username", type: .nonNull(.scalar(String.self))),
      GraphQLField("displayName", type: .nonNull(.scalar(String.self))),
      GraphQLField("email", type: .scalar(String.self)),
      GraphQLField("phoneNumber", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, username: String, displayName: String, email: String? = nil, phoneNumber: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "UserNode", "id": id, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  /// Required. 100 characters or fewer. Letters, digits and _ only.
  public var username: String {
    get {
      return resultMap["username"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "username")
    }
  }

  /// Required. 100 characters or fewer.
  public var displayName: String {
    get {
      return resultMap["displayName"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "displayName")
    }
  }

  public var email: String? {
    get {
      return resultMap["email"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  /// Digits only with county calling code. 30 characters or fewer.
  public var phoneNumber: String? {
    get {
      return resultMap["phoneNumber"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }
}

public struct WorkspaceFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment WorkspaceFragment on WorkspaceNode {
      __typename
      id
      name
      createdAt
      isRequiredToAcceptToJoin
      isRequiredUserEmailToJoin
      isRequiredUserPhoneNumberToJoin
    }
    """

  public static let possibleTypes: [String] = ["WorkspaceNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("createdAt", type: .scalar(String.self)),
      GraphQLField("isRequiredToAcceptToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserEmailToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserPhoneNumberToJoin", type: .nonNull(.scalar(Bool.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, createdAt: String? = nil, isRequiredToAcceptToJoin: Bool, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool) {
    self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "id": id, "name": name, "createdAt": createdAt, "isRequiredToAcceptToJoin": isRequiredToAcceptToJoin, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var createdAt: String? {
    get {
      return resultMap["createdAt"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var isRequiredToAcceptToJoin: Bool {
    get {
      return resultMap["isRequiredToAcceptToJoin"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isRequiredToAcceptToJoin")
    }
  }

  public var isRequiredUserEmailToJoin: Bool {
    get {
      return resultMap["isRequiredUserEmailToJoin"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isRequiredUserEmailToJoin")
    }
  }

  public var isRequiredUserPhoneNumberToJoin: Bool {
    get {
      return resultMap["isRequiredUserPhoneNumberToJoin"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isRequiredUserPhoneNumberToJoin")
    }
  }
}

public struct MemberFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MemberFragment on MemberNode {
      __typename
      id
      displayName
    }
    """

  public static let possibleTypes: [String] = ["MemberNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("displayName", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, displayName: String) {
    self.init(unsafeResultMap: ["__typename": "MemberNode", "id": id, "displayName": displayName])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  /// Required. 100 characters or fewer.
  public var displayName: String {
    get {
      return resultMap["displayName"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "displayName")
    }
  }
}

public struct ServiceFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ServiceFragment on HiGlovisServiceNode {
      __typename
      id
      phase
      type
      state
      timestamps
      serviceNumber
      createdAt
      creator
      robot {
        __typename
        ...RobotFragment
      }
      currentServiceUnitStep
      currentServiceUnit {
        __typename
        ...ServiceUnitFragment
      }
      serviceUnits {
        __typename
        ...ServiceUnitFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["HiGlovisServiceNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("phase", type: .scalar(String.self)),
      GraphQLField("type", type: .scalar(String.self)),
      GraphQLField("state", type: .nonNull(.scalar(String.self))),
      GraphQLField("timestamps", type: .scalar(String.self)),
      GraphQLField("serviceNumber", type: .nonNull(.scalar(String.self))),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("creator", type: .scalar(String.self)),
      GraphQLField("robot", type: .object(Robot.selections)),
      GraphQLField("currentServiceUnitStep", type: .scalar(Int.self)),
      GraphQLField("currentServiceUnit", type: .object(CurrentServiceUnit.selections)),
      GraphQLField("serviceUnits", type: .list(.object(ServiceUnit.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, phase: String? = nil, type: String? = nil, state: String, timestamps: String? = nil, serviceNumber: String, createdAt: String, creator: String? = nil, robot: Robot? = nil, currentServiceUnitStep: Int? = nil, currentServiceUnit: CurrentServiceUnit? = nil, serviceUnits: [ServiceUnit?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "HiGlovisServiceNode", "id": id, "phase": phase, "type": type, "state": state, "timestamps": timestamps, "serviceNumber": serviceNumber, "createdAt": createdAt, "creator": creator, "robot": robot.flatMap { (value: Robot) -> ResultMap in value.resultMap }, "currentServiceUnitStep": currentServiceUnitStep, "currentServiceUnit": currentServiceUnit.flatMap { (value: CurrentServiceUnit) -> ResultMap in value.resultMap }, "serviceUnits": serviceUnits.flatMap { (value: [ServiceUnit?]) -> [ResultMap?] in value.map { (value: ServiceUnit?) -> ResultMap? in value.flatMap { (value: ServiceUnit) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var phase: String? {
    get {
      return resultMap["phase"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "phase")
    }
  }

  public var type: String? {
    get {
      return resultMap["type"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }

  public var state: String {
    get {
      return resultMap["state"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "state")
    }
  }

  public var timestamps: String? {
    get {
      return resultMap["timestamps"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "timestamps")
    }
  }

  public var serviceNumber: String {
    get {
      return resultMap["serviceNumber"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "serviceNumber")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var creator: String? {
    get {
      return resultMap["creator"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "creator")
    }
  }

  public var robot: Robot? {
    get {
      return (resultMap["robot"] as? ResultMap).flatMap { Robot(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "robot")
    }
  }

  public var currentServiceUnitStep: Int? {
    get {
      return resultMap["currentServiceUnitStep"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "currentServiceUnitStep")
    }
  }

  public var currentServiceUnit: CurrentServiceUnit? {
    get {
      return (resultMap["currentServiceUnit"] as? ResultMap).flatMap { CurrentServiceUnit(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "currentServiceUnit")
    }
  }

  public var serviceUnits: [ServiceUnit?]? {
    get {
      return (resultMap["serviceUnits"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [ServiceUnit?] in value.map { (value: ResultMap?) -> ServiceUnit? in value.flatMap { (value: ResultMap) -> ServiceUnit in ServiceUnit(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [ServiceUnit?]) -> [ResultMap?] in value.map { (value: ServiceUnit?) -> ResultMap? in value.flatMap { (value: ServiceUnit) -> ResultMap in value.resultMap } } }, forKey: "serviceUnits")
    }
  }

  public struct Robot: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["RobotNode"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(RobotFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var robotFragment: RobotFragment {
        get {
          return RobotFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct CurrentServiceUnit: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["ServiceUnitNode"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ServiceUnitFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var serviceUnitFragment: ServiceUnitFragment {
        get {
          return ServiceUnitFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct ServiceUnit: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["ServiceUnitNode"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ServiceUnitFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var serviceUnitFragment: ServiceUnitFragment {
        get {
          return ServiceUnitFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ServiceUnitFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ServiceUnitFragment on ServiceUnitNode {
      __typename
      id
      state
      stop {
        __typename
        ...StopFragment
      }
      data
    }
    """

  public static let possibleTypes: [String] = ["ServiceUnitNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("state", type: .scalar(String.self)),
      GraphQLField("stop", type: .object(Stop.selections)),
      GraphQLField("data", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, state: String? = nil, stop: Stop? = nil, data: String) {
    self.init(unsafeResultMap: ["__typename": "ServiceUnitNode", "id": id, "state": state, "stop": stop.flatMap { (value: Stop) -> ResultMap in value.resultMap }, "data": data])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var state: String? {
    get {
      return resultMap["state"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "state")
    }
  }

  public var stop: Stop? {
    get {
      return (resultMap["stop"] as? ResultMap).flatMap { Stop(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "stop")
    }
  }

  public var data: String {
    get {
      return resultMap["data"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "data")
    }
  }

  public struct Stop: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["StationGroupNode"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(StopFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String, isStop: Bool) {
      self.init(unsafeResultMap: ["__typename": "StationGroupNode", "id": id, "name": name, "isStop": isStop])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var stopFragment: StopFragment {
        get {
          return StopFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct StopFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment StopFragment on StationGroupNode {
      __typename
      id
      name
      isStop
    }
    """

  public static let possibleTypes: [String] = ["StationGroupNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("isStop", type: .nonNull(.scalar(Bool.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, isStop: Bool) {
    self.init(unsafeResultMap: ["__typename": "StationGroupNode", "id": id, "name": name, "isStop": isStop])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var isStop: Bool {
    get {
      return resultMap["isStop"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isStop")
    }
  }
}

public struct RobotFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment RobotFragment on RobotNode {
      __typename
      id
      name
      lockKey
      extensions {
        __typename
        id
      }
    }
    """

  public static let possibleTypes: [String] = ["RobotNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("lockKey", type: .scalar(String.self)),
      GraphQLField("extensions", type: .list(.object(Extension.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil, lockKey: String? = nil, extensions: [Extension?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "RobotNode", "id": id, "name": name, "lockKey": lockKey, "extensions": extensions.flatMap { (value: [Extension?]) -> [ResultMap?] in value.map { (value: Extension?) -> ResultMap? in value.flatMap { (value: Extension) -> ResultMap in value.resultMap } } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var lockKey: String? {
    get {
      return resultMap["lockKey"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "lockKey")
    }
  }

  public var extensions: [Extension?]? {
    get {
      return (resultMap["extensions"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Extension?] in value.map { (value: ResultMap?) -> Extension? in value.flatMap { (value: ResultMap) -> Extension in Extension(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Extension?]) -> [ResultMap?] in value.map { (value: Extension?) -> ResultMap? in value.flatMap { (value: Extension) -> ResultMap in value.resultMap } } }, forKey: "extensions")
    }
  }

  public struct Extension: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["DoorLockExtensionType"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "DoorLockExtensionType", "id": id])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }
  }
}
