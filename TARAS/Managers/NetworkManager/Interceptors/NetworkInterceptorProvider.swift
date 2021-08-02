//
//  NetworkInterceptorProvider.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo

class NetworkInterceptorProvider: InterceptorProvider {
    
    private let store: ApolloStore
    private let client: URLSessionClient
    private let provider: ManagerProviderType!
    private var interceptorBlock: InterceptorsBlock?
    
    init(
        store: ApolloStore,
        client: URLSessionClient,
        provider: ManagerProviderType,
        interceptors: InterceptorsBlock? = nil
    ) {
        self.store = store
        self.client = client
        self.provider = provider
        self.interceptorBlock = interceptors
    }
    
    func interceptors<Operation: GraphQLOperation>(
        for operation: Operation
    ) -> [ApolloInterceptor] {
        if let interceptorBlock = self.interceptorBlock {
            return interceptorBlock(self.store, self.client, self.provider)
        }else{
            return [
                MaxRetryInterceptor(),
                
                CacheReadInterceptor(store: self.store),
                TokenAddingInterceptor(provider: self.provider),
                RequestLoggingInterceptor(),
                NetworkFetchInterceptor(client: self.client),
                ResponseLoggingInterceptor(),
                ResponseCodeInterceptor(),
                JSONResponseParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
                AutomaticPersistedQueryInterceptor(),
                CacheWriteInterceptor(store: self.store)
            ]
        }
    }
    
    func additionalErrorInterceptor<Operation>(
        for operation: Operation
    ) -> ApolloErrorInterceptor? where Operation : GraphQLOperation {
        return ErrorInterceptor(provider: self.provider)
    }
}
