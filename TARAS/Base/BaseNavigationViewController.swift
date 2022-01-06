//
//  BaseNavigationViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa

/// 네비 용 'UIViewController'
class BaseNavigationViewController: BaseViewController {
    
    let backButton = UIBarButtonItem(
        image: UIImage(named: "navi-back"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    var backButtonDisposeBag = DisposeBag()
    
    private let navigationBarBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private(set) var navigationPopWithBottomBarHidden: Bool = false
    private(set) var navigationPopGestureEnabled: Bool = true

    var navigationBarColor: UIColor? {
        set {
            self.navigationBarBackgroundView.backgroundColor = newValue
        }
        get {
            self.navigationBarBackgroundView.backgroundColor
        }
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //최상단에 적용되어야 하므로 setupConstraints 뒤인 이 곳에 위치함
        self.view.addSubview(self.navigationBarBackgroundView)
        self.navigationBarBackgroundView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    override func bind() {
        super.bind()
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationPop(
                    animated: true,
                    bottomBarHidden: self.navigationPopWithBottomBarHidden
                )
            }).disposed(by: self.backButtonDisposeBag)
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationItem.setLeftBarButton(self.backButton, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationBarColor = self.view.backgroundColor
    }
}


// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationPopGestureEnabled
    }
}


extension Reactive where Base: BaseNavigationViewController {
    
    var navigationBarColor: Binder<UIColor?> {
        return Binder(self.base) { view, value in
            view.navigationBarColor = value
        }
    }
}
