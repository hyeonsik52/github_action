//
//  ErrorInterceptor.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Apollo

class ErrorInterceptor: BaseErrorInterceptor {
    
    private func addTokenAndProceed<Operation: GraphQLOperation>(
        _ token: String,
        to request: HTTPRequest<Operation>,
        chain: RequestChain,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        let authPayload = self.provider.userManager.authPayload()
        let authKey = authPayload.keys.first!
        request.additionalHeaders[authKey] = authPayload[authKey]
        chain.proceedAsync(request: request, response: response, completion: completion)
    }

    override func handleErrorAsync<Operation>(
        error: Error,
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        
        if response?.httpResponse.statusCode == 401 {
            
//            let authKey = self.provider.userManager.authPayload().keys.first!
//
//            let accessToken = request
//                .additionalHeaders[authKey]?
//                .components(separatedBy: .whitespaces)
//                .last ?? ""
//
//            self.provider.userManager.reAuthenticate(accessToken) { error in
//                if let _ = error {
                    self.goBackToSignIn()
//                } else {
//                    chain.retry(request: request, completion: completion)
//                }
//            }
        } else {
            completion(.failure(error))
        }
    }
    
    fileprivate func goBackToSignIn() {
        // 로컬 DB 초기화
        self.provider.userManager.initializeUserTB()

        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            if let window = window {
                self.forceSignOutAlert(window)
            }
        }
    }

    fileprivate func forceSignOutAlert(_ window: UIWindow) {
        let alert = UIAlertController(
            title: "세션 만료로\n로그아웃되었습니다.",
            message: nil,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "재로그인하러 가기", style: .default) { _ in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let viewController = SignInViewController()
//            viewController.reactor = SignInViewReactor(provider: appDelegate.provider)
//            let navigationController = BaseNavigationController(rootViewController: viewController)
//            window.rootViewController = navigationController
        }
        alert.addAction(action)
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
