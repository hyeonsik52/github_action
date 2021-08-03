//
//  LoggingInterceptor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo

/// 통신 요청, 완료 시 로그를 찍어줍니다.
class RequestLoggingInterceptor: ApolloInterceptor {
    
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        
        let description = "\(request.operation.operationType) \(request.operation.operationName)"
        Log.request(description)
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}

class ResponseLoggingInterceptor: ApolloInterceptor {
    
    enum ResponseLoggingError: Error {
        case notYetReceived
    }
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        defer {
            // Even if we can't log, we still want to keep going.
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
        
        guard let receivedResponse = response else {
            chain.handleErrorAsync(ResponseLoggingError.notYetReceived,
                                   request: request,
                                   response: response,
                                   completion: completion)
            return
        }
        
        Log.complete("\(request.operation.operationType) \(request.operation.operationName)")
        Log.debug("HTTP Response: \(receivedResponse.httpResponse)")
        
        if let stringData = String(bytes: receivedResponse.rawData, encoding: .utf8) {
            Log.debug("Data: \(stringData)")
        } else {
            Log.error("Could not convert data to string!")
        }
    }
}
