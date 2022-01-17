//
//  SwiftEntryKit_ViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol SwiftEntryKitViewControllerExtension: SwiftEntryKitExtension {
    var afterViewController: () -> UIViewController? { get }
}

struct SwiftEntryKitViewControllerWrapper<Base>: SwiftEntryKitViewControllerExtension {
    
    var afterViewController: () -> UIViewController?
    var entryName: String? = UUID().uuidString
    
    init(closure: @escaping () -> UIViewController?) {
        self.afterViewController = closure
    }
}

protocol SwiftEntryKitViewControllerBridge {
    associatedtype Base
    var sek: SwiftEntryKitViewControllerWrapper<Base> { get }
}

extension SwiftEntryKitViewControllerExtension {
    
    func show(with attributes: EKAttributes) {
        DispatchQueue.main.async {
            guard let viewController = self.afterViewController() else { return }
            var attributes = attributes
            attributes.name = viewController.hash.description
            SwiftEntryKit.display(entry: viewController, using: attributes)
        }
    }
}

extension UIViewController: SwiftEntryKitViewControllerBridge {
    
    var sek: SwiftEntryKitViewControllerWrapper<UIViewController> {
        return .init { [weak self] in self }
    }
}
