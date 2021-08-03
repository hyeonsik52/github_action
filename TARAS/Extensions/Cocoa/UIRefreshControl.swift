//
//  UIRefreshControl.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/19.
//

import UIKit

extension UIRefreshControl {
    
    func manualyBeginRefreshing() {
        if let scrollView = superview as? UIScrollView {
            let offset = CGPoint(x: 0, y: -frame.size.height)
            scrollView.setContentOffset(offset, animated: true)
        }
        self.beginRefreshing()
        self.sendActions(for: .valueChanged)
    }
}
