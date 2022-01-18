//
//  SwitfEntryKit_String+Rx.swift
//  GRaaSS
//
//  Created by nexmond on 2021/12/01.
//

import RxSwift

final class Toaster: ReactiveCompatible {
    static let instance = Toaster()
    
    func showToast(_ text: String, color: UIColor = .purple4A3C9F) {
        text.sek.showToast(color: color)
    }
}

extension Reactive where Base: Toaster {
    
    static func showToast(color: UIColor = .purple4A3C9F) -> Binder<String> {
        return Binder(Base.instance) { toaster, value in
            toaster.showToast(value, color: color)
        }
    }
}
