//
//  NetworkManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo
import RxSwift
import FirebaseFirestore
import Foundation
import Alamofire
import RxAlamofire

typealias InterceptorsBlock = (_ store: ApolloStore, _ client: URLSessionClient, _ provider: ManagerProviderType) -> [ApolloInterceptor]

struct MultipleError: Error {
    let graphQLErrors: [GraphQLError]?
}

protocol NetworkManagerType: AnyObject {
    func fetch<T: GraphQLQuery>(_ query: T) -> Observable<T.Data>
    func perform<T: GraphQLMutation>(_ mutation: T) -> Observable<T.Data>
    func subscribe<T: GraphQLSubscription>(_ subscription: T) -> Observable<Result<T.Data, Error>>
    func updateWebSocketTransportConnectingPayload()
    
    func postByRest<T: RestAPIResponse>(_ api: RestAPIType<T>) -> Observable<Result<T, RestError>>
    
    func tempVersionCheck() -> Observable<Error?>
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
    
    //Temp
    func tempVersionCheck() -> Observable<Error?> {
        let thisVersionCode = Int(UIApplication.buildNumber ?? "1") ?? 1
//            let thisVersionName = UIApplication.version ?? "0.0.1"
        return .create { observer in
            Firestore.firestore().collection("version")
                .document("ap-ios").getDocument { snapshot, error in
                    let error = NSError(
                        domain: "TARAS",
                        code: -99,
                        userInfo: [
                            NSLocalizedDescriptionKey: "버전 정보를 가져오지 못햇습니다."
                        ]
                    )
                    if let json = snapshot?.data() {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: json)
                            let model = try JSONDecoder().decode(VersionCheck.self, from: data)
                            
                            if thisVersionCode >= model.minVersionCode {
                                observer.onNext(nil)
                            } else {
                                let error = NSError(
                                    domain: "TARAS",
                                    code: -99,
                                    userInfo: [
                                        NSLocalizedFailureErrorKey: "업데이트",
                                        NSLocalizedDescriptionKey: "안정적인 앱 사용을 위해\n업데이트를 진행해주세요.",
                                        NSLocalizedRecoverySuggestionErrorKey: "업데이트"
                                    ]
                                )
                                observer.onNext(error)
                            }
                        } catch {
                            observer.onNext(error)
                        }
                    } else {
                        observer.onNext(error)
                    }
                }
            return Disposables.create()
        }
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

struct RestError: Error {
    var code: String
    var description: String
}

extension NetworkManager {
    
    func postByRest<T: RestAPIResponse>(_ api: RestAPIType<T>) -> Observable<Result<T, RestError>> {
        var parameters = api.parameters
        parameters["client_id"] = "5xUj00F1dgLNkDkOMuXcaH2tEMtTyhyCu7DxQ3jG"
        parameters["client_secret"] = "Q3IukgHRXdY8w1QzlTCaxkbQdrCHiGtdYYSQNnSJQ01fuNvXyeeN8cO8jpPwhLpt362EQAcIZSMaCFEsldMwAronfZt8wPNMv2jeHS6yo5fXw4o9XJLfgGWzZIFWkOQ9"
        Log.request("\(api) \(parameters)")
        return Session.default.rx
            .request(
                .post,
                api.url,
                parameters: parameters,
                headers: .init([
                    .contentType("application/x-www-form-urlencoded")
                ])
            ).responseData()
            .map {
                do {
                    let responseModel = try JSONDecoder().decode(T.self, from: $0.1)
                    return .success(responseModel)
                } catch let error {
                    if let errorModel = try? JSONDecoder().decode(ErrorResponseModel.self, from: $0.1) {
                        Log.err("\(errorModel)")
                        return .failure(errorModel.toRestError)
                    } else {
                        Log.fail("JSON serialization error \(error.localizedDescription)")
                        return .failure(.init(
                            code: "JSON serialization error",
                            description: error.localizedDescription
                        ))
                    }
                }
            }
    }
}
