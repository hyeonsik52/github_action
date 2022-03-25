//
//  NetworkManager_ClientVersion.swift
//  TARAS
//
//  Created by nexmond on 2022/03/24.
//

import Foundation
import RxSwift

protocol ClientVersionSupport {
    func version() -> Observable<Result<Version, Error>>
    func updateCheck() -> Observable<Error?>
    func check() -> Observable<Version?>
}

extension NetworkManager: ClientVersionSupport {
    
    func version() -> Observable<Result<Version, Error>> {
        return self.fetch(ClientVersionQuery())
            .map { payload in
                let error = NSError(
                    domain: "TARAS",
                    code: -99,
                    userInfo: [
                        NSLocalizedDescriptionKey: "버전 정보를 가져오지 못햇습니다."
                    ]
                )
                if let fragment = payload.clientVersion?.fragments.versionFragment {
                    let model = Version(fragment)
                    if model.mustUpdate {
                        let error = NSError(
                            domain: "TARAS",
                            code: -99,
                            userInfo: [
                                NSLocalizedFailureErrorKey: "업데이트",
                                NSLocalizedDescriptionKey: "안정적인 앱 사용을 위해\n업데이트를 진행해주세요.",
                                NSLocalizedRecoverySuggestionErrorKey: "업데이트"
                            ]
                        )
                        return .failure(error)
                    } else {
                        return .success(model)
                    }
                } else {
                    return .failure(error)
                }
            }.catch { error in
                return .just(.failure(error))
            }.observe(on: MainScheduler.instance)
    }
    
    func updateCheck() -> Observable<Error?> {
        return self.version().map {
            if case .failure(let error) = $0 {
                return error
            } else {
                return nil
            }
        }
    }
    
    func check() -> Observable<Version?> {
        return self.version().map { try? $0.get() }
    }
}

extension NetworkManagerType {
    
    var clientVersion: ClientVersionSupport {
        guard let converted = self as? ClientVersionSupport else {
            return ClientVersionSupportDefault()
        }
        return converted
    }
}

struct ClientVersionSupportDefault: ClientVersionSupport {
    
    func version() -> Observable<Result<Version, Error>> {
        return .just(.success(.thisAppVersion))
    }
    
    func updateCheck() -> Observable<Error?> {
        return self.version().map {
            if case .failure(let error) = $0 {
                return error
            } else {
                return nil
            }
        }
    }
    
    func check() -> Observable<Version?> {
        return self.version().map { try? $0.get() }
    }
}
