//
//  ServiceCreationSelectStopViewController+Rx.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/03.
//

import UIKit
import ReactorKit
import RxSwift

extension View where Self: ServiceCreationSelectStopViewController {
    
    static func select(on: UIViewController?, reactor: Reactor) -> Observable<ServiceUnitTargetModel> {
        guard let parent = on else { return .empty() }
        return .create { observer in
            
            let viewController = ServiceCreationSelectStopViewController()
            viewController.reactor = reactor
            parent.navigationPush(viewController, animated: true, bottomBarHidden: true)
            
            let disappear = viewController.rx.viewDidDisappear
                .map {_ in () }
                .subscribe(onNext: observer.onCompleted)
            
            let confirm = viewController.selected
                .subscribe(onNext: { stop in
                    observer.onNext(stop)
                    viewController.navigationPop(animated: true)
                    observer.onCompleted()
                })
            
            return Disposables.create(disappear, confirm)
        }
    }
}
