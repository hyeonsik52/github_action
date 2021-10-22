//
//  ServiceDetailViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources

class ServiceDetailViewController: BaseViewController, View {
    
    private let backButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(UIImage(named: "navi-back"), for: .normal)
    }
    
    private let moreButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(UIImage(named: "service-more"), for: .normal)
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.scrollDirection = .vertical
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        $0.minimumLineSpacing = 14
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        
        $0.backgroundColor = .clear
        
        $0.register(ServiceUnitManagementHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        $0.register(ServiceUnitManagementCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .grayF6F6F6
        
        let navigationBar = UIView()
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        navigationBar.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(36)
        }
        
        navigationBar.addSubview(self.moreButton)
        self.moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(36)
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: ServiceDetailViewReactor) {
        
        //Action
        let viewDidLoad = self.rx.viewDidLoad.single()
        
        viewDidLoad.map { Reactor.Action.judgeIsFromPush }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        viewDidLoad
            .map { Reactor.Action.loadService(refresh: false) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.back()
            })
            .disposed(by: self.disposeBag)
        
        //State
        
        reactor.state.compactMap { $0.requestCanceled }
            .distinctUntilChanged()
            .subscribe(onNext: { successed in
                reactor.action.onNext(.loadService(refresh: true))
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.serviceDeleted }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] successed in
                if successed {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.collectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
}


// MARK: - UIGestureRecognizerDelegate

extension ServiceDetailViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}
