//
//  PushManager.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/24.
//

import UIKit
import RxSwift

protocol PushManagerType: AnyObject {
    var window: UIWindow? { get }
    func setupTabBarController(_ info: NotificationInfo)
}

final class PushManager: BaseManager, PushManagerType {
    
    var window: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
    var disposeBag = DisposeBag()

    func setupTabBarController(_ info: NotificationInfo) {
        
        guard let topViewController = self.window?.topViewController() else { return }
        
        //TODO: 최소 버전 확인 로직
        Observable.just(true)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                guard let self = self, let _ = self.window else { return }
                if isValid {
                    switch info.notificationType {
                    case .serviceStarted, .waitingWorkCompleted, .serviceEnded, .default:
                        self.setupWorkspaceListViewController(pushInfo: info)
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
    enum TabType: Int {
        case serviceRequest
        case myService
        case more
    }
    
    fileprivate func setupWorkspaceListViewController(pushInfo: NotificationInfo) {
        
        let isLogin = (self.provider.userManager.userTB.accessToken != nil)

        let viewController: UIViewController = {
            if isLogin {
                return WorkspaceListViewController().then {
                    $0.reactor = WorkspaceListViewReactor(provider: self.provider, isFrom: .push)
                }
            }else{
                return SignInViewController().then {
                    $0.reactor = SignInViewReactor(provider: self.provider)
                }
            }
        }()

        let navigationController = BaseNavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigationController
    }
}

