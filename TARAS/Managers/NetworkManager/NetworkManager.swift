//
//  NetworkManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo
import RxSwift

typealias InterceptorsBlock = (_ store: ApolloStore, _ client: URLSessionClient, _ provider: ManagerProviderType) -> [ApolloInterceptor]

struct MultipleError: Error {
    let graphQLErrors: [GraphQLError]?
}

protocol NetworkManagerType: AnyObject {
    func fetch<T: GraphQLQuery>(_ query: T) -> Observable<T.Data>
    func perform<T: GraphQLMutation>(_ mutation: T) -> Observable<T.Data>
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>>
    func updateWebSocketTransportConnectingPayload()
}

class NetworkManager: BaseManager, NetworkManagerType {
    
    private static let endpointURL = Info.serverEndpoint
    
    /// A web socket transport to use for subscriptions
    private(set) var webSocketTransport: WebSocketTransport!
    
    /// Create a client using the `SplitNetworkTransport`.
    private(set) var apollo: ApolloClient!
    
    override init(provider: ManagerProviderType) {
        super.init(provider: provider)
        self.configure(provider: provider)
    }
    
    convenience init(
        provider: ManagerProviderType,
        store: ApolloStore = ApolloStore(),
        client: URLSessionClient = URLSessionClient(),
        endPointURL strUrl: String = endpointURL,
        interceptors: InterceptorsBlock? = nil
    ) {
        self.init(provider: provider)
        self.configure(
            provider: provider,
            store: store,
            client: client,
            endPointURL: strUrl,
            interceptors: interceptors
        )
    }
    
    private func configure(
        provider: ManagerProviderType,
        store: ApolloStore = ApolloStore(),
        client: URLSessionClient = URLSessionClient(),
        endPointURL strUrl: String = endpointURL,
        interceptors: InterceptorsBlock? = nil
    ) {
        let endpointURL = URL(string: strUrl)!
        
        /// A web socket transport to use for subscriptions
        let request = URLRequest(url: endpointURL)
        let authPayload = provider.userManager.authPayload()
        let websocket = DefaultWebSocket(request: request)
        let webSocketTransport = WebSocketTransport(websocket: websocket, reconnectionInterval: 1, connectingPayload: authPayload)
        webSocketTransport.delegate = self
        self.webSocketTransport = webSocketTransport

        /// An HTTP transport to use for queries and mutations.
        let normalTransport: RequestChainNetworkTransport = {
            let interceptorProvider = NetworkInterceptorProvider(store: store, client: client, provider: provider, interceptors: interceptors)
            return RequestChainNetworkTransport(
                interceptorProvider: interceptorProvider,
                endpointURL: endpointURL
            )
        }()

        /// A split network transport to allow the use of both of the above
        /// transports through a single `NetworkTransport` instance.
        let splitNetworkTransport = SplitNetworkTransport(
            uploadingNetworkTransport: normalTransport,
            webSocketNetworkTransport: webSocketTransport
        )
        
        /// Create a client using the `SplitNetworkTransport`.
        self.apollo = ApolloClient(
            networkTransport: splitNetworkTransport,
            store: store
        )
    }
}


extension NetworkManager {

    func fetch<T: GraphQLQuery>(_ query: T) -> Observable<T.Data> {
        
        return Observable.create { [weak self] observer -> Disposable in
            let cancellable = self?.apollo.fetch(
                query: query,
                cachePolicy: .fetchIgnoringCacheData,
                queue: DispatchQueue.global(qos: .userInteractive)
            ) { result in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        observer.onNext(data)
                        observer.onCompleted()
                    } else if let errors = graphQLResult.errors {
                        Log.error("\(query.operationType) \(query.operationName):\n👉 GraphQL errors: \(errors)")
                        let error = MultipleError(graphQLErrors: errors)
                        observer.onError(error)
                    }
                    
                case .failure(let error):
                    Log.fail("\(query.operationType) \(query.operationName):\n👉 Network or response format error: \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
    
    func perform<T: GraphQLMutation>(_ mutation: T) -> Observable<T.Data> {
        
        return .create { [weak self] observer -> Disposable in
            let cancellable = self?.apollo.perform(
                mutation: mutation,
                queue: DispatchQueue.global(qos: .userInteractive)
            ) { result in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        observer.onNext(data)
                        observer.onCompleted()
                    } else if let errors = graphQLResult.errors {
                        Log.error("\(mutation.operationType) \(mutation.operationName):\n👉 GraphQL errors: \(errors)")
                        let error = MultipleError(graphQLErrors: errors)
                        observer.onError(error)
                    }

                case .failure(let error):
                    Log.fail("\(mutation.operationType) \(mutation.operationName):\n👉 Network or response format error: \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
    
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>> {
        let logPrefix = "🔗 \(subscription.operationType) \(subscription.operationName)"
        Log.request(logPrefix)
        
        return .create { [weak self] observer -> Disposable in
            let cancellable = self?.apollo.subscribe(
                subscription: subscription,
                queue: DispatchQueue.global(qos: .userInteractive)
            ) { result in
                
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        Log.complete(logPrefix)
                        observer.onNext(.success(data))
                    } else if let errors = graphQLResult.errors {
                        Log.error("\(logPrefix):\n👉 GraphQL errors: \(errors)")
                        let error = MultipleError(graphQLErrors: errors)
                        observer.onNext(.failure(error))
                    }
                case .failure(let error):
                    Log.error("\(logPrefix):\n👉 Network or response format error: \(error)")
                    observer.onNext(.failure(error))
                }
            }
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
    
    ///로그인 직후, 세션 갱신 후에 호출되어 웹소켓을 연결 정보를 업데이트 한다.
    ///updateConnectingPayload 호출 시 웹소켓은 자동으로 재연결 됨
    func updateWebSocketTransportConnectingPayload() {
        Log.debug("💡 \(#function)")
        let authPayload = self.provider.userManager.authPayload()
        self.webSocketTransport.updateConnectingPayload(authPayload)
    }
}

extension NetworkManager: WebSocketTransportDelegate {
    
    func webSocketTransportDidConnect(_ webSocketTransport: WebSocketTransport) {
        Log.debug("💡 \(#function)")
    }
    
    func webSocketTransportDidReconnect(_ webSocketTransport: WebSocketTransport) {
        Log.debug("💡 \(#function)")
    }
    
    func webSocketTransport(_ webSocketTransport: WebSocketTransport, didDisconnectWithError error: Error?) {
        Log.debug("💡 \(#function) | \(error?.localizedDescription ?? "unknowed error")")
    }
}
