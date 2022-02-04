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

class ServiceDetailViewController: BaseNavigationViewController, View {
    
    override var navigationPopGestureEnabled: Bool {
        return false
    }
    
    private let moreButton = UIBarButtonItem(
        image: UIImage(named: "service-more")?.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )
    
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
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationItem.setRightBarButton(self.moreButton, animated: true)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.collectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
}
