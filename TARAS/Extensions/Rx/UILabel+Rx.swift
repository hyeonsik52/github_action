//
//  UILabel+Rx.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/27.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    
    public var textColor: Binder<UIColor> {
        return Binder(self.base) { label, textColor in
            label.textColor = textColor
        }
    }
}
