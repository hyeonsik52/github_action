//
//  MockGraphQL.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/22.
//

import Foundation
import Apollo

final class MockGraphQLQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query mockGraphQL {
      mockCheck
    }
    """

  public let operationName: String = "mockGraphQL"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["query_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("mockCheck", type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(mockCheck: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "query_root", "mockCheck": mockCheck])
    }

    public var mockCheck: Bool? {
      get {
        return resultMap["mockCheck"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "mockCheck")
      }
    }
  }
}

struct MockGraphQLMutationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - value
  public init(value: String) {
    graphQLMap = ["value": value]
  }

  public var value: String {
    get {
      return graphQLMap["value"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "value")
    }
  }
}

final class MockGraphQLMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation mockGraphQL($input: MockGraphQLMutationInput!) {
      mockCheck(input: $input)
    }
    """

  public let operationName: String = "mockGraphQL"

  public var input: MockGraphQLMutationInput

  public init(input: MockGraphQLMutationInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["mutation_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("mockCheck", arguments: ["input": GraphQLVariable("input")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(mockCheck: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "mockCheck": mockCheck])
    }

    public var mockCheck: Bool? {
      get {
        return resultMap["mockCheck"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "mockCheck")
      }
    }
  }
}

final class MockGraphQLSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription mockGraphQL($id: String!) {
      mockCheck(where: {id: {_eq: $id}}) {
        __typename
      }
    }
    """

  public let operationName: String = "mockGraphQL"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["subscription_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("mockCheck", arguments: ["where": ["id": ["_eq": GraphQLVariable("id")]]], type: .nonNull(.list(.nonNull(.object(MockCheck.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(mockCheck: [MockCheck]) {
      self.init(unsafeResultMap: ["__typename": "subscription_root", "mockCheck": mockCheck.map { (value: MockCheck) -> ResultMap in value.resultMap }])
    }

    /// fetch data from the table: "-"
    public var mockCheck: [MockCheck] {
      get {
        return (resultMap["mockCheck"] as! [ResultMap]).map { (value: ResultMap) -> MockCheck in MockCheck(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: MockCheck) -> ResultMap in value.resultMap }, forKey: "mockCheck")
      }
    }

    public struct MockCheck: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["mockCheck"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self)))
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
    }
  }
}
