//
//  BaseViewController.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit
import RxSwift
import SnapKit
import RxKeyboard

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var trsNavigationController: BaseNavigationController? {
        return self.navigationController as? BaseNavigationController
    }
    
    let activityIndicatorView = UIActivityIndicatorView(style: Constants.indicatorStyle)
    private(set) var activityIndicatorPosition: Position = .init()
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        Log.debug("Deinit \(self.className)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.setupConstraints()
        
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.snp.makeConstraints { make in
            let pos = self.activityIndicatorPosition
            let vertical: ConstraintMakerExtendable = {
                if pos.isTop { return make.top }
                else if pos.isCenterY { return make.centerY }
                else if pos.isBottom { return make.bottom }
                return make.center
            }()
            let horizontal: ConstraintMakerExtendable = {
                if pos.isLeft { return make.leading }
                else if pos.isCenterX { return make.centerX }
                else if pos.isRight { return make.trailing }
                return make.center
            }()
            vertical.equalTo(self.view.safeAreaLayoutGuide).offset(pos.offset.y)
            horizontal.equalTo(self.view.safeAreaLayoutGuide).offset(pos.offset.x)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                let withoutBottomSafeInset = (height == 0 ? 0: height-self.view.safeAreaInsets.bottom)
                self.updatedKeyboard(withoutBottomSafeInset: withoutBottomSafeInset)
            }).disposed(by: self.disposeBag)
    }
    

    func setupConstraints() {
        // override point
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNaviBar()
    }

    func setupNaviBar() {
        // override point
    }
    
    func updatedKeyboard(withoutBottomSafeInset height: CGFloat) {
        // override point
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)        
        self.view.endEditing(true)
    }
}
