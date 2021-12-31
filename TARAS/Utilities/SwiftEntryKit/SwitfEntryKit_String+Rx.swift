//
//  SwitfEntryKit_String+Rx.swift
//  GRaaSS
//
//  Created by nexmond on 2021/12/01.
//

import RxSwift

final class Toaster: ReactiveCompatible {}

extension Reactive where Base: Toaster {
    
    static func showToast(color: UIColor = .purple4A3C9F) -> Binder<String> {
        return Binder(Base()) { _, value in
            value.sek.showToast(color: color)
        }
    }
}
