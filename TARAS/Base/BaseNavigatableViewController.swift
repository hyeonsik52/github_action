//
//  BaseNavigatableViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa

/// 네비 용 'UIViewController'
class BaseNavigatableViewController: BaseViewController {
    
    lazy var backButton = UIBarButtonItem(
//        image: Asset.Images.Navigation.naviBack.image,
        image: nil,
        style: .plain,
        target: self,
        action: nil
    )
    
    private(set) var bottomVisibleWhenPopped: Bool = false
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            let bottomVisible = self?.bottomVisibleWhenPopped ?? false
            if let trsNavigationController = self?.trsNavigationController {
                trsNavigationController.popViewController(animated: true, visibleBottom: bottomVisible)
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: self.disposeBag)
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationItem.setLeftBarButton(self.backButton, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}


// MARK: - UIGestureRecognizerDelegate

extension BaseNavigatableViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}
