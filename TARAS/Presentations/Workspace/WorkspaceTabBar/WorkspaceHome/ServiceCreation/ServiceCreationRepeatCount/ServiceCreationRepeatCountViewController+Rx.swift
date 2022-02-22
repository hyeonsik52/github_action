//
//  ServiceCreationRepeatCountViewController+Rx.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/14.
//

import UIKit
import ReactorKit
import RxSwift

extension ServiceCreationRepeatCountViewController {
    
    static let ViewID = "ServiceCreationRepeatCountViewController"
    
    static func count(value: Int) -> Observable<Int> {
        return .create { observer in
            
            let viewController = ServiceCreationRepeatCountViewController(value: value)
            var wrapper = viewController.sek
            wrapper.entryName = self.ViewID
            wrapper.showBottomSheet()
            
            let disappear = viewController.rx.viewDidDisappear
                .map {_ in () }
                .subscribe(onNext: observer.onCompleted)
            let confirm = viewController.confirmButton.rx.tap
                .subscribe(onNext: {
                    observer.onNext(viewController.value)
                    wrapper.dismiss {
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create(disappear, confirm)
        }
    }
}
