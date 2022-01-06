//
//  UIViewController+PushAndPop.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/30.
//

import UIKit
import ReactorKit

extension UIViewController {
    
    func navigationPush(
        _ viewController: UIViewController,
        animated: Bool,
        bottomBarHidden: Bool = false
    ) {
        self.hidesBottomBarWhenPushed = bottomBarHidden
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func navigationPush<T: View & UIViewController>(
        type ViewController: T.Type,
        reactor: T.Reactor,
        animated: Bool,
        bottomBarHidden: Bool = false
    ) {
        let viewController = ViewController.init()
        viewController.reactor = reactor
        self.navigationPush(viewController, animated: animated, bottomBarHidden: bottomBarHidden)
    }
    
    func navigationPop(
        to: UIViewController.Type? = nil,
        animated: Bool,
        bottomBarHidden: Bool = false
    ) {
        if let to = to,
           let viewControllers = self.navigationController?.viewControllers,
           let destination = viewControllers.last(where: { type(of: $0) == to }) {
            destination.hidesBottomBarWhenPushed = bottomBarHidden
            self.navigationController?.popToViewController(destination, animated: animated)
        } else {
            self.navigationController?.viewControllers.dropLast().last?.hidesBottomBarWhenPushed = bottomBarHidden
            self.navigationController?.popViewController(animated: animated)
        }
    }
}
