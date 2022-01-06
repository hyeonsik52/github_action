//
//  UIView+Search.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/30.
//

import UIKit

extension UIView {
    
    func recursiveSearch<T: UIView>() -> T? {
        let subviews = self.subviews
        for subview in subviews {
            if let casted = subview as? T {
                return casted
            } else if let searched: T = subview.recursiveSearch() {
                return searched
            }
        }
        return nil
    }
}
