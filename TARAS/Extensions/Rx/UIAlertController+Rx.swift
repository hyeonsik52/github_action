//
//  UIAlertController+Rx.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/27.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import RxSwift

extension UIAlertController {
    
    struct AlertAction {
        var title: String?
        var style: UIAlertAction.Style
        
        static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
            return AlertAction(title: title, style: style)
        }
    }
    
    static func present(
        in viewController: UIViewController?,
        title: String?,
        message: String? = nil,
        attributedMessage: NSAttributedString? = nil,
        style: UIAlertController.Style,
        actions: [AlertAction])
        -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            if let attributed = attributedMessage {
                alertController.setValue(attributed, forKey: "attributedMessage")
            }
            
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            
            viewController?.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
    
    static func show(
        _ style: Style = .alert,
        title: String? = nil,
        message: String? = nil,
        items: [String],
        usingCancel: Bool = true
    ) -> Observable<(Int, String?)> {
        return self.show(
            style,
            title: title,
            message: message,
            items: items.map { AlertAction(title: $0, style: .default) },
            usingCancel: usingCancel
        )
    }
    
    static let alertWindow: UIWindow = {
        var newWindow: UIWindow!
        if #available(iOS 13.0, *),
           let scene = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).first as? UIWindowScene {
            newWindow = .init(windowScene: scene)
        } else {
            newWindow = .init(frame: UIScreen.main.bounds)
        }
        newWindow.backgroundColor = .clear
        newWindow.rootViewController = UIViewController()
        newWindow.accessibilityViewIsModal = true
        return newWindow
    }()
    
    static func show(
        _ style: Style = .alert,
        title: String? = nil,
        message: String? = nil,
        items: [AlertAction],
        usingCancel: Bool = true,
        onGlobal: Bool = false
    ) -> Observable<(Int, String?)> {
        return .create { observer in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            items.enumerated().forEach { (offset, item) in
                alertController.addAction(.init(title: item.title, style: item.style) { _ in
                    observer.onNext((offset, item.title))
                    observer.onCompleted()
                })
            }
            if usingCancel {
                alertController.addAction(.init(title: "취소", style: .cancel))
            }
            
            let mainWindow = UIApplication.shared.keyWindow
            var alertWindow: UIWindow?
            var viewController: UIViewController?
            
            if onGlobal {
                
                alertWindow = self.alertWindow
                viewController = alertWindow?.rootViewController
                alertWindow?.makeKeyAndVisible()
                
            } else {
                
                viewController = UIApplication.topViewController
            }
            
            viewController?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true) {
                    mainWindow?.makeKeyAndVisible()
                }
            }
        }
    }
    
    static func show<T: Describable>(
        _ style: Style = .alert,
        title: String? = nil,
        message: String? = nil,
        items: [T],
        withCancel: Bool = true
    ) -> Observable<(Int, T)> {
        return .create { observer in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            items.enumerated().forEach { (offset, item) in
                alertController.addAction(.init(title: item.description, style: .default) { _ in
                    observer.onNext((offset, item))
                    observer.onCompleted()
                })
            }
            if withCancel {
                alertController.addAction(.init(title: "취소", style: .cancel))
            }
            
            if let viewController = UIApplication.topViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
    }
}
