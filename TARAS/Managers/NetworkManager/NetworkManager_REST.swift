//
//  NetworkManager_REST.swift
//  TARAS
//
//  Created by nexmond on 2022/03/24.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

protocol RESTSupport {
    func rest(_ method: String, _ api: RestAPI) -> Observable<(HTTPURLResponse, Data)>
}

extension NetworkManager {
    
    func rest(
        _ method: String,
        _ api: RestAPI
    ) -> Observable<(HTTPURLResponse, Data)> {
        var parameters = api.parameters
        parameters["client_id"] = Info.serverRestClientId
        parameters["client_secret"] = Info.serverRestClientSecret
        Log.request("\(api) \(parameters)")
        return Session.default.rx
            .request(
                .init(rawValue: method),
                api.url,
                parameters: parameters,
                headers: .init([
                    .contentType("application/x-www-form-urlencoded")
                ])
            ).responseData()
    }
}

extension NetworkManagerType {
    
    func rest<T: RestAPIRequest>(
        _ request: SessionAPI<T>
    ) -> Observable<Result<T.Response, RestError>> {
        return self.rest(HTTPMethod.post.rawValue, request).as().response(T.Response.self)
    }
}

struct WithDataError: Error {
    var data: Data
    var error: Error
}

extension ObservableType {

    func `as`<T: Codable>() -> Observable<Result<T, WithDataError>>
    where Element == (HTTPURLResponse, Data) {
        return self.map {
            do {
                let decoded = try JSONDecoder().decode(T.self, from: $0.1)
                return .success(decoded)
            } catch let error {
                return .failure(.init(data: $0.1, error: error))
            }
        }
    }
}

extension ObservableType {
    
    func response<T: RestAPIResponse>(_ type: T.Type) -> Observable<Result<T, RestError>>
    where Element == Result<T, WithDataError> {
        return self.map { result in
            switch result {
            case .success(let success):
                return .success(success)
            case .failure(let failure):
                if let errorModel = try? JSONDecoder().decode(ErrorResponseModel.self, from: failure.data) {
                    let error = errorModel.toRestError
                    Log.fail(error.logDescription)
                    return .failure(error)
                } else {
                    let error = RestError(
                        code: "JSON serialization error",
                        description: failure.error.localizedDescription
                    )
                    Log.fail(error.logDescription)
                    return .failure(error)
                }
            }
        }
    }
}
