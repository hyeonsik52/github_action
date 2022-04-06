//
//  UINavigationController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/20.
//

import UIKit

extension UINavigationController {
    
    func removeViewControllerInStack<T: UIViewController>(_ vcType: T.Type) {
        var viewControllers = self.viewControllers
        viewControllers.removeAll(where: { type(of: $0) == vcType })
        self.viewControllers = viewControllers
    }
    
    func removeViewControllersInStack(_ vcTypes: [AnyClass])  {
        var viewControllers = self.viewControllers
        vcTypes.forEach { vcType in
            viewControllers.removeAll(where: { type(of: $0) == vcType })
        }
        self.viewControllers = viewControllers
    }
    
    func popToViewController<T: UIViewController>(_ viewControllerType: T.Type, animated: Bool = true) {
        if let finded = self.viewControllers.last(where: { type(of: $0) == viewControllerType }) {
            self.popToViewController(finded, animated: animated)
        }
    }
    
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
