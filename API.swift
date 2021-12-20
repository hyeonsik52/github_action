// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct RegisterFcmMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - deviceUniqueKey
  ///   - clientType
  ///   - fcmToken
  public init(deviceUniqueKey: String, clientType: String, fcmToken: String) {
    graphQLMap = ["deviceUniqueKey": deviceUniqueKey, "clientType": clientType, "fcmToken": fcmToken]
  }

  public var deviceUniqueKey: String {
    get {
      return graphQLMap["deviceUniqueKey"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "deviceUniqueKey")
    }
  }

  public var clientType: String {
    get {
      return graphQLMap["clientType"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientType")
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
  ///   - deviceUniqueKey
  ///   - clientType
  ///   - fcmToken
  public init(deviceUniqueKey: String, clientType: String, fcmToken: String) {
    graphQLMap = ["deviceUniqueKey": deviceUniqueKey, "clientType": clientType, "fcmToken": fcmToken]
  }

  public var deviceUniqueKey: String {
    get {
      return graphQLMap["deviceUniqueKey"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "deviceUniqueKey")
    }
  }

  public var clientType: String {
    get {
      return graphQLMap["clientType"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientType")
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
  ///   - methodType
  ///   - purpose
  ///   - data
  public init(methodType: Swift.Optional<VerificationMethod?> = nil, purpose: Swift.Optional<VerificationPurpose?> = nil, data: Swift.Optional<String?> = nil) {
    graphQLMap = ["methodType": methodType, "purpose": purpose, "data": data]
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

  public var data: Swift.Optional<String?> {
    get {
      return graphQLMap["data"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "data")
    }
  }
}

public enum VerificationMethod: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case email
  case sms
  case direct
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "EMAIL": self = .email
      case "SMS": self = .sms
      case "DIRECT": self = .direct
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .email: return "EMAIL"
      case .sms: return "SMS"
      case .direct: return "DIRECT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: VerificationMethod, rhs: VerificationMethod) -> Bool {
    switch (lhs, rhs) {
      case (.email, .email): return true
      case (.sms, .sms): return true
      case (.direct, .direct): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [VerificationMethod] {
    return [
      .email,
      .sms,
      .direct,
    ]
  }
}

public enum VerificationPurpose: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case createUser
  case releaseAccount
  case updateEmailAddress
  case updatePhoneNumber
  case resetPassword
  case findUser
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATE_USER": self = .createUser
      case "RELEASE_ACCOUNT": self = .releaseAccount
      case "UPDATE_EMAIL_ADDRESS": self = .updateEmailAddress
      case "UPDATE_PHONE_NUMBER": self = .updatePhoneNumber
      case "RESET_PASSWORD": self = .resetPassword
      case "FIND_USER": self = .findUser
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .createUser: return "CREATE_USER"
      case .releaseAccount: return "RELEASE_ACCOUNT"
      case .updateEmailAddress: return "UPDATE_EMAIL_ADDRESS"
      case .updatePhoneNumber: return "UPDATE_PHONE_NUMBER"
      case .resetPassword: return "RESET_PASSWORD"
      case .findUser: return "FIND_USER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: VerificationPurpose, rhs: VerificationPurpose) -> Bool {
    switch (lhs, rhs) {
      case (.createUser, .createUser): return true
      case (.releaseAccount, .releaseAccount): return true
      case (.updateEmailAddress, .updateEmailAddress): return true
      case (.updatePhoneNumber, .updatePhoneNumber): return true
      case (.resetPassword, .resetPassword): return true
      case (.findUser, .findUser): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [VerificationPurpose] {
    return [
      .createUser,
      .releaseAccount,
      .updateEmailAddress,
      .updatePhoneNumber,
      .resetPassword,
      .findUser,
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
  /// Update email address
  case updateEmailAddress
  /// Update phone number
  case updatePhoneNumber
  /// Release account
  case releaseAccount
  /// Reset password
  case resetPassword
  /// Find user
  case findUser
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATE_USER": self = .createUser
      case "UPDATE_EMAIL_ADDRESS": self = .updateEmailAddress
      case "UPDATE_PHONE_NUMBER": self = .updatePhoneNumber
      case "RELEASE_ACCOUNT": self = .releaseAccount
      case "RESET_PASSWORD": self = .resetPassword
      case "FIND_USER": self = .findUser
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .createUser: return "CREATE_USER"
      case .updateEmailAddress: return "UPDATE_EMAIL_ADDRESS"
      case .updatePhoneNumber: return "UPDATE_PHONE_NUMBER"
      case .releaseAccount: return "RELEASE_ACCOUNT"
      case .resetPassword: return "RESET_PASSWORD"
      case .findUser: return "FIND_USER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: AuthenticationTokenScope, rhs: AuthenticationTokenScope) -> Bool {
    switch (lhs, rhs) {
      case (.createUser, .createUser): return true
      case (.updateEmailAddress, .updateEmailAddress): return true
      case (.updatePhoneNumber, .updatePhoneNumber): return true
      case (.releaseAccount, .releaseAccount): return true
      case (.resetPassword, .resetPassword): return true
      case (.findUser, .findUser): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [AuthenticationTokenScope] {
    return [
      .createUser,
      .updateEmailAddress,
      .updatePhoneNumber,
      .releaseAccount,
      .resetPassword,
      .findUser,
    ]
  }
}

public struct ResetPasswordMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - username
  ///   - password
  ///   - token
  public init(username: String, password: String, token: String) {
    graphQLMap = ["username": username, "password": password, "token": token]
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

  public var token: String {
    get {
      return graphQLMap["token"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "token")
    }
  }
}

public struct CreateUserWithTokenMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - username
  ///   - password
  ///   - displayName
  ///   - phoneNumber
  ///   - remark
  ///   - token
  public init(username: String, password: String, displayName: Swift.Optional<String?> = nil, phoneNumber: Swift.Optional<String?> = nil, remark: Swift.Optional<String?> = nil, token: String) {
    graphQLMap = ["username": username, "password": password, "displayName": displayName, "phoneNumber": phoneNumber, "remark": remark, "token": token]
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

  public var token: String {
    get {
      return graphQLMap["token"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "token")
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

public struct CreateServiceWithServiceTemplateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - serviceTemplateId
  ///   - input
  public init(serviceTemplateId: GraphQLID, input: Swift.Optional<String?> = nil) {
    graphQLMap = ["serviceTemplateId": serviceTemplateId, "input": input]
  }

  public var serviceTemplateId: GraphQLID {
    get {
      return graphQLMap["serviceTemplateId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "serviceTemplateId")
    }
  }

  public var input: Swift.Optional<String?> {
    get {
      return graphQLMap["input"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "input")
    }
  }
}

public enum ServiceEventEnum: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case serviceCreated
  case serviceUpdated
  case serviceDeleted
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "SERVICE_CREATED": self = .serviceCreated
      case "SERVICE_UPDATED": self = .serviceUpdated
      case "SERVICE_DELETED": self = .serviceDeleted
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .serviceCreated: return "SERVICE_CREATED"
      case .serviceUpdated: return "SERVICE_UPDATED"
      case .serviceDeleted: return "SERVICE_DELETED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ServiceEventEnum, rhs: ServiceEventEnum) -> Bool {
    switch (lhs, rhs) {
      case (.serviceCreated, .serviceCreated): return true
      case (.serviceUpdated, .serviceUpdated): return true
      case (.serviceDeleted, .serviceDeleted): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ServiceEventEnum] {
    return [
      .serviceCreated,
      .serviceUpdated,
      .serviceDeleted,
    ]
  }
}

public enum UserRole: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case awaitingToJoin
  case member
  case manager
  case administrator
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "AWAITING_TO_JOIN": self = .awaitingToJoin
      case "MEMBER": self = .member
      case "MANAGER": self = .manager
      case "ADMINISTRATOR": self = .administrator
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .awaitingToJoin: return "AWAITING_TO_JOIN"
      case .member: return "MEMBER"
      case .manager: return "MANAGER"
      case .administrator: return "ADMINISTRATOR"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: UserRole, rhs: UserRole) -> Bool {
    switch (lhs, rhs) {
      case (.awaitingToJoin, .awaitingToJoin): return true
      case (.member, .member): return true
      case (.manager, .manager): return true
      case (.administrator, .administrator): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [UserRole] {
    return [
      .awaitingToJoin,
      .member,
      .manager,
      .administrator,
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "registerFcm": registerFcm])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "unregisterFcm": unregisterFcm])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "requestToJoinWorkspace": requestToJoinWorkspace])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "cancelToJoinWorkspace": cancelToJoinWorkspace])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "requestVerificationNumber": requestVerificationNumber.flatMap { (value: RequestVerificationNumber) -> ResultMap in value.resultMap }])
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
          GraphQLField("expires", type: .nonNull(.scalar(String.self))),
          GraphQLField("user", type: .object(User.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, verificationNumber: String? = nil, expires: String, user: User? = nil) {
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

      public var expires: String {
        get {
          return resultMap["expires"]! as! String
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "checkVerificationNumber": checkVerificationNumber.flatMap { (value: CheckVerificationNumber) -> ResultMap in value.resultMap }])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "resetPassword": resetPassword])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "releaseAccount": releaseAccount])
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
    mutation signUp($input: CreateUserWithTokenMutationInput!) {
      createUserWithToken(input: $input) {
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

  public var input: CreateUserWithTokenMutationInput

  public init(input: CreateUserWithTokenMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createUserWithToken", arguments: ["input": GraphQLVariable("input")], type: .object(CreateUserWithToken.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createUserWithToken: CreateUserWithToken? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createUserWithToken": createUserWithToken.flatMap { (value: CreateUserWithToken) -> ResultMap in value.resultMap }])
    }

    /// CreateUser creates new user without any previleges
    public var createUserWithToken: CreateUserWithToken? {
      get {
        return (resultMap["createUserWithToken"] as? ResultMap).flatMap { CreateUserWithToken(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createUserWithToken")
      }
    }

    public struct CreateUserWithToken: GraphQLSelectionSet {
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "validateUsername": validateUsername])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "withdrawUser": withdrawUser])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateUserEmail": updateUserEmail])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "leaveWorkspace": leaveWorkspace])
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
    public static let possibleTypes: [String] = ["Mutation"]

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
      self.init(unsafeResultMap: ["__typename": "Mutation", "createServiceWithServiceTemplate": createServiceWithServiceTemplate.flatMap { (value: CreateServiceWithServiceTemplate) -> ResultMap in value.resultMap }])
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
    public static let possibleTypes: [String] = ["Query"]

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
      self.init(unsafeResultMap: ["__typename": "Query", "isVaildAccessToken": isVaildAccessToken])
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
    public static let possibleTypes: [String] = ["Query"]

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
      self.init(unsafeResultMap: ["__typename": "Query", "findUser": findUser.flatMap { (value: FindUser) -> ResultMap in value.resultMap }])
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
    public static let possibleTypes: [String] = ["Query"]

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
      self.init(unsafeResultMap: ["__typename": "Query", "workspaces": workspaces.flatMap { (value: Workspace) -> ResultMap in value.resultMap }])
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

          public init(id: GraphQLID, name: String, code: String? = nil, createdAt: String, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, totalMemberCount: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNode", "id": id, "name": name, "code": code, "createdAt": createdAt, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "totalMemberCount": totalMemberCount])
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

            public init(id: GraphQLID, name: String, code: String? = nil, createdAt: String, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, totalMemberCount: Int? = nil) {
              self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNode", "id": id, "name": name, "code": code, "createdAt": createdAt, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "totalMemberCount": totalMemberCount])
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
    query services($workspaceId: String!, $after: String, $first: Int, $type: String, $phase: String, $phases: [String], $states: [String], $startedAt: DateTime, $endedAt: DateTime) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              services(
                after: $after
                first: $first
                type: $type
                phase: $phase
                phases: $phases
                states: $states
                startedAt: $startedAt
                endedAt: $endedAt
              ) {
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
  public var type: String?
  public var phase: String?
  public var phases: [String?]?
  public var states: [String?]?
  public var startedAt: String?
  public var endedAt: String?

  public init(workspaceId: String, after: String? = nil, first: Int? = nil, type: String? = nil, phase: String? = nil, phases: [String?]? = nil, states: [String?]? = nil, startedAt: String? = nil, endedAt: String? = nil) {
    self.workspaceId = workspaceId
    self.after = after
    self.first = first
    self.type = type
    self.phase = phase
    self.phases = phases
    self.states = states
    self.startedAt = startedAt
    self.endedAt = endedAt
  }

  public var variables: GraphQLMap? {
    return ["workspaceId": workspaceId, "after": after, "first": first, "type": type, "phase": phase, "phases": phases, "states": states, "startedAt": startedAt, "endedAt": endedAt]
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
                GraphQLField("services", arguments: ["after": GraphQLVariable("after"), "first": GraphQLVariable("first"), "type": GraphQLVariable("type"), "phase": GraphQLVariable("phase"), "phases": GraphQLVariable("phases"), "states": GraphQLVariable("states"), "startedAt": GraphQLVariable("startedAt"), "endedAt": GraphQLVariable("endedAt")], type: .object(Service.selections)),
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
    query stopList($workspaceId: String!) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              stationGroups(isStop: true) {
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

  public init(workspaceId: String) {
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
                GraphQLField("stationGroups", arguments: ["isStop": true], type: .object(StationGroup.selections)),
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

public final class UserListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query userList($workspaceId: String!) {
      signedUser {
        __typename
        joinedWorkspaces(id: $workspaceId) {
          __typename
          edges {
            __typename
            node {
              __typename
              members(roles: [MEMBER, MANAGER, ADMINISTRATOR]) {
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

  public init(workspaceId: String) {
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
                GraphQLField("members", arguments: ["roles": ["MEMBER", "MANAGER", "ADMINISTRATOR"]], type: .object(Member.selections)),
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
    public static let possibleTypes: [String] = ["Query"]

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
      self.init(unsafeResultMap: ["__typename": "Query", "clientVersion": clientVersion.flatMap { (value: ClientVersion) -> ResultMap in value.resultMap }])
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
    query serviceTemplates {
      serviceTemplates {
        __typename
        edges {
          __typename
          node {
            __typename
            id
            name
          }
        }
      }
    }
    """

  public let operationName: String = "serviceTemplates"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("serviceTemplates", type: .object(ServiceTemplate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(serviceTemplates: ServiceTemplate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "serviceTemplates": serviceTemplates.flatMap { (value: ServiceTemplate) -> ResultMap in value.resultMap }])
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
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String) {
            self.init(unsafeResultMap: ["__typename": "ServiceTemplateNode", "id": id, "name": name])
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
    subscription serviceById($id: ID!) {
      subscribeServiceByServiceId(serviceId: $id) {
        __typename
        ...ServiceFragment
      }
    }
    """

  public let operationName: String = "serviceById"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceFragment.fragmentDefinition)
    document.append("\n" + RobotFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitFragment.fragmentDefinition)
    document.append("\n" + StopFragment.fragmentDefinition)
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("subscribeServiceByServiceId", arguments: ["serviceId": GraphQLVariable("id")], type: .object(SubscribeServiceByServiceId.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(subscribeServiceByServiceId: SubscribeServiceByServiceId? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "subscribeServiceByServiceId": subscribeServiceByServiceId.flatMap { (value: SubscribeServiceByServiceId) -> ResultMap in value.resultMap }])
    }

    public var subscribeServiceByServiceId: SubscribeServiceByServiceId? {
      get {
        return (resultMap["subscribeServiceByServiceId"] as? ResultMap).flatMap { SubscribeServiceByServiceId(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "subscribeServiceByServiceId")
      }
    }

    public struct SubscribeServiceByServiceId: GraphQLSelectionSet {
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

public final class ServiceByWorkspaceIdSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription serviceByWorkspaceId($id: ID!) {
      subscribeServiceChangeset(
        workspaceId: $id
        phases: [Initialization, Executing, Done]
      ) {
        __typename
        eventType
        service {
          __typename
          ...ServiceFragment
        }
      }
    }
    """

  public let operationName: String = "serviceByWorkspaceId"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ServiceFragment.fragmentDefinition)
    document.append("\n" + RobotFragment.fragmentDefinition)
    document.append("\n" + ServiceUnitFragment.fragmentDefinition)
    document.append("\n" + StopFragment.fragmentDefinition)
    document.append("\n" + UserFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Subscription"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("subscribeServiceChangeset", arguments: ["workspaceId": GraphQLVariable("id"), "phases": ["Initialization", "Executing", "Done"]], type: .object(SubscribeServiceChangeset.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(subscribeServiceChangeset: SubscribeServiceChangeset? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "subscribeServiceChangeset": subscribeServiceChangeset.flatMap { (value: SubscribeServiceChangeset) -> ResultMap in value.resultMap }])
    }

    public var subscribeServiceChangeset: SubscribeServiceChangeset? {
      get {
        return (resultMap["subscribeServiceChangeset"] as? ResultMap).flatMap { SubscribeServiceChangeset(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "subscribeServiceChangeset")
      }
    }

    public struct SubscribeServiceChangeset: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ServiceChangeSetType"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("eventType", type: .scalar(ServiceEventEnum.self)),
          GraphQLField("service", type: .object(Service.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(eventType: ServiceEventEnum? = nil, service: Service? = nil) {
        self.init(unsafeResultMap: ["__typename": "ServiceChangeSetType", "eventType": eventType, "service": service.flatMap { (value: Service) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var eventType: ServiceEventEnum? {
        get {
          return resultMap["eventType"] as? ServiceEventEnum
        }
        set {
          resultMap.updateValue(newValue, forKey: "eventType")
        }
      }

      public var service: Service? {
        get {
          return (resultMap["service"] as? ResultMap).flatMap { Service(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "service")
        }
      }

      public struct Service: GraphQLSelectionSet {
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
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("isRequiredUserEmailToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("isRequiredUserPhoneNumberToJoin", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("totalMemberCount", type: .scalar(Int.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, code: String? = nil, createdAt: String, isRequiredUserEmailToJoin: Bool, isRequiredUserPhoneNumberToJoin: Bool, totalMemberCount: Int? = nil) {
    self.init(unsafeResultMap: ["__typename": "OnlyWorkspaceNode", "id": id, "name": name, "code": code, "createdAt": createdAt, "isRequiredUserEmailToJoin": isRequiredUserEmailToJoin, "isRequiredUserPhoneNumberToJoin": isRequiredUserPhoneNumberToJoin, "totalMemberCount": totalMemberCount])
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

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
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
      GraphQLField("timestamps", type: .scalar(String.self)),
      GraphQLField("serviceNumber", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("creator", type: .scalar(String.self)),
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

  public init(id: GraphQLID, phase: String? = nil, type: String? = nil, state: String? = nil, timestamps: String? = nil, serviceNumber: String? = nil, createdAt: String, creator: String? = nil, robot: Robot? = nil, currentServiceUnitStep: Int? = nil, serviceUnits: [ServiceUnit?]? = nil, totalMovingDistance: Double? = nil) {
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

  public var timestamps: String? {
    get {
      return resultMap["timestamps"] as? String
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
