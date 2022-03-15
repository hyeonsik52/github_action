// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct RegisterFcmMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - clientType
  ///   - deviceUniqueKey
  ///   - fcmToken
  public init(clientType: String, deviceUniqueKey: String, fcmToken: String) {
    graphQLMap = ["clientType": clientType, "deviceUniqueKey": deviceUniqueKey, "fcmToken": fcmToken]
  }

  public var clientType: String {
    get {
      return graphQLMap["clientType"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientType")
    }
  }

  public var deviceUniqueKey: String {
    get {
      return graphQLMap["deviceUniqueKey"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "deviceUniqueKey")
    }
  }

  public var fcmToken: String {
    get {
      return graphQLMap["fcmToken"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fcmToken")
    }
  }
}

public struct UnregisterFcmMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - clientType
  ///   - deviceUniqueKey
  ///   - fcmToken
  public init(clientType: String, deviceUniqueKey: String, fcmToken: String) {
    graphQLMap = ["clientType": clientType, "deviceUniqueKey": deviceUniqueKey, "fcmToken": fcmToken]
  }

  public var clientType: String {
    get {
      return graphQLMap["clientType"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientType")
    }
  }

  public var deviceUniqueKey: String {
    get {
      return graphQLMap["deviceUniqueKey"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "deviceUniqueKey")
    }
  }

  public var fcmToken: String {
    get {
      return graphQLMap["fcmToken"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fcmToken")
    }
  }
}

public struct RequestVerificationNumberMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - data
  ///   - methodType
  ///   - purpose
  public init(data: Swift.Optional<String?> = nil, methodType: Swift.Optional<VerificationMethod?> = nil, purpose: Swift.Optional<VerificationPurpose?> = nil) {
    graphQLMap = ["data": data, "methodType": methodType, "purpose": purpose]
  }

  public var data: Swift.Optional<String?> {
    get {
      return graphQLMap["data"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "data")
    }
  }

  public var methodType: Swift.Optional<VerificationMethod?> {
    get {
      return graphQLMap["methodType"] as? Swift.Optional<VerificationMethod?> ?? Swift.Optional<VerificationMethod?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "methodType")
    }
  }

  public var purpose: Swift.Optional<VerificationPurpose?> {
    get {
      return graphQLMap["purpose"] as? Swift.Optional<VerificationPurpose?> ?? Swift.Optional<VerificationPurpose?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "purpose")
    }
  }
}

public enum VerificationMethod: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case direct
  case email
  case sms
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "DIRECT": self = .direct
      case "EMAIL": self = .email
      case "SMS": self = .sms
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .direct: return "DIRECT"
      case .email: return "EMAIL"
      case .sms: return "SMS"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: VerificationMethod, rhs: VerificationMethod) -> Bool {
    switch (lhs, rhs) {
      case (.direct, .direct): return true
      case (.email, .email): return true
      case (.sms, .sms): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [VerificationMethod] {
    return [
      .direct,
      .email,
      .sms,
    ]
  }
}

public enum VerificationPurpose: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case createUser
  case findUser
  case releaseAccount
  case resetPassword
  case updateEmailAddress
  case updatePhoneNumber
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATE_USER": self = .createUser
      case "FIND_USER": self = .findUser
      case "RELEASE_ACCOUNT": self = .releaseAccount
      case "RESET_PASSWORD": self = .resetPassword
      case "UPDATE_EMAIL_ADDRESS": self = .updateEmailAddress
      case "UPDATE_PHONE_NUMBER": self = .updatePhoneNumber
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .createUser: return "CREATE_USER"
      case .findUser: return "FIND_USER"
      case .releaseAccount: return "RELEASE_ACCOUNT"
      case .resetPassword: return "RESET_PASSWORD"
      case .updateEmailAddress: return "UPDATE_EMAIL_ADDRESS"
      case .updatePhoneNumber: return "UPDATE_PHONE_NUMBER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: VerificationPurpose, rhs: VerificationPurpose) -> Bool {
    switch (lhs, rhs) {
      case (.createUser, .createUser): return true
      case (.findUser, .findUser): return true
      case (.releaseAccount, .releaseAccount): return true
      case (.resetPassword, .resetPassword): return true
      case (.updateEmailAddress, .updateEmailAddress): return true
      case (.updatePhoneNumber, .updatePhoneNumber): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [VerificationPurpose] {
    return [
      .createUser,
      .findUser,
      .releaseAccount,
      .resetPassword,
      .updateEmailAddress,
      .updatePhoneNumber,
    ]
  }
}

public struct CheckVerificationNumberMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - requestId
  ///   - verificationNumber
  public init(requestId: Swift.Optional<String?> = nil, verificationNumber: Swift.Optional<String?> = nil) {
    graphQLMap = ["requestId": requestId, "verificationNumber": verificationNumber]
  }

  public var requestId: Swift.Optional<String?> {
    get {
      return graphQLMap["requestId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "requestId")
    }
  }

  public var verificationNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["verificationNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "verificationNumber")
    }
  }
}

/// An enumeration.
public enum AuthenticationTokenScope: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Create user
  case createUser
  /// Find user
  case findUser
  /// Release account
  case releaseAccount
  /// Reset password
  case resetPassword
  /// Update email address
  case updateEmailAddress
  /// Update phone number
  case updatePhoneNumber
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATE_USER": self = .createUser
      case "FIND_USER": self = .findUser
      case "RELEASE_ACCOUNT": self = .releaseAccount
      case "RESET_PASSWORD": self = .resetPassword
      case "UPDATE_EMAIL_ADDRESS": self = .updateEmailAddress
      case "UPDATE_PHONE_NUMBER": self = .updatePhoneNumber
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .createUser: return "CREATE_USER"
      case .findUser: return "FIND_USER"
      case .releaseAccount: return "RELEASE_ACCOUNT"
      case .resetPassword: return "RESET_PASSWORD"
      case .updateEmailAddress: return "UPDATE_EMAIL_ADDRESS"
      case .updatePhoneNumber: return "UPDATE_PHONE_NUMBER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: AuthenticationTokenScope, rhs: AuthenticationTokenScope) -> Bool {
    switch (lhs, rhs) {
      case (.createUser, .createUser): return true
      case (.findUser, .findUser): return true
      case (.releaseAccount, .releaseAccount): return true
      case (.resetPassword, .resetPassword): return true
      case (.updateEmailAddress, .updateEmailAddress): return true
      case (.updatePhoneNumber, .updatePhoneNumber): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [AuthenticationTokenScope] {
    return [
      .createUser,
      .findUser,
      .releaseAccount,
      .resetPassword,
      .updateEmailAddress,
      .updatePhoneNumber,
    ]
  }
}

public struct ResetPasswordMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - password
  ///   - token
  ///   - username
  public init(password: String, token: String, username: String) {
    graphQLMap = ["password": password, "token": token, "username": username]
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }

  public var token: String {
    get {
      return graphQLMap["token"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "token")
    }
  }

  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }
}

public struct CreateUserMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - displayName
  ///   - email
  ///   - password
  ///   - phoneNumber
  ///   - remark
  ///   - username
  public init(displayName: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, password: String, phoneNumber: Swift.Optional<String?> = nil, remark: Swift.Optional<JSONString?> = nil, username: String) {
    graphQLMap = ["displayName": displayName, "email": email, "password": password, "phoneNumber": phoneNumber, "remark": remark, "username": username]
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

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
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

  public var remark: Swift.Optional<JSONString?> {
    get {
      return graphQLMap["remark"] as? Swift.Optional<JSONString?> ?? Swift.Optional<JSONString?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "remark")
    }
  }

  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }
}

public struct UpdateUserMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - displayName
  ///   - email
  ///   - password
  ///   - phoneNumber
  ///   - username
  public init(displayName: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, password: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil, username: String) {
    graphQLMap = ["displayName": displayName, "email": email, "password": password, "phoneNumber": phoneNumber, "username": username]
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

  public var password: Swift.Optional<String?> {
    get {
      return graphQLMap["password"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
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

  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }
}

public struct CreateServiceWithServiceTemplateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - input
  ///   - serviceTemplateId
  public init(input: Swift.Optional<GenericScalar?> = nil, serviceTemplateId: GraphQLID) {
    graphQLMap = ["input": input, "serviceTemplateId": serviceTemplateId]
  }

  public var input: Swift.Optional<GenericScalar?> {
    get {
      return graphQLMap["input"] as? Swift.Optional<GenericScalar?> ?? Swift.Optional<GenericScalar?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "input")
    }
  }

  public var serviceTemplateId: GraphQLID {
    get {
      return graphQLMap["serviceTemplateId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "serviceTemplateId")
    }
  }
}

public struct CreateServiceTemplateFromServiceInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - description
  ///   - name
  ///   - serviceId
  ///   - userId
  ///   - workspaceId
  public init(description: Swift.Optional<String?> = nil, name: String, serviceId: GraphQLID, userId: Swift.Optional<GraphQLID?> = nil, workspaceId: Swift.Optional<GraphQLID?> = nil) {
    graphQLMap = ["description": description, "name": name, "serviceId": serviceId, "userId": userId, "workspaceId": workspaceId]
  }

  public var description: Swift.Optional<String?> {
    get {
      return graphQLMap["description"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var serviceId: GraphQLID {
    get {
      return graphQLMap["serviceId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "serviceId")
    }
  }

  public var userId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["userId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userId")
    }
  }

  public var workspaceId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["workspaceId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workspaceId")
    }
  }
}

public enum UserRole: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case administrator
  case awaitingToJoin
  case manager
  case member
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ADMINISTRATOR": self = .administrator
      case "AWAITING_TO_JOIN": self = .awaitingToJoin
      case "MANAGER": self = .manager
      case "MEMBER": self = .member
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .administrator: return "ADMINISTRATOR"
      case .awaitingToJoin: return "AWAITING_TO_JOIN"
      case .manager: return "MANAGER"
      case .member: return "MEMBER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: UserRole, rhs: UserRole) -> Bool {
    switch (lhs, rhs) {
      case (.administrator, .administrator): return true
      case (.awaitingToJoin, .awaitingToJoin): return true
      case (.manager, .manager): return true
      case (.member, .member): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [UserRole] {
    return [
      .administrator,
      .awaitingToJoin,
      .manager,
      .member,
    ]
  }
}

public final class RegisterFcmMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation registerFcm($input: RegisterFcmMutationInput!) {
      registerFcm(input: $input)
    }
    """

  public let operationName: String = "registerFcm"

  public var input: RegisterFcmMutationInput

  public init(input: RegisterFcmMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("registerFcm", arguments: ["input": GraphQLVariable("input")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(registerFcm: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "registerFcm": registerFcm])
    }

    public var registerFcm: Bool? {
      get {
        return resultMap["registerFcm"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "registerFcm")
      }
    }
  }
}

public final class UnregisterFcmMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation unregisterFcm($input: UnregisterFcmMutationInput!) {
      unregisterFcm(input: $input)
    }
    """

  public let operationName: String = "unregisterFcm"

  public var input: UnregisterFcmMutationInput

  public init(input: UnregisterFcmMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("unregisterFcm", arguments: ["input": GraphQLVariable("input")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(unregisterFcm: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "unregisterFcm": unregisterFcm])
    }

    public var unregisterFcm: Bool? {
      get {
        return resultMap["unregisterFcm"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "unregisterFcm")
      }
    }
  }
}

public final class RequestJoinWorkspaceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation requestJoinWorkspace($id: String!) {
      requestToJoinWorkspace(workspaceId: $id)
    }
    """

  public let operationName: String = "requestJoinWorkspace"

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("requestToJoinWorkspace", arguments: ["workspaceId": GraphQLVariable("id")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(requestToJoinWorkspace: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "requestToJoinWorkspace": requestToJoinWorkspace])
    }

    /// RequestToJoinWorkspace requests to join workspace
    /// 
    /// Administrator of that workspace can accept or deny the request
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

public final class CancelJoinWorkspaceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation cancelJoinWorkspace($id: String!) {
      cancelToJoinWorkspace(workspaceId: $id)
    }
    """

  public let operationName: String = "cancelJoinWorkspace"

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("cancelToJoinWorkspace", arguments: ["workspaceId": GraphQLVariable("id")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(cancelToJoinWorkspace: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "cancelToJoinWorkspace": cancelToJoinWorkspace])
    }

    /// CancelToJoinWorkspace cancels the request to join workspace
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

public final class RequestAuthMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation requestAuth($input: RequestVerificationNumberMutationInput!) {
      requestVerificationNumber(input: $input) {
        __typename
        id
        verificationNumber
        expires
        user {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "requestAuth"

  public var input: RequestVerificationNumberMutationInput

  public init(input: RequestVerificationNumberMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("requestVerificationNumber", arguments: ["input": GraphQLVariable("input")], type: .object(RequestVerificationNumber.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(requestVerificationNumber: RequestVerificationNumber? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "requestVerificationNumber": requestVerificationNumber.flatMap { (value: RequestVerificationNumber) -> ResultMap in value.resultMap }])
    }

    /// Send verification number by email or SMS.
    public var requestVerificationNumber: RequestVerificationNumber? {
      get {
        return (resultMap["requestVerificationNumber"] as? ResultMap).flatMap { RequestVerificationNumber(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "requestVerificationNumber")
      }
    }

    public struct RequestVerificationNumber: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AuthenticationRequestType"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
          GraphQLField("verificationNumber", type: .scalar(String.self)),
          GraphQLField("expires", type: .nonNull(.scalar(DateTime.self))),
          GraphQLField("user", type: .object(User.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, verificationNumber: String? = nil, expires: DateTime, user: User? = nil) {
        self.init(unsafeResultMap: ["__typename": "AuthenticationRequestType", "id": id, "verificationNumber": verificationNumber, "expires": expires, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var verificationNumber: String? {
        get {
          return resultMap["verificationNumber"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "verificationNumber")
        }
      }

      public var expires: DateTime {
        get {
          return resultMap["expires"]! as! DateTime
        }
        set {
          resultMap.updateValue(newValue, forKey: "expires")
        }
      }

      public var user: User? {
        get {
          return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
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
}

public final class CheckAuthMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation checkAuth($input: CheckVerificationNumberMutationInput!) {
      checkVerificationNumber(input: $input) {
        __typename
        id
        isExpired
        scope
        token
        user {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "checkAuth"

  public var input: CheckVerificationNumberMutationInput

  public init(input: CheckVerificationNumberMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("checkVerificationNumber", arguments: ["input": GraphQLVariable("input")], type: .object(CheckVerificationNumber.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(checkVerificationNumber: CheckVerificationNumber? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "checkVerificationNumber": checkVerificationNumber.flatMap { (value: CheckVerificationNumber) -> ResultMap in value.resultMap }])
    }

    /// Check verification number and close request when valid number
    public var checkVerificationNumber: CheckVerificationNumber? {
      get {
        return (resultMap["checkVerificationNumber"] as? ResultMap).flatMap { CheckVerificationNumber(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "checkVerificationNumber")
      }
    }

    public struct CheckVerificationNumber: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AuthenticationTokenType"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
          GraphQLField("isExpired", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("scope", type: .nonNull(.scalar(AuthenticationTokenScope.self))),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("user", type: .object(User.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, isExpired: Bool, scope: AuthenticationTokenScope, token: String? = nil, user: User? = nil) {
        self.init(unsafeResultMap: ["__typename": "AuthenticationTokenType", "id": id, "isExpired": isExpired, "scope": scope, "token": token, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var isExpired: Bool {
        get {
          return resultMap["isExpired"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isExpired")
        }
      }

      public var scope: AuthenticationTokenScope {
        get {
          return resultMap["scope"]! as! AuthenticationTokenScope
        }
        set {
          resultMap.updateValue(newValue, forKey: "scope")
        }
      }

      public var token: String? {
        get {
          return resultMap["token"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var user: User? {
        get {
          return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
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
}

public final class ResetPasswordMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation resetPassword($input: ResetPasswordMutationInput!) {
      resetPassword(input: $input)
    }
    """

  public let operationName: String = "resetPassword"

  public var input: ResetPasswordMutationInput

  public init(input: ResetPasswordMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("resetPassword", arguments: ["input": GraphQLVariable("input")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(resetPassword: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "resetPassword": resetPassword])
    }

    /// ResetPassword updates user's password with additional authentication token
    public var resetPassword: Bool? {
      get {
        return resultMap["resetPassword"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "resetPassword")
      }
    }
  }
}

public final class ReleaseAccountMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation releaseAccount($token: String!) {
      releaseAccount(token: $token)
    }
    """

  public let operationName: String = "releaseAccount"

  public var token: String

  public init(token: String) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("releaseAccount", arguments: ["token": GraphQLVariable("token")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(releaseAccount: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "releaseAccount": releaseAccount])
    }

    /// ReleaseAccount sets inactive user to active with authentication token
    public var releaseAccount: Bool? {
      get {
        return resultMap["releaseAccount"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "releaseAccount")
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
        ...UserFragment
      }
    }
    """

  public let operationName: String = "signUp"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var input: CreateUserMutationInput

  public init(input: CreateUserMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

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
      self.init(unsafeResultMap: ["__typename": "mutation_root", "createUser": createUser.flatMap { (value: CreateUser) -> ResultMap in value.resultMap }])
    }

    /// CreateUser creates new user without any previleges
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

public final class ValidateUsernameMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation validateUsername($id: String!) {
      validateUsername(username: $id)
    }
    """

  public let operationName: String = "validateUsername"

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("validateUsername", arguments: ["username": GraphQLVariable("id")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(validateUsername: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "validateUsername": validateUsername])
    }

    /// ValidateUserName checks whether given username is already used or not
    public var validateUsername: Bool? {
      get {
        return resultMap["validateUsername"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "validateUsername")
      }
    }
  }
}

public final class WithdrawMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation withdraw {
      withdrawUser
    }
    """

  public let operationName: String = "withdraw"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("withdrawUser", type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(withdrawUser: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "withdrawUser": withdrawUser])
    }

    /// WithdrawUser deletes user itself
    /// 
    /// Administrator of any workspace cannot be withdrawn
    public var withdrawUser: Bool? {
      get {
        return resultMap["withdrawUser"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "withdrawUser")
      }
    }
  }
}

public final class UpdateUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation updateUser($input: UpdateUserMutationInput!) {
      updateUser(input: $input) {
        __typename
        ...UserFragment
      }
    }
    """

  public let operationName: String = "updateUser"

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
    public static let possibleTypes: [String] = ["mutation_root"]

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
      self.init(unsafeResultMap: ["__typename": "mutation_root", "updateUser": updateUser.flatMap { (value: UpdateUser) -> ResultMap in value.resultMap }])
    }

    /// UpdateUser updates user whose username is given username
    /// 
    /// Updatable fields are password, display_name, email, and phone_number
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

public final class UpdateUserEmailMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation updateUserEmail($token: String!) {
      updateUserEmail(token: $token)
    }
    """

  public let operationName: String = "updateUserEmail"

  public var token: String

  public init(token: String) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateUserEmail", arguments: ["token": GraphQLVariable("token")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateUserEmail: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "updateUserEmail": updateUserEmail])
    }

    /// UpdateUserEmail updates user's email by given authentication token
    public var updateUserEmail: Bool? {
      get {
        return resultMap["updateUserEmail"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "updateUserEmail")
      }
    }
  }
}

public final class LeaveWorkspaceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation leaveWorkspace($id: String!) {
      leaveWorkspace(workspaceId: $id)
    }
    """

  public let operationName: String = "leaveWorkspace"

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("leaveWorkspace", arguments: ["workspaceId": GraphQLVariable("id")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(leaveWorkspace: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "leaveWorkspace": leaveWorkspace])
    }

    /// LeaveWorkspace removes the role of the user itself to given workspace
    /// Administrator of that workspace cannot leave workspace
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
    public static let possibleTypes: [String] = ["mutation_root"]

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
      self.init(unsafeResultMap: ["__typename": "mutation_root", "completeServiceUnit": completeServiceUnit.flatMap { (value: CompleteServiceUnit) -> ResultMap in value.resultMap }])
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

public final class CreateServiceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createService($input: CreateServiceWithServiceTemplateInput!) {
      createServiceWithServiceTemplate(createServiceInput: $input) {
        __typename
        ...ServiceFragment
      }
    }
    """

  public let operationName: String = "createService"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceFragment.fragmentDefinition)
    document.append("\n" + RobotFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitFragment.fragmentDefinition)
    document.append("\n" + StopFragment.fragmentDefinition)
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var input: CreateServiceWithServiceTemplateInput

  public init(input: CreateServiceWithServiceTemplateInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createServiceWithServiceTemplate", arguments: ["createServiceInput": GraphQLVariable("input")], type: .object(CreateServiceWithServiceTemplate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createServiceWithServiceTemplate: CreateServiceWithServiceTemplate? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "createServiceWithServiceTemplate": createServiceWithServiceTemplate.flatMap { (value: CreateServiceWithServiceTemplate) -> ResultMap in value.resultMap }])
    }

    /// CreateServiceWithServiceTemplate creates with given service template and arguments
    public var createServiceWithServiceTemplate: CreateServiceWithServiceTemplate? {
      get {
        return (resultMap["createServiceWithServiceTemplate"] as? ResultMap).flatMap { CreateServiceWithServiceTemplate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createServiceWithServiceTemplate")
      }
    }

    public struct CreateServiceWithServiceTemplate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ServiceNode"]

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

public final class CancelServiceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation cancelService($id: String) {
      cancelService(serviceId: $id) {
        __typename
        ok
      }
    }
    """

  public let operationName: String = "cancelService"

  public var id: String?

  public init(id: String? = nil) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("cancelService", arguments: ["serviceId": GraphQLVariable("id")], type: .object(CancelService.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(cancelService: CancelService? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "cancelService": cancelService.flatMap { (value: CancelService) -> ResultMap in value.resultMap }])
    }

    /// CancelService immediately cancels service
    public var cancelService: CancelService? {
      get {
        return (resultMap["cancelService"] as? ResultMap).flatMap { CancelService(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "cancelService")
      }
    }

    public struct CancelService: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CancelServiceMutation"]

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
        self.init(unsafeResultMap: ["__typename": "CancelServiceMutation", "ok": ok])
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

public final class CreateServiceTemplateMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createServiceTemplate($input: CreateServiceTemplateFromServiceInput!) {
      createServiceTemplateFromService(input: $input) {
        __typename
        ...ServiceTemplateFragment
      }
    }
    """

  public let operationName: String = "createServiceTemplate"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceTemplateFragment.fragmentDefinition)
    return document
  }

  public var input: CreateServiceTemplateFromServiceInput

  public init(input: CreateServiceTemplateFromServiceInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createServiceTemplateFromService", arguments: ["input": GraphQLVariable("input")], type: .object(CreateServiceTemplateFromService.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createServiceTemplateFromService: CreateServiceTemplateFromService? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "createServiceTemplateFromService": createServiceTemplateFromService.flatMap { (value: CreateServiceTemplateFromService) -> ResultMap in value.resultMap }])
    }

    /// CreateServiceTemplateFromService copies service to new service template
    /// 
    /// New service template created this way cannot have any arguments
    public var createServiceTemplateFromService: CreateServiceTemplateFromService? {
      get {
        return (resultMap["createServiceTemplateFromService"] as? ResultMap).flatMap { CreateServiceTemplateFromService(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createServiceTemplateFromService")
      }
    }

    public struct CreateServiceTemplateFromService: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ServiceTemplateNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ServiceTemplateFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, serviceType: String, description: String? = nil, arguments: GenericScalar? = nil, types: GenericScalar? = nil, isCompiled: Bool) {
        self.init(unsafeResultMap: ["__typename": "ServiceTemplateNode", "id": id, "name": name, "serviceType": serviceType, "description": description, "arguments": arguments, "types": types, "isCompiled": isCompiled])
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

        public var serviceTemplateFragment: ServiceTemplateFragment {
          get {
            return ServiceTemplateFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class DeleteServiceTemplateMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation deleteServiceTemplate($id: ID!) {
      deleteServiceTemplate(id: $id)
    }
    """

  public let operationName: String = "deleteServiceTemplate"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteServiceTemplate", arguments: ["id": GraphQLVariable("id")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteServiceTemplate: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "deleteServiceTemplate": deleteServiceTemplate])
    }

    /// DeleteServiceTemplate deletes service template with given id
    public var deleteServiceTemplate: Bool? {
      get {
        return resultMap["deleteServiceTemplate"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteServiceTemplate")
      }
    }
  }
}

public final class CheckSessionQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query checkSession {
      isVaildAccessToken
    }
    """

  public let operationName: String = "checkSession"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("isVaildAccessToken", type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(isVaildAccessToken: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "query_root", "isVaildAccessToken": isVaildAccessToken])
    }

    public var isVaildAccessToken: Bool? {
      get {
        return resultMap["isVaildAccessToken"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "isVaildAccessToken")
      }
    }
  }
}

public final class FindUserQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query findUser($token: String) {
      findUser(token: $token) {
        __typename
        username
      }
    }
    """

  public let operationName: String = "findUser"

  public var token: String?

  public init(token: String? = nil) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("findUser", arguments: ["token": GraphQLVariable("token")], type: .object(FindUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(findUser: FindUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "query_root", "findUser": findUser.flatMap { (value: FindUser) -> ResultMap in value.resultMap }])
    }

    /// FindUser gets user by email authenticated token
    public var findUser: FindUser? {
      get {
        return (resultMap["findUser"] as? ResultMap).flatMap { FindUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "findUser")
      }
    }

    public struct FindUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("username", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(username: String) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "username": username])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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
    }
  }
}

public final class WorkspaceByCodeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query workspaceByCode($code: String!) {
      workspaces(code: $code) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...OnlyWorkspaceFragment
          }
        }
      }
    }
    """

  public let operationName: String = "workspaceByCode"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + OnlyWorkspaceFragment.fragmentDefinition)
    return document
  }

  public var code: String

  public init(code: String) {
    self.code = code
  }

  public var variables: GraphQLMap? {
    return ["code": code]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("workspaces", arguments: ["code": GraphQLVariable("code")], type: .object(Workspace.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(workspaces: Workspace? = nil) {
      self.init(unsafeResultMap: ["__typename": "query_root", "workspaces": workspaces.flatMap { (value: Workspace) -> ResultMap in value.resultMap }])
    }

    public var workspaces: Workspace? {
      get {
        return (resultMap["workspaces"] as? ResultMap).flatMap { Workspace(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "workspaces")
      }
    }

    public struct Workspace: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["OnlyWorkspaceNodeConnection"]

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
        self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
        public static let possibleTypes: [String] = ["OnlyWorkspaceNodeEdge"]

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
          self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
          public static let possibleTypes: [String] = ["OnlyWorkspaceNode"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(OnlyWorkspaceFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String, code: String? = nil, createdAt: DateTime, role: UserRole? = nil, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, totalMemberCount: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNode", "id": id, "name": name, "code": code, "createdAt": createdAt, "role": role, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "totalMemberCount": totalMemberCount])
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

            public var onlyWorkspaceFragment: OnlyWorkspaceFragment {
              get {
                return OnlyWorkspaceFragment(unsafeResultMap: resultMap)
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

public final class MyWorkspacesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query myWorkspaces {
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
        awaitingToJoinWorkspaces {
          __typename
          edges {
            __typename
            node {
              __typename
              ...OnlyWorkspaceFragment
            }
          }
        }
      }
    }
    """

  public let operationName: String = "myWorkspaces"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + WorkspaceFragment.fragmentDefinition)
    document.append("\n" + OnlyWorkspaceFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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
          GraphQLField("awaitingToJoinWorkspaces", type: .object(AwaitingToJoinWorkspace.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(joinedWorkspaces: JoinedWorkspace? = nil, awaitingToJoinWorkspaces: AwaitingToJoinWorkspace? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserNode", "joinedWorkspaces": joinedWorkspaces.flatMap { (value: JoinedWorkspace) -> ResultMap in value.resultMap }, "awaitingToJoinWorkspaces": awaitingToJoinWorkspaces.flatMap { (value: AwaitingToJoinWorkspace) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// JoinedWorkspaces are list of workspaces that user has joined
      public var joinedWorkspaces: JoinedWorkspace? {
        get {
          return (resultMap["joinedWorkspaces"] as? ResultMap).flatMap { JoinedWorkspace(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "joinedWorkspaces")
        }
      }

      /// AwaitingToJoinedWorkspaces are list of workspaces that user is waiting for acceptence of administrator to join
      public var awaitingToJoinWorkspaces: AwaitingToJoinWorkspace? {
        get {
          return (resultMap["awaitingToJoinWorkspaces"] as? ResultMap).flatMap { AwaitingToJoinWorkspace(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "awaitingToJoinWorkspaces")
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

      public struct AwaitingToJoinWorkspace: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OnlyWorkspaceNodeConnection"]

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
          self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
          public static let possibleTypes: [String] = ["OnlyWorkspaceNodeEdge"]

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
            self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["OnlyWorkspaceNode"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLFragmentSpread(OnlyWorkspaceFragment.self),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, name: String, code: String? = nil, createdAt: DateTime, role: UserRole? = nil, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, totalMemberCount: Int? = nil) {
              self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNode", "id": id, "name": name, "code": code, "createdAt": createdAt, "role": role, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "totalMemberCount": totalMemberCount])
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

              public var onlyWorkspaceFragment: OnlyWorkspaceFragment {
                get {
                  return OnlyWorkspaceFragment(unsafeResultMap: resultMap)
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

public final class WorkspaceByIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query workspaceById($id: String!) {
      signedUser {
        __typename
        joinedWorkspaces(id: $id) {
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

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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
          GraphQLField("joinedWorkspaces", arguments: ["id": GraphQLVariable("id")], type: .object(JoinedWorkspace.selections)),
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

      /// JoinedWorkspaces are list of workspaces that user has joined
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

public final class ServiceQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query service($workspaceId: String!, $serviceId: String!) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              services(id: $serviceId) {
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
          }
        }
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
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String
  public var serviceId: String

  public init(workspaceId: String, serviceId: String) {
    self.workspaceId = workspaceId
    self.serviceId = serviceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId, "serviceId": serviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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

      /// JoinedWorkspaces are list of workspaces that user has joined
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
                GraphQLField("services", arguments: ["id": GraphQLVariable("serviceId")], type: .object(Service.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(services: Service? = nil) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "services": services.flatMap { (value: Service) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var services: Service? {
              get {
                return (resultMap["services"] as? ResultMap).flatMap { Service(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "services")
              }
            }

            public struct Service: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ServiceNodeConnection"]

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
                self.init(unsafeResultMap: ["__typename": "ServiceNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
                public static let possibleTypes: [String] = ["ServiceNodeEdge"]

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
                  self.init(unsafeResultMap: ["__typename": "ServiceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
                  public static let possibleTypes: [String] = ["ServiceNode"]

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
      }
    }
  }
}

public final class ServicesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query services($workspaceId: String!, $after: String, $first: Int, $phases: [String]) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              services(after: $after, first: $first, phases: $phases) {
                __typename
                pageInfo {
                  __typename
                  endCursor
                  hasNextPage
                }
                edges {
                  __typename
                  node {
                    __typename
                    ...ServiceFragment
                  }
                }
              }
            }
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
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String
  public var after: String?
  public var first: Int?
  public var phases: [String?]?

  public init(workspaceId: String, after: String? = nil, first: Int? = nil, phases: [String?]? = nil) {
    self.workspaceId = workspaceId
    self.after = after
    self.first = first
    self.phases = phases
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId, "after": after, "first": first, "phases": phases]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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

      /// JoinedWorkspaces are list of workspaces that user has joined
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
                GraphQLField("services", arguments: ["after": GraphQLVariable("after"), "first": GraphQLVariable("first"), "phases": GraphQLVariable("phases")], type: .object(Service.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(services: Service? = nil) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "services": services.flatMap { (value: Service) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var services: Service? {
              get {
                return (resultMap["services"] as? ResultMap).flatMap { Service(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "services")
              }
            }

            public struct Service: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ServiceNodeConnection"]

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
                self.init(unsafeResultMap: ["__typename": "ServiceNodeConnection", "pageInfo": pageInfo.resultMap, "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
                    GraphQLField("endCursor", type: .scalar(String.self)),
                    GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(endCursor: String? = nil, hasNextPage: Bool) {
                  self.init(unsafeResultMap: ["__typename": "PageInfo", "endCursor": endCursor, "hasNextPage": hasNextPage])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// When paginating forwards, the cursor to continue.
                public var endCursor: String? {
                  get {
                    return resultMap["endCursor"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "endCursor")
                  }
                }

                /// When paginating forwards, are there more items?
                public var hasNextPage: Bool {
                  get {
                    return resultMap["hasNextPage"]! as! Bool
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "hasNextPage")
                  }
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ServiceNodeEdge"]

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
                  self.init(unsafeResultMap: ["__typename": "ServiceNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
                  public static let possibleTypes: [String] = ["ServiceNode"]

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
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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

public final class StopListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query stopList($workspaceId: String!, $name: String) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              stationGroups(isStop: true, name: $name) {
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

  public let operationName: String = "stopList"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + StopFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: String
  public var name: String?

  public init(workspaceId: String, name: String? = nil) {
    self.workspaceId = workspaceId
    self.name = name
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId, "name": name]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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

      /// JoinedWorkspaces are list of workspaces that user has joined
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
                GraphQLField("stationGroups", arguments: ["isStop": true, "name": GraphQLVariable("name")], type: .object(StationGroup.selections)),
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

                  public init(id: GraphQLID, name: String, isStop: Bool, remark: JSONString) {
                    self.init(unsafeResultMap: ["__typename": "StationGroupNode", "id": id, "name": name, "isStop": isStop, "remark": remark])
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

public final class UserListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query userList($workspaceId: String!, $displayName: String) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              members(roles: [MEMBER, MANAGER, ADMINISTRATOR], displayName: $displayName) {
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

  public var workspaceId: String
  public var displayName: String?

  public init(workspaceId: String, displayName: String? = nil) {
    self.workspaceId = workspaceId
    self.displayName = displayName
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId, "displayName": displayName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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

      /// JoinedWorkspaces are list of workspaces that user has joined
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
                GraphQLField("members", arguments: ["roles": ["MEMBER", "MANAGER", "ADMINISTRATOR"], "displayName": GraphQLVariable("displayName")], type: .object(Member.selections)),
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

                  public init(id: GraphQLID, username: String? = nil, displayName: String? = nil, email: String? = nil, phoneNumber: String? = nil, role: UserRole? = nil) {
                    self.init(unsafeResultMap: ["__typename": "MemberNode", "id": id, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber, "role": role])
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

public final class ClientVersionQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query clientVersion {
      clientVersion(clientType: IOS_AP) {
        __typename
        ...VersionFragment
      }
    }
    """

  public let operationName: String = "clientVersion"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + VersionFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("clientVersion", arguments: ["clientType": "IOS_AP"], type: .object(ClientVersion.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(clientVersion: ClientVersion? = nil) {
      self.init(unsafeResultMap: ["__typename": "query_root", "clientVersion": clientVersion.flatMap { (value: ClientVersion) -> ResultMap in value.resultMap }])
    }

    public var clientVersion: ClientVersion? {
      get {
        return (resultMap["clientVersion"] as? ResultMap).flatMap { ClientVersion(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "clientVersion")
      }
    }

    public struct ClientVersion: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ClientVersionNode"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(VersionFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(minVersionCode: Int? = nil, currentVersionCode: Int? = nil, currentVersionName: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "ClientVersionNode", "minVersionCode": minVersionCode, "currentVersionCode": currentVersionCode, "currentVersionName": currentVersionName])
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

        public var versionFragment: VersionFragment {
          get {
            return VersionFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ServiceTemplatesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query serviceTemplates($workspaceId: ID) {
      serviceTemplates(workspaceId: $workspaceId) {
        __typename
        edges {
          __typename
          node {
            __typename
            ...ServiceTemplateFragment
          }
        }
      }
    }
    """

  public let operationName: String = "serviceTemplates"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceTemplateFragment.fragmentDefinition)
    return document
  }

  public var workspaceId: GraphQLID?

  public init(workspaceId: GraphQLID? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("serviceTemplates", arguments: ["workspaceId": GraphQLVariable("workspaceId")], type: .object(ServiceTemplate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(serviceTemplates: ServiceTemplate? = nil) {
      self.init(unsafeResultMap: ["__typename": "query_root", "serviceTemplates": serviceTemplates.flatMap { (value: ServiceTemplate) -> ResultMap in value.resultMap }])
    }

    public var serviceTemplates: ServiceTemplate? {
      get {
        return (resultMap["serviceTemplates"] as? ResultMap).flatMap { ServiceTemplate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "serviceTemplates")
      }
    }

    public struct ServiceTemplate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ServiceTemplateNodeConnection"]

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
        self.init(unsafeResultMap: ["__typename": "ServiceTemplateNodeConnection", "edges": edges.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } }])
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
        public static let possibleTypes: [String] = ["ServiceTemplateNodeEdge"]

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
          self.init(unsafeResultMap: ["__typename": "ServiceTemplateNodeEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
          public static let possibleTypes: [String] = ["ServiceTemplateNode"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(ServiceTemplateFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String, serviceType: String, description: String? = nil, arguments: GenericScalar? = nil, types: GenericScalar? = nil, isCompiled: Bool) {
            self.init(unsafeResultMap: ["__typename": "ServiceTemplateNode", "id": id, "name": name, "serviceType": serviceType, "description": description, "arguments": arguments, "types": types, "isCompiled": isCompiled])
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

            public var serviceTemplateFragment: ServiceTemplateFragment {
              get {
                return ServiceTemplateFragment(unsafeResultMap: resultMap)
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

public final class ServicesInProgressQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query servicesInProgress($workspaceId: String) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              services(phases: ["Initialization", "Executing"]) {
                __typename
                totalCount
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "servicesInProgress"

  public var workspaceId: String?

  public init(workspaceId: String? = nil) {
    self.workspaceId = workspaceId
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

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
      self.init(unsafeResultMap: ["__typename": "query_root", "signedUser": signedUser.flatMap { (value: SignedUser) -> ResultMap in value.resultMap }])
    }

    /// SignedUser gets user by given access token
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

      /// JoinedWorkspaces are list of workspaces that user has joined
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
                GraphQLField("services", arguments: ["phases": ["Initialization", "Executing"]], type: .object(Service.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(services: Service? = nil) {
              self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "services": services.flatMap { (value: Service) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var services: Service? {
              get {
                return (resultMap["services"] as? ResultMap).flatMap { Service(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "services")
              }
            }

            public struct Service: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ServiceNodeConnection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("totalCount", type: .scalar(Int.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(totalCount: Int? = nil) {
                self.init(unsafeResultMap: ["__typename": "ServiceNodeConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalCount: Int? {
                get {
                  return resultMap["totalCount"] as? Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "totalCount")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class ServiceByIdSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription serviceById($id: String!) {
      service_tmp(where: {id: {_eq: $id}}) {
        __typename
        ...ServiceRawFragment
      }
    }
    """

  public let operationName: String = "serviceById"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceRawFragment.fragmentDefinition)
    document.append("\n" + RobotRawFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitRawFragment.fragmentDefinition)
    document.append("\n" + StopRawFragment.fragmentDefinition)
    return document
  }

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["subscription_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("service_tmp", arguments: ["where": ["id": ["_eq": GraphQLVariable("id")]]], type: .nonNull(.list(.nonNull(.object(ServiceTmp.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(serviceTmp: [ServiceTmp]) {
      self.init(unsafeResultMap: ["__typename": "subscription_root", "service_tmp": serviceTmp.map { (value: ServiceTmp) -> ResultMap in value.resultMap }])
    }

    /// fetch data from the table: "taras_core_service"
    public var serviceTmp: [ServiceTmp] {
      get {
        return (resultMap["service_tmp"] as! [ResultMap]).map { (value: ResultMap) -> ServiceTmp in ServiceTmp(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ServiceTmp) -> ResultMap in value.resultMap }, forKey: "service_tmp")
      }
    }

    public struct ServiceTmp: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["service_tmp"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ServiceRawFragment.self),
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

        public var serviceRawFragment: ServiceRawFragment {
          get {
            return ServiceRawFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ServicesByWorkspaceIdSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription servicesByWorkspaceId($id: String!, $userId: String!, $jsonFilter: jsonb!) {
      service_change_set(
        where: {_and: [{service: {workspace_id: {_eq: $id}}}, {_or: [{service: {service_units: {receivers: {id: {_eq: $userId}}}}}, {service: {creator: {_contains: $jsonFilter}}}]}]}
        order_by: {created_at: asc}
      ) {
        __typename
        event_type
        service {
          __typename
          ...ServiceRawFragment
        }
      }
    }
    """

  public let operationName: String = "servicesByWorkspaceId"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceRawFragment.fragmentDefinition)
    document.append("\n" + RobotRawFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitRawFragment.fragmentDefinition)
    document.append("\n" + StopRawFragment.fragmentDefinition)
    return document
  }

  public var id: String
  public var userId: String
  public var jsonFilter: jsonb

  public init(id: String, userId: String, jsonFilter: jsonb) {
    self.id = id
    self.userId = userId
    self.jsonFilter = jsonFilter
  }

  public var variables: GraphQLMap? {
    return ["id": id, "userId": userId, "jsonFilter": jsonFilter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["subscription_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("service_change_set", arguments: ["where": ["_and": [["service": ["workspace_id": ["_eq": GraphQLVariable("id")]]], ["_or": [["service": ["service_units": ["receivers": ["id": ["_eq": GraphQLVariable("userId")]]]]], ["service": ["creator": ["_contains": GraphQLVariable("jsonFilter")]]]]]]], "order_by": ["created_at": "asc"]], type: .nonNull(.list(.nonNull(.object(ServiceChangeSet.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(serviceChangeSet: [ServiceChangeSet]) {
      self.init(unsafeResultMap: ["__typename": "subscription_root", "service_change_set": serviceChangeSet.map { (value: ServiceChangeSet) -> ResultMap in value.resultMap }])
    }

    /// fetch data from the table: "service_change_set"
    public var serviceChangeSet: [ServiceChangeSet] {
      get {
        return (resultMap["service_change_set"] as! [ResultMap]).map { (value: ResultMap) -> ServiceChangeSet in ServiceChangeSet(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ServiceChangeSet) -> ResultMap in value.resultMap }, forKey: "service_change_set")
      }
    }

    public struct ServiceChangeSet: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["service_change_set"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("event_type", type: .nonNull(.scalar(bpchar.self))),
          GraphQLField("service", type: .nonNull(.object(Service.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(eventType: bpchar, service: Service) {
        self.init(unsafeResultMap: ["__typename": "service_change_set", "event_type": eventType, "service": service.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var eventType: bpchar {
        get {
          return resultMap["event_type"]! as! bpchar
        }
        set {
          resultMap.updateValue(newValue, forKey: "event_type")
        }
      }

      /// An object relationship
      public var service: Service {
        get {
          return Service(unsafeResultMap: resultMap["service"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "service")
        }
      }

      public struct Service: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["service_tmp"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ServiceRawFragment.self),
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

          public var serviceRawFragment: ServiceRawFragment {
            get {
              return ServiceRawFragment(unsafeResultMap: resultMap)
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

public struct UserRawFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserRawFragment on user {
      __typename
      id
      username
      display_name
      email
      phone_number
    }
    """

  public static let possibleTypes: [String] = ["user"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(String.self))),
      GraphQLField("username", type: .nonNull(.scalar(String.self))),
      GraphQLField("display_name", type: .nonNull(.scalar(String.self))),
      GraphQLField("email", type: .scalar(bytea.self)),
      GraphQLField("phone_number", type: .scalar(bytea.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, username: String, displayName: String, email: bytea? = nil, phoneNumber: bytea? = nil) {
    self.init(unsafeResultMap: ["__typename": "user", "id": id, "username": username, "display_name": displayName, "email": email, "phone_number": phoneNumber])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["id"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var username: String {
    get {
      return resultMap["username"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "username")
    }
  }

  public var displayName: String {
    get {
      return resultMap["display_name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "display_name")
    }
  }

  public var email: bytea? {
    get {
      return resultMap["email"] as? bytea
    }
    set {
      resultMap.updateValue(newValue, forKey: "email")
    }
  }

  public var phoneNumber: bytea? {
    get {
      return resultMap["phone_number"] as? bytea
    }
    set {
      resultMap.updateValue(newValue, forKey: "phone_number")
    }
  }
}

public struct RobotRawFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment RobotRawFragment on robot {
      __typename
      key
      name
    }
    """

  public static let possibleTypes: [String] = ["robot"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("key", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(key: String, name: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "robot", "key": key, "name": name])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var key: String {
    get {
      return resultMap["key"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "key")
    }
  }

  /// A computed field, executes function "name"
  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }
}

public struct StopRawFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment StopRawFragment on station_group {
      __typename
      id
      name
      is_stop
      remark
    }
    """

  public static let possibleTypes: [String] = ["station_group"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("is_stop", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("remark", type: .nonNull(.scalar(jsonb.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, name: String, isStop: Bool, remark: jsonb) {
    self.init(unsafeResultMap: ["__typename": "station_group", "id": id, "name": name, "is_stop": isStop, "remark": remark])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["id"]! as! String
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
      return resultMap["is_stop"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "is_stop")
    }
  }

  public var remark: jsonb {
    get {
      return resultMap["remark"]! as! jsonb
    }
    set {
      resultMap.updateValue(newValue, forKey: "remark")
    }
  }
}

public struct ServiceUnitRawFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ServiceUnitRawFragment on service_unit {
      __typename
      id
      index
      message
      stop {
        __typename
        ...StopRawFragment
      }
      receivers {
        __typename
        id
        display_name
      }
    }
    """

  public static let possibleTypes: [String] = ["service_unit"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(bigint.self))),
      GraphQLField("index", type: .nonNull(.scalar(Int.self))),
      GraphQLField("message", type: .scalar(String.self)),
      GraphQLField("stop", type: .object(Stop.selections)),
      GraphQLField("receivers", type: .list(.nonNull(.object(Receiver.selections)))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: bigint, index: Int, message: String? = nil, stop: Stop? = nil, receivers: [Receiver]? = nil) {
    self.init(unsafeResultMap: ["__typename": "service_unit", "id": id, "index": index, "message": message, "stop": stop.flatMap { (value: Stop) -> ResultMap in value.resultMap }, "receivers": receivers.flatMap { (value: [Receiver]) -> [ResultMap] in value.map { (value: Receiver) -> ResultMap in value.resultMap } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: bigint {
    get {
      return resultMap["id"]! as! bigint
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var index: Int {
    get {
      return resultMap["index"]! as! Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "index")
    }
  }

  public var message: String? {
    get {
      return resultMap["message"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "message")
    }
  }

  /// An object relationship
  public var stop: Stop? {
    get {
      return (resultMap["stop"] as? ResultMap).flatMap { Stop(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "stop")
    }
  }

  /// A computed field, executes function "receivers"
  public var receivers: [Receiver]? {
    get {
      return (resultMap["receivers"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Receiver] in value.map { (value: ResultMap) -> Receiver in Receiver(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Receiver]) -> [ResultMap] in value.map { (value: Receiver) -> ResultMap in value.resultMap } }, forKey: "receivers")
    }
  }

  public struct Stop: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["station_group"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(StopRawFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: String, name: String, isStop: Bool, remark: jsonb) {
      self.init(unsafeResultMap: ["__typename": "station_group", "id": id, "name": name, "is_stop": isStop, "remark": remark])
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

      public var stopRawFragment: StopRawFragment {
        get {
          return StopRawFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Receiver: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["user"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("display_name", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: String, displayName: String) {
      self.init(unsafeResultMap: ["__typename": "user", "id": id, "display_name": displayName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: String {
      get {
        return resultMap["id"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var displayName: String {
      get {
        return resultMap["display_name"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "display_name")
      }
    }
  }
}

public struct ServiceRawFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ServiceRawFragment on service_tmp {
      __typename
      id
      phase
      type
      service_state
      timestamps
      service_number
      created_at
      creator
      robot {
        __typename
        ...RobotRawFragment
      }
      current_service_unit_step
      service_units {
        __typename
        ...ServiceUnitRawFragment
      }
      total_moving_distance
    }
    """

  public static let possibleTypes: [String] = ["service_tmp"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(String.self))),
      GraphQLField("phase", type: .scalar(String.self)),
      GraphQLField("type", type: .scalar(String.self)),
      GraphQLField("service_state", type: .scalar(String.self)),
      GraphQLField("timestamps", type: .nonNull(.scalar(jsonb.self))),
      GraphQLField("service_number", type: .nonNull(.scalar(String.self))),
      GraphQLField("created_at", type: .nonNull(.scalar(timestamptz.self))),
      GraphQLField("creator", type: .scalar(jsonb.self)),
      GraphQLField("robot", type: .object(Robot.selections)),
      GraphQLField("current_service_unit_step", type: .nonNull(.scalar(Int.self))),
      GraphQLField("service_units", type: .nonNull(.list(.nonNull(.object(ServiceUnit.selections))))),
      GraphQLField("total_moving_distance", type: .scalar(float8.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, phase: String? = nil, type: String? = nil, serviceState: String? = nil, timestamps: jsonb, serviceNumber: String, createdAt: timestamptz, creator: jsonb? = nil, robot: Robot? = nil, currentServiceUnitStep: Int, serviceUnits: [ServiceUnit], totalMovingDistance: float8? = nil) {
    self.init(unsafeResultMap: ["__typename": "service_tmp", "id": id, "phase": phase, "type": type, "service_state": serviceState, "timestamps": timestamps, "service_number": serviceNumber, "created_at": createdAt, "creator": creator, "robot": robot.flatMap { (value: Robot) -> ResultMap in value.resultMap }, "current_service_unit_step": currentServiceUnitStep, "service_units": serviceUnits.map { (value: ServiceUnit) -> ResultMap in value.resultMap }, "total_moving_distance": totalMovingDistance])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["id"]! as! String
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

  /// A computed field, executes function "service_state"
  public var serviceState: String? {
    get {
      return resultMap["service_state"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "service_state")
    }
  }

  public var timestamps: jsonb {
    get {
      return resultMap["timestamps"]! as! jsonb
    }
    set {
      resultMap.updateValue(newValue, forKey: "timestamps")
    }
  }

  public var serviceNumber: String {
    get {
      return resultMap["service_number"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "service_number")
    }
  }

  public var createdAt: timestamptz {
    get {
      return resultMap["created_at"]! as! timestamptz
    }
    set {
      resultMap.updateValue(newValue, forKey: "created_at")
    }
  }

  /// A computed field, executes function "creator"
  public var creator: jsonb? {
    get {
      return resultMap["creator"] as? jsonb
    }
    set {
      resultMap.updateValue(newValue, forKey: "creator")
    }
  }

  /// An object relationship
  public var robot: Robot? {
    get {
      return (resultMap["robot"] as? ResultMap).flatMap { Robot(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "robot")
    }
  }

  public var currentServiceUnitStep: Int {
    get {
      return resultMap["current_service_unit_step"]! as! Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "current_service_unit_step")
    }
  }

  /// An array relationship
  public var serviceUnits: [ServiceUnit] {
    get {
      return (resultMap["service_units"] as! [ResultMap]).map { (value: ResultMap) -> ServiceUnit in ServiceUnit(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: ServiceUnit) -> ResultMap in value.resultMap }, forKey: "service_units")
    }
  }

  /// A computed field, executes function "total_moving_distance"
  public var totalMovingDistance: float8? {
    get {
      return resultMap["total_moving_distance"] as? float8
    }
    set {
      resultMap.updateValue(newValue, forKey: "total_moving_distance")
    }
  }

  public struct Robot: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["robot"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(RobotRawFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(key: String, name: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "robot", "key": key, "name": name])
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

      public var robotRawFragment: RobotRawFragment {
        get {
          return RobotRawFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct ServiceUnit: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["service_unit"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ServiceUnitRawFragment.self),
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

      public var serviceUnitRawFragment: ServiceUnitRawFragment {
        get {
          return ServiceUnitRawFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
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

public struct MemberFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MemberFragment on MemberNode {
      __typename
      id
      username
      displayName
      email
      phoneNumber
      role
    }
    """

  public static let possibleTypes: [String] = ["MemberNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("username", type: .scalar(String.self)),
      GraphQLField("displayName", type: .scalar(String.self)),
      GraphQLField("email", type: .scalar(String.self)),
      GraphQLField("phoneNumber", type: .scalar(String.self)),
      GraphQLField("role", type: .scalar(UserRole.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, username: String? = nil, displayName: String? = nil, email: String? = nil, phoneNumber: String? = nil, role: UserRole? = nil) {
    self.init(unsafeResultMap: ["__typename": "MemberNode", "id": id, "username": username, "displayName": displayName, "email": email, "phoneNumber": phoneNumber, "role": role])
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

  public var username: String? {
    get {
      return resultMap["username"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "username")
    }
  }

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

  public var phoneNumber: String? {
    get {
      return resultMap["phoneNumber"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  public var role: UserRole? {
    get {
      return resultMap["role"] as? UserRole
    }
    set {
      resultMap.updateValue(newValue, forKey: "role")
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
    }
    """

  public static let possibleTypes: [String] = ["RobotNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "RobotNode", "id": id, "name": name])
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
      remark
    }
    """

  public static let possibleTypes: [String] = ["StationGroupNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("isStop", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("remark", type: .nonNull(.scalar(JSONString.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, isStop: Bool, remark: JSONString) {
    self.init(unsafeResultMap: ["__typename": "StationGroupNode", "id": id, "name": name, "isStop": isStop, "remark": remark])
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

  public var remark: JSONString {
    get {
      return resultMap["remark"]! as! JSONString
    }
    set {
      resultMap.updateValue(newValue, forKey: "remark")
    }
  }
}

public struct OnlyWorkspaceFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment OnlyWorkspaceFragment on OnlyWorkspaceNode {
      __typename
      id
      name
      code
      createdAt
      role
      isRequiredUserEmailToJoin
      isRequiredUserPhoneNumberToJoin
      totalMemberCount
    }
    """

  public static let possibleTypes: [String] = ["OnlyWorkspaceNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("code", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .nonNull(.scalar(DateTime.self))),
      GraphQLField("role", type: .scalar(UserRole.self)),
      GraphQLField("isRequiredUserEmailToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserPhoneNumberToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("totalMemberCount", type: .scalar(Int.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, code: String? = nil, createdAt: DateTime, role: UserRole? = nil, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, totalMemberCount: Int? = nil) {
    self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNode", "id": id, "name": name, "code": code, "createdAt": createdAt, "role": role, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "totalMemberCount": totalMemberCount])
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

  public var code: String? {
    get {
      return resultMap["code"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "code")
    }
  }

  public var createdAt: DateTime {
    get {
      return resultMap["createdAt"]! as! DateTime
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var role: UserRole? {
    get {
      return resultMap["role"] as? UserRole
    }
    set {
      resultMap.updateValue(newValue, forKey: "role")
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

  public var totalMemberCount: Int? {
    get {
      return resultMap["totalMemberCount"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "totalMemberCount")
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
      code
      createdAt
      members(roles: [MEMBER, MANAGER, ADMINISTRATOR]) {
        __typename
        totalCount
      }
    }
    """

  public static let possibleTypes: [String] = ["WorkspaceNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("code", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .scalar(String.self)),
      GraphQLField("members", arguments: ["roles": ["MEMBER", "MANAGER", "ADMINISTRATOR"]], type: .object(Member.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, code: String? = nil, createdAt: String? = nil, members: Member? = nil) {
    self.init(unsafeResultMap: ["__typename": "WorkspaceNode", "id": id, "name": name, "code": code, "createdAt": createdAt, "members": members.flatMap { (value: Member) -> ResultMap in value.resultMap }])
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

  public var code: String? {
    get {
      return resultMap["code"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "code")
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
        GraphQLField("totalCount", type: .scalar(Int.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(totalCount: Int? = nil) {
      self.init(unsafeResultMap: ["__typename": "MemberNodeConnection", "totalCount": totalCount])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var totalCount: Int? {
      get {
        return resultMap["totalCount"] as? Int
      }
      set {
        resultMap.updateValue(newValue, forKey: "totalCount")
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
      index
      state
      message
      stop {
        __typename
        ...StopFragment
      }
      receivers {
        __typename
        ...UserFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["ServiceUnitNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("index", type: .nonNull(.scalar(Int.self))),
      GraphQLField("state", type: .scalar(String.self)),
      GraphQLField("message", type: .scalar(String.self)),
      GraphQLField("stop", type: .object(Stop.selections)),
      GraphQLField("receivers", type: .list(.object(Receiver.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, index: Int, state: String? = nil, message: String? = nil, stop: Stop? = nil, receivers: [Receiver?]? = nil) {
    self.init(unsafeResultMap: ["__typename": "ServiceUnitNode", "id": id, "index": index, "state": state, "message": message, "stop": stop.flatMap { (value: Stop) -> ResultMap in value.resultMap }, "receivers": receivers.flatMap { (value: [Receiver?]) -> [ResultMap?] in value.map { (value: Receiver?) -> ResultMap? in value.flatMap { (value: Receiver) -> ResultMap in value.resultMap } } }])
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

  public var index: Int {
    get {
      return resultMap["index"]! as! Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "index")
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

  public var message: String? {
    get {
      return resultMap["message"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "message")
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

  public var receivers: [Receiver?]? {
    get {
      return (resultMap["receivers"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Receiver?] in value.map { (value: ResultMap?) -> Receiver? in value.flatMap { (value: ResultMap) -> Receiver in Receiver(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [Receiver?]) -> [ResultMap?] in value.map { (value: Receiver?) -> ResultMap? in value.flatMap { (value: Receiver) -> ResultMap in value.resultMap } } }, forKey: "receivers")
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

    public init(id: GraphQLID, name: String, isStop: Bool, remark: JSONString) {
      self.init(unsafeResultMap: ["__typename": "StationGroupNode", "id": id, "name": name, "isStop": isStop, "remark": remark])
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

  public struct Receiver: GraphQLSelectionSet {
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

public struct ServiceFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ServiceFragment on ServiceNode {
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
      serviceUnits {
        __typename
        ...ServiceUnitFragment
      }
      totalMovingDistance
    }
    """

  public static let possibleTypes: [String] = ["ServiceNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("phase", type: .scalar(String.self)),
      GraphQLField("type", type: .scalar(String.self)),
      GraphQLField("state", type: .scalar(String.self)),
      GraphQLField("timestamps", type: .scalar(GenericScalar.self)),
      GraphQLField("serviceNumber", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .nonNull(.scalar(DateTime.self))),
      GraphQLField("creator", type: .scalar(GenericScalar.self)),
      GraphQLField("robot", type: .object(Robot.selections)),
      GraphQLField("currentServiceUnitStep", type: .scalar(Int.self)),
      GraphQLField("serviceUnits", type: .list(.object(ServiceUnit.selections))),
      GraphQLField("totalMovingDistance", type: .scalar(Double.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, phase: String? = nil, type: String? = nil, state: String? = nil, timestamps: GenericScalar? = nil, serviceNumber: String? = nil, createdAt: DateTime, creator: GenericScalar? = nil, robot: Robot? = nil, currentServiceUnitStep: Int? = nil, serviceUnits: [ServiceUnit?]? = nil, totalMovingDistance: Double? = nil) {
    self.init(unsafeResultMap: ["__typename": "ServiceNode", "id": id, "phase": phase, "type": type, "state": state, "timestamps": timestamps, "serviceNumber": serviceNumber, "createdAt": createdAt, "creator": creator, "robot": robot.flatMap { (value: Robot) -> ResultMap in value.resultMap }, "currentServiceUnitStep": currentServiceUnitStep, "serviceUnits": serviceUnits.flatMap { (value: [ServiceUnit?]) -> [ResultMap?] in value.map { (value: ServiceUnit?) -> ResultMap? in value.flatMap { (value: ServiceUnit) -> ResultMap in value.resultMap } } }, "totalMovingDistance": totalMovingDistance])
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

  public var state: String? {
    get {
      return resultMap["state"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "state")
    }
  }

  public var timestamps: GenericScalar? {
    get {
      return resultMap["timestamps"] as? GenericScalar
    }
    set {
      resultMap.updateValue(newValue, forKey: "timestamps")
    }
  }

  public var serviceNumber: String? {
    get {
      return resultMap["serviceNumber"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "serviceNumber")
    }
  }

  public var createdAt: DateTime {
    get {
      return resultMap["createdAt"]! as! DateTime
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var creator: GenericScalar? {
    get {
      return resultMap["creator"] as? GenericScalar
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

  public var serviceUnits: [ServiceUnit?]? {
    get {
      return (resultMap["serviceUnits"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [ServiceUnit?] in value.map { (value: ResultMap?) -> ServiceUnit? in value.flatMap { (value: ResultMap) -> ServiceUnit in ServiceUnit(unsafeResultMap: value) } } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [ServiceUnit?]) -> [ResultMap?] in value.map { (value: ServiceUnit?) -> ResultMap? in value.flatMap { (value: ServiceUnit) -> ResultMap in value.resultMap } } }, forKey: "serviceUnits")
    }
  }

  public var totalMovingDistance: Double? {
    get {
      return resultMap["totalMovingDistance"] as? Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "totalMovingDistance")
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

    public init(id: GraphQLID, name: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "RobotNode", "id": id, "name": name])
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

public struct VersionFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment VersionFragment on ClientVersionNode {
      __typename
      minVersionCode
      currentVersionCode
      currentVersionName
    }
    """

  public static let possibleTypes: [String] = ["ClientVersionNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("minVersionCode", type: .scalar(Int.self)),
      GraphQLField("currentVersionCode", type: .scalar(Int.self)),
      GraphQLField("currentVersionName", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(minVersionCode: Int? = nil, currentVersionCode: Int? = nil, currentVersionName: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "ClientVersionNode", "minVersionCode": minVersionCode, "currentVersionCode": currentVersionCode, "currentVersionName": currentVersionName])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var minVersionCode: Int? {
    get {
      return resultMap["minVersionCode"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "minVersionCode")
    }
  }

  public var currentVersionCode: Int? {
    get {
      return resultMap["currentVersionCode"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "currentVersionCode")
    }
  }

  public var currentVersionName: String? {
    get {
      return resultMap["currentVersionName"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "currentVersionName")
    }
  }
}

public struct ServiceTemplateFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ServiceTemplateFragment on ServiceTemplateNode {
      __typename
      id
      name
      serviceType
      description
      arguments
      types
      isCompiled
    }
    """

  public static let possibleTypes: [String] = ["ServiceTemplateNode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("serviceType", type: .nonNull(.scalar(String.self))),
      GraphQLField("description", type: .scalar(String.self)),
      GraphQLField("arguments", type: .scalar(GenericScalar.self)),
      GraphQLField("types", type: .scalar(GenericScalar.self)),
      GraphQLField("isCompiled", type: .nonNull(.scalar(Bool.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, serviceType: String, description: String? = nil, arguments: GenericScalar? = nil, types: GenericScalar? = nil, isCompiled: Bool) {
    self.init(unsafeResultMap: ["__typename": "ServiceTemplateNode", "id": id, "name": name, "serviceType": serviceType, "description": description, "arguments": arguments, "types": types, "isCompiled": isCompiled])
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

  public var serviceType: String {
    get {
      return resultMap["serviceType"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "serviceType")
    }
  }

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }

  public var arguments: GenericScalar? {
    get {
      return resultMap["arguments"] as? GenericScalar
    }
    set {
      resultMap.updateValue(newValue, forKey: "arguments")
    }
  }

  public var types: GenericScalar? {
    get {
      return resultMap["types"] as? GenericScalar
    }
    set {
      resultMap.updateValue(newValue, forKey: "types")
    }
  }

  public var isCompiled: Bool {
    get {
      return resultMap["isCompiled"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isCompiled")
    }
  }
}
