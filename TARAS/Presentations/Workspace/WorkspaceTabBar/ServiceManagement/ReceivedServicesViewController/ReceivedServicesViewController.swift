//
//  ReceivedServicesViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/05/29.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class ReceivedServicesViewController: BaseViewController, View {
    
    weak var delegate: ServiceCellDelegate?
    
    private let flowLayout = UICollectionViewFlowLayout().then{
        let screenWidth = UIScreen.main.bounds.width
        $0.minimumLineSpacing = 10
        $0.itemSize = CGSize(width: screenWidth-22*2, height: 200)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 10, right: 22)
        $0.headerReferenceSize = CGSize(width: screenWidth, height: 44)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then{
        
        $0.contentInset.top = 4
        
        $0.backgroundColor = .clear
        
        $0.register(MyServiceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(ServiceStateCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ServiceModelSection>(configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyServiceCollectionViewCell
        cell.reactor = reactor
        
        return cell
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
        
        let title = dataSource[indexPath.section].header
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! ServiceStateCollectionReusableView
        
        header.bind(title)
        
        return header
    })
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: PagingReceivedServicesViewReactor) {
        
        //State
        reactor.state.map { $0.sections }
        .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.processingIsLoading ?? false && $0.completedIsLoading ?? false }
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
        
        reactor.state.map { $0.retryMoreCompleted }
            .distinctUntilChanged()
            .map { [weak self] _ in self?.collectionView.numberOfItems(inSection: 1) ?? 0 }
            .map { Reactor.Action.moreCompleted($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(ServiceCellReactor.self)
            .subscribe(onNext: { [weak self] reactor in
                let service = reactor.currentState.service
                let serviceUnit = reactor.currentState.serviceUnit
                self?.delegate?.didSelect(service, serviceUnit, true)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension ReceivedServicesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndex = self.dataSource[1].items.count-1
        if indexPath.section == 1, indexPath.item >= lastIndex {
            self.reactor?.action.onNext(.moreCompleted(indexPath.item))
        }
    }
}

