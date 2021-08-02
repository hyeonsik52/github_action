//
//  BaseNavigationController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/25.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, hideBottom: Bool = false) {
        if hideBottom { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }
    
    @discardableResult
    func popViewController(animated: Bool, visibleBottom: Bool = false) -> UIViewController? {
        if visibleBottom { self.viewControllers.dropLast().last?.hidesBottomBarWhenPushed = false }
        return super.popViewController(animated: animated)
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool, visibleBottom: Bool = false) -> [UIViewController]? {
        if visibleBottom { self.viewControllers.first?.hidesBottomBarWhenPushed = false }
        return super.popToRootViewController(animated: animated)
    }
    
    @discardableResult
    func popToViewController(_ viewController: UIViewController, animated: Bool, visibleBottom: Bool = false) -> [UIViewController]? {
        if visibleBottom { viewController.hidesBottomBarWhenPushed = false }
        return super.popToViewController(viewController, animated: animated)
    }
}
