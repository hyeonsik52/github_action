//
//  SwiftEntryKit_View.swift
//  Dev-ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol SwiftEntryKitViewExtension: SwiftEntryKitExtension {
    var afterView: () -> UIView? { get }
}

struct SwiftEntryKitViewWrapper<Base>: SwiftEntryKitViewExtension {
    
    var afterView: () -> UIView?
    var entryName: String?
    
    init(closure: @escaping () -> UIView?) {
        self.afterView = closure
    }
}

protocol SwiftEntryKitViewBridge {
    associatedtype Base
    var sek: SwiftEntryKitViewWrapper<Base> { get }
}

extension SwiftEntryKitViewExtension {
    
    func show(with attributes: EKAttributes) {
        DispatchQueue.main.async {
            guard let view = self.afterView() else { return }
            var attributes = attributes
            attributes.name = view.hash.description
            SwiftEntryKit.display(entry: view, using: attributes)
        }
    }
}

extension UIView: SwiftEntryKitViewBridge {
    
    var sek: SwiftEntryKitViewWrapper<UIView> {
        return .init { [weak self] in self }
    }
}
