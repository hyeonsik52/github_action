//
//  ServiceDetailStopViewController+Rx.swift
//  TARAS
//
//  Created by nexmond on 2022/02/15.
//

import UIKit
import ReactorKit
import RxSwift

extension ServiceDetailStopViewController {
    
    static let ViewID = "ServiceDetailStopViewController"
    
    static func show(with reactor: ServiceDetailServiceUnitCellReactor) -> Observable<Void> {
        return .create { observer in
            
            let viewController = ServiceDetailStopViewController()
            viewController.reactor = reactor
            
            var wrapper = viewController.sek
            wrapper.entryName = self.ViewID
            wrapper.showBottomSheet()
            
            let disappear = viewController.rx.viewDidDisappear
                .map {_ in () }
                .subscribe(onNext: observer.onCompleted)
            let close = viewController.closeButton.rx.tap
                .subscribe(onNext: {
                    observer.onNext(())
                    wrapper.dismiss {
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create(disappear, close)
        }
    }
}
