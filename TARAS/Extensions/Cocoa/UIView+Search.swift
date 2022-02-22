//
//  UIView+Search.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/30.
//

import UIKit

extension UIView {
    
    func recursiveSearch<T: UIView>(where closure: ((UIView) -> Bool)? = nil) -> T? {
        let subviews = self.subviews
        for subview in subviews {
            if let casted = subview as? T {
                if let closure = closure {
                    if closure(casted) {
                        return casted
                    } else if let searched: T = subview.recursiveSearch(where: closure) {
                        return searched
                    }
                } else {
                    return casted
                }
            } else if let searched: T = subview.recursiveSearch(where: closure) {
                return searched
            }
        }
        return nil
    }
}
