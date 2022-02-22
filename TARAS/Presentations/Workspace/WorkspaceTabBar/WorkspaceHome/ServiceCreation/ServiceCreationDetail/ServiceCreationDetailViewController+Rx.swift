//
//  ServiceCreationDetailViewController+Rx.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/03.
//

import UIKit
import ReactorKit
import RxSwift

extension View where Self: ServiceCreationDetailViewController {
    
    static func update(on: UIViewController?, reactor: Reactor) -> Observable<ServiceUnitCreationModel> {
        guard let parent = on else { return .empty() }
        return .create { observer in
            
            let viewController = ServiceCreationDetailViewController()
            viewController.reactor = reactor
            parent.navigationPush(viewController, animated: true, bottomBarHidden: true)
            
            let back = viewController.backButton.rx.tap.subscribe(onNext: observer.onCompleted)
            let confirm = reactor.state.map(\.isConfirmed)
                .distinctUntilChanged()
                .filter { $0 == true }
                .subscribe(onNext: { _ in
                    observer.onNext(reactor.serviceUnit)
                    viewController.navigationPop(animated: true)
                    observer.onCompleted()
                })
            
            return Disposables.create(back, confirm)
        }
    }
}
