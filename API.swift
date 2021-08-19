// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct CreateUserMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - id
  ///   - password
  ///   - username: Required. 100 characters or fewer. Letters, digits and _ only.
  ///   - displayName: Required. 100 characters or fewer.
  ///   - email
  ///   - phoneNumber: Digits only with county calling code. 30 characters or fewer.
  ///   - clientMutationId
  public init(id: Swift.Optional<Int?> = nil, password: String, username: String, displayName: String, email: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil, clientMutationId: Swift.Optional<String?> = nil) {
    graphQLMap = ["id": id, "password": password, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber, "clientMutationId": clientMutationId]
  }

  public var id: Swift.Optional<Int?> {
    get {
      return graphQLMap["id"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
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

  /// Required. 100 characters or fewer. Letters, digits and _ only.
  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  /// Required. 100 characters or fewer.
  public var displayName: String {
    get {
      return graphQLMap["displayName"] as! String
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

  /// Digits only with county calling code. 30 characters or fewer.
  public var phoneNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["phoneNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var clientMutationId: Swift.Optional<String?> {
    get {
      return graphQLMap["clientMutationId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientMutationId")
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
        lastLogin
        dateJoined
        username
        displayName
        email
        phoneNumber
        joinedWorkspaces
        errors {
          __typename
          field
          messages
        }
        clientMutationId
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
      public static let possibleTypes: [String] = ["CreateUserMutationPayload"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(Int.self)),
          GraphQLField("lastLogin", type: .scalar(String.self)),
          GraphQLField("dateJoined", type: .scalar(String.self)),
          GraphQLField("username", type: .scalar(String.self)),
          GraphQLField("displayName", type: .scalar(String.self)),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("phoneNumber", type: .scalar(String.self)),
          GraphQLField("joinedWorkspaces", type: .scalar(String.self)),
          GraphQLField("errors", type: .list(.object(Error.selections))),
          GraphQLField("clientMutationId", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int? = nil, lastLogin: String? = nil, dateJoined: String? = nil, username: String? = nil, displayName: String? = nil, email: String? = nil, phoneNumber: String? = nil, joinedWorkspaces: String? = nil, errors: [Error?]? = nil, clientMutationId: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "CreateUserMutationPayload", "id": id, "lastLogin": lastLogin, "dateJoined": dateJoined, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber, "joinedWorkspaces": joinedWorkspaces, "errors": errors.flatMap { (value: [Error?]) -> [ResultMap?] in value.map { (value: Error?) -> ResultMap? in value.flatMap { (value: Error) -> ResultMap in value.resultMap } } }, "clientMutationId": clientMutationId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: Int? {
        get {
          return resultMap["id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var lastLogin: String? {
        get {
          return resultMap["lastLogin"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastLogin")
        }
      }

      public var dateJoined: String? {
        get {
          return resultMap["dateJoined"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dateJoined")
        }
      }

      /// Required. 100 characters or fewer. Letters, digits and _ only.
      public var username: String? {
        get {
          return resultMap["username"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "username")
        }
      }

      /// Required. 100 characters or fewer.
      public var displayName: String? {
        get {
          return resultMap["displayName"] as? String
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

      public var joinedWorkspaces: String? {
        get {
          return resultMap["joinedWorkspaces"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "joinedWorkspaces")
        }
      }

      /// May contain more than one error for same field.
      public var errors: [Error?]? {
        get {
          return (resultMap["errors"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Error?] in value.map { (value: ResultMap?) -> Error? in value.flatMap { (value: ResultMap) -> Error in Error(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Error?]) -> [ResultMap?] in value.map { (value: Error?) -> ResultMap? in value.flatMap { (value: Error) -> ResultMap in value.resultMap } } }, forKey: "errors")
        }
      }

      public var clientMutationId: String? {
        get {
          return resultMap["clientMutationId"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "clientMutationId")
        }
      }

      public struct Error: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ErrorType"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("field", type: .nonNull(.scalar(String.self))),
            GraphQLField("messages", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(field: String, messages: [String]) {
          self.init(unsafeResultMap: ["__typename": "ErrorType", "field": field, "messages": messages])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var field: String {
          get {
            return resultMap["field"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "field")
          }
        }

        public var messages: [String] {
          get {
            return resultMap["messages"]! as! [String]
          }
          set {
            resultMap.updateValue(newValue, forKey: "messages")
          }
        }
      }
    }
  }
}

public struct StationFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment stationFragment on StationNode {
      __typename
      id
      name
    }
    """

  public static let possibleTypes: [String] = ["StationNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String) {
    self.init(unsafeResultMap: ["__typename": "StationNode", "id": id, "name": name])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The ID of the object.
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
}

public struct StationGroupFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment stationGroupFragment on StationGroupNode {
      __typename
      id
      name
      stations(
        offset: $stationsOffset
        before: $stationsBefore
        after: $stationsAfter
        first: $stationsFirst
        last: $stationsLast
        id: $stationsId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...stationFragment
          }
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["StationGroupNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("stations", arguments: ["offset": GraphQLVariable("stationsOffset"), "before": GraphQLVariable("stationsBefore"), "after": GraphQLVariable("stationsAfter"), "first": GraphQLVariable("stationsFirst"), "last": GraphQLVariable("stationsLast"), "id": GraphQLVariable("stationsId")], type: .object(Station.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, stations: Station? = nil) {
    self.init(unsafeResultMap: ["__typename": "StationGroupNode", "id": id, "name": name, "stations": stations.flatMap { (value: Station) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The ID of the object.
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

  public var stations: Station? {
    get {
      return (resultMap["stations"] as? ResultMap).flatMap { Station(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "stations")
    }
  }

  public struct Station: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["StationNodeConnection"]

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
      self.init(unsafeResultMap: ["__typename": "StationNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
      public static let possibleTypes: [String] = ["StationNodeEdge"]

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
        self.init(unsafeResultMap: ["__typename": "StationNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
        public static let possibleTypes: [String] = ["StationNode"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(StationFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String) {
          self.init(unsafeResultMap: ["__typename": "StationNode", "id": id, "name": name])
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

          public var stationFragment: StationFragment {
            get {
              return StationFragment(unsafeResultMap: resultMap)
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

public struct UserFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment userFragment on UserNode {
      __typename
      id
      username
      displayName
      email
      phoneNumber
      joinedWorkspaces(
        offset: $joinedWorkspacesOffset
        before: $joinedWorkspacesBefore
        after: $joinedWorkspacesAfter
        first: $joinedWorkspacesFirst
        last: $joinedWorkspacesLast
        id: $joinedWorkspacesId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...workspaceForUserFragment
          }
        }
      }
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
      GraphQLField("joinedWorkspaces", arguments: ["offset": GraphQLVariable("joinedWorkspacesOffset"), "before": GraphQLVariable("joinedWorkspacesBefore"), "after": GraphQLVariable("joinedWorkspacesAfter"), "first": GraphQLVariable("joinedWorkspacesFirst"), "last": GraphQLVariable("joinedWorkspacesLast"), "id": GraphQLVariable("joinedWorkspacesId")], type: .object(JoinedWorkspace.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, username: String, displayName: String, email: String? = nil, phoneNumber: String? = nil, joinedWorkspaces: JoinedWorkspace? = nil) {
    self.init(unsafeResultMap: ["__typename": "UserNode", "id": id, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber, "joinedWorkspaces": joinedWorkspaces.flatMap { (value: JoinedWorkspace) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The ID of the object.
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
            GraphQLFragmentSpread(WorkspaceForUserFragment.self),
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

          public var workspaceForUserFragment: WorkspaceForUserFragment {
            get {
              return WorkspaceForUserFragment(unsafeResultMap: resultMap)
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

public struct UserForWorkspaceFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment userForWorkspaceFragment on UserNode {
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

  /// The ID of the object.
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
    fragment workspaceFragment on WorkspaceNode {
      __typename
      id
      name
      isActive
      code
      isAllowedToSearch
      isRequiredToAcceptToJoin
      isRequiredUserEmailToJoin
      isRequiredUserPhoneNumberToJoin
      members(
        offset: $memberListOffset
        before: $memberListBefore
        after: $memberListAfter
        first: $memberListFirst
        last: $memberListLast
        id: $memberListId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...userForWorkspaceFragment
          }
        }
      }
      userSet(
        offset: $userSetOffset
        before: $userSetBefore
        after: $userSetAfter
        first: $userSetFirst
        last: $userSetLast
        id: $userSetId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...userForWorkspaceFragment
          }
        }
      }
      stationGroups(
        offset: $stationGroupsOffset
        before: $stationGroupsBefore
        after: $stationGroupsAfter
        first: $stationGroupsFirst
        last: $stationGroupsLast
        id: $stationGroupsId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...stationGroupFragment
          }
        }
      }
      stations(
        offset: $stationsOffset
        before: $stationsBefore
        after: $stationsAfter
        first: $stationsFirst
        last: $stationsLast
        id: $stationsId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...stationFragment
          }
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["WorkspaceNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("isActive", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("code", type: .scalar(String.self)),
      GraphQLField("isAllowedToSearch", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredToAcceptToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserEmailToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserPhoneNumberToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("members", arguments: ["offset": GraphQLVariable("memberListOffset"), "before": GraphQLVariable("memberListBefore"), "after": GraphQLVariable("memberListAfter"), "first": GraphQLVariable("memberListFirst"), "last": GraphQLVariable("memberListLast"), "id": GraphQLVariable("memberListId")], type: .nonNull(.object(Member.selections))),
      GraphQLField("userSet", arguments: ["offset": GraphQLVariable("userSetOffset"), "before": GraphQLVariable("userSetBefore"), "after": GraphQLVariable("userSetAfter"), "first": GraphQLVariable("userSetFirst"), "last": GraphQLVariable("userSetLast"), "id": GraphQLVariable("userSetId")], type: .nonNull(.object(UserSet.selections))),
      GraphQLField("stationGroups", arguments: ["offset": GraphQLVariable("stationGroupsOffset"), "before": GraphQLVariable("stationGroupsBefore"), "after": GraphQLVariable("stationGroupsAfter"), "first": GraphQLVariable("stationGroupsFirst"), "last": GraphQLVariable("stationGroupsLast"), "id": GraphQLVariable("stationGroupsId")], type: .object(StationGroup.selections)),
      GraphQLField("stations", arguments: ["offset": GraphQLVariable("stationsOffset"), "before": GraphQLVariable("stationsBefore"), "after": GraphQLVariable("stationsAfter"), "first": GraphQLVariable("stationsFirst"), "last": GraphQLVariable("stationsLast"), "id": GraphQLVariable("stationsId")], type: .object(Station.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, isActive: Bool, code: String? = nil, isAllowedToSearch: Bool, isRequiredToAcceptToJoin: Bool, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, members: Member, userSet: UserSet, stationGroups: StationGroup? = nil, stations: Station? = nil) {
    self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "id": id, "name": name, "isActive": isActive, "code": code, "isAllowedToSearch": isAllowedToSearch, "isRequiredToAcceptToJoin": isRequiredToAcceptToJoin, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "members": members.resultMap, "userSet": userSet.resultMap, "stationGroups": stationGroups.flatMap { (value: StationGroup) -> ResultMap in value.resultMap }, "stations": stations.flatMap { (value: Station) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The ID of the object.
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

  public var isActive: Bool {
    get {
      return resultMap["isActive"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isActive")
    }
  }

  public var code: String? {
    get {
      return resultMap["code"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "code")
    }
  }

  public var isAllowedToSearch: Bool {
    get {
      return resultMap["isAllowedToSearch"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isAllowedToSearch")
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

  public var members: Member {
    get {
      return Member(unsafeResultMap: resultMap["members"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "members")
    }
  }

  public var userSet: UserSet {
    get {
      return UserSet(unsafeResultMap: resultMap["userSet"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "userSet")
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

  public var stations: Station? {
    get {
      return (resultMap["stations"] as? ResultMap).flatMap { Station(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "stations")
    }
  }

  public struct Member: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["UserNodeConnection"]

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
      self.init(unsafeResultMap: ["__typename": "UserNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
      public static let possibleTypes: [String] = ["UserNodeEdge"]

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
        self.init(unsafeResultMap: ["__typename": "UserNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
        public static let possibleTypes: [String] = ["UserNode"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(UserForWorkspaceFragment.self),
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

          public var userForWorkspaceFragment: UserForWorkspaceFragment {
            get {
              return UserForWorkspaceFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public struct UserSet: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["UserNodeConnection"]

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
      self.init(unsafeResultMap: ["__typename": "UserNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
      public static let possibleTypes: [String] = ["UserNodeEdge"]

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
        self.init(unsafeResultMap: ["__typename": "UserNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
        public static let possibleTypes: [String] = ["UserNode"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(UserForWorkspaceFragment.self),
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

          public var userForWorkspaceFragment: UserForWorkspaceFragment {
            get {
              return UserForWorkspaceFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
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
            GraphQLFragmentSpread(StationGroupFragment.self),
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

          public var stationGroupFragment: StationGroupFragment {
            get {
              return StationGroupFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public struct Station: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["StationNodeConnection"]

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
      self.init(unsafeResultMap: ["__typename": "StationNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
      public static let possibleTypes: [String] = ["StationNodeEdge"]

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
        self.init(unsafeResultMap: ["__typename": "StationNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
        public static let possibleTypes: [String] = ["StationNode"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(StationFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String) {
          self.init(unsafeResultMap: ["__typename": "StationNode", "id": id, "name": name])
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

          public var stationFragment: StationFragment {
            get {
              return StationFragment(unsafeResultMap: resultMap)
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

public struct WorkspaceForUserFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment workspaceForUserFragment on WorkspaceNode {
      __typename
      id
      name
      isActive
      code
      isAllowedToSearch
      isRequiredToAcceptToJoin
      isRequiredUserEmailToJoin
      isRequiredUserPhoneNumberToJoin
      stationGroups(
        offset: $stationGroupsOffset
        before: $stationGroupsBefore
        after: $stationGroupsAfter
        first: $stationGroupsFirst
        last: $stationGroupsLast
        id: $stationGroupsId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...stationGroupFragment
          }
        }
      }
      stations(
        offset: $stationsOffset
        before: $stationsBefore
        after: $stationsAfter
        first: $stationsFirst
        last: $stationsLast
        id: $stationsId
      ) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...stationFragment
          }
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["WorkspaceNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("isActive", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("code", type: .scalar(String.self)),
      GraphQLField("isAllowedToSearch", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredToAcceptToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserEmailToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserPhoneNumberToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("stationGroups", arguments: ["offset": GraphQLVariable("stationGroupsOffset"), "before": GraphQLVariable("stationGroupsBefore"), "after": GraphQLVariable("stationGroupsAfter"), "first": GraphQLVariable("stationGroupsFirst"), "last": GraphQLVariable("stationGroupsLast"), "id": GraphQLVariable("stationGroupsId")], type: .object(StationGroup.selections)),
      GraphQLField("stations", arguments: ["offset": GraphQLVariable("stationsOffset"), "before": GraphQLVariable("stationsBefore"), "after": GraphQLVariable("stationsAfter"), "first": GraphQLVariable("stationsFirst"), "last": GraphQLVariable("stationsLast"), "id": GraphQLVariable("stationsId")], type: .object(Station.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, isActive: Bool, code: String? = nil, isAllowedToSearch: Bool, isRequiredToAcceptToJoin: Bool, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, stationGroups: StationGroup? = nil, stations: Station? = nil) {
    self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "id": id, "name": name, "isActive": isActive, "code": code, "isAllowedToSearch": isAllowedToSearch, "isRequiredToAcceptToJoin": isRequiredToAcceptToJoin, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "stationGroups": stationGroups.flatMap { (value: StationGroup) -> ResultMap in value.resultMap }, "stations": stations.flatMap { (value: Station) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The ID of the object.
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

  public var isActive: Bool {
    get {
      return resultMap["isActive"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isActive")
    }
  }

  public var code: String? {
    get {
      return resultMap["code"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "code")
    }
  }

  public var isAllowedToSearch: Bool {
    get {
      return resultMap["isAllowedToSearch"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isAllowedToSearch")
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

  public var stationGroups: StationGroup? {
    get {
      return (resultMap["stationGroups"] as? ResultMap).flatMap { StationGroup(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "stationGroups")
    }
  }

  public var stations: Station? {
    get {
      return (resultMap["stations"] as? ResultMap).flatMap { Station(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "stations")
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
            GraphQLFragmentSpread(StationGroupFragment.self),
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

          public var stationGroupFragment: StationGroupFragment {
            get {
              return StationGroupFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }

  public struct Station: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["StationNodeConnection"]

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
      self.init(unsafeResultMap: ["__typename": "StationNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
      public static let possibleTypes: [String] = ["StationNodeEdge"]

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
        self.init(unsafeResultMap: ["__typename": "StationNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
        public static let possibleTypes: [String] = ["StationNode"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(StationFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String) {
          self.init(unsafeResultMap: ["__typename": "StationNode", "id": id, "name": name])
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

          public var stationFragment: StationFragment {
            get {
              return StationFragment(unsafeResultMap: resultMap)
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
