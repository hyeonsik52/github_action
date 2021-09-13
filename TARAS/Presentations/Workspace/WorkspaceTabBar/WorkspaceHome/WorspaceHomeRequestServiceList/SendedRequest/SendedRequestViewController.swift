//
//  SendedRequestViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import ReactorKit
import RxDataSources
import SkeletonView

class SendedRequestViewController: BaseNavigatableViewController, View {
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 22*2, height: 198)
        $0.sectionInset.bottom = 14
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout).then {
        
        $0.contentInset.top = 14
        
        $0.backgroundColor = .clear
        
        $0.register(SendedRequestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(RequestCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        $0.isSkeletonable = true
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ServiceModelSection>(configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SendedRequestCollectionViewCell
        cell.reactor = reactor
        
        return cell
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
        
        let title = dataSource[indexPath.section].header
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! RequestCollectionViewHeader
        header.bind(title: title)
        
        return header
    })
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "보낸 요청"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func bind(reactor: PagingSendedRequestReactor) {
        
        //State
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.preparingIsLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { (0, $0) }
            .observeOn(MainScheduler.instance)
            .bind(to: self.collectionView.rx.skeleton)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.canceledIsLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { (1, $0) }
            .observeOn(MainScheduler.instance)
            .bind(to: self.collectionView.rx.skeleton)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.preparingIsLoading ?? false && $0.canceledIsLoading ?? false }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] isLoading in
                if self?.collectionView.refreshControl?.isRefreshing ?? false {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.retryMoreCanceled }
            .distinctUntilChanged()
            .map { [weak self] _ in self?.collectionView.numberOfItems(inSection: 1) ?? 0 }
            .map { Reactor.Action.moreCanceled($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //Action
        self.rx.viewDidLoad
            .map{ Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(ServiceCellReactor.self)
            .subscribe(onNext: { [weak self] cellReactor in
                
                let serviceIdx = cellReactor.currentState.service.serviceIdx
                
                let viewController = ServiceDetailViewController()
                viewController.reactor = reactor.reactorForSelectSendedService(mode: .preparing, serviceIdx: serviceIdx)
                
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension SendedRequestViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndex = self.dataSource[1].items.count-1
        if indexPath.section == 1, indexPath.item >= lastIndex {
            self.reactor?.action.onNext(.moreCanceled(indexPath.item))
        }
    }
}
