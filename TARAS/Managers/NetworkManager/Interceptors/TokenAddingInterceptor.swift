//
//  TokenAddingInterceptor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo

/// 헤더에 토큰을 추가합니다.
class TokenAddingInterceptor: BaseInterceptor {

    override func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        
        let authPayload = self.provider.userManager.authPayload()
        let authKey = authPayload.keys.first!
        request.additionalHeaders[authKey] = authPayload[authKey]
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}
