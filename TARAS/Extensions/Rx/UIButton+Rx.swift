//
//  UIButton+Rx.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/14.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {

    var throttleTap: Observable<Void> {
        return throttleTap()
    }
    
    func throttleTap(_ dueTime: RxSwift.RxTimeInterval = .seconds(1)) -> Observable<Void> {
        return controlEvent(.touchUpInside)
            .throttle(dueTime, scheduler: MainScheduler.instance)
    }
}
