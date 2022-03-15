//
//  FinishedServiceListViewController.swift
//  TARAS
//
//  Created by nexmond on 2022/02/04.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class FinishedServiceListViewController: BaseNavigationViewController, View {
    
    enum Text {
        static let title = "종료 서비스"
    }
    
    override var navigationPopGestureEnabled: Bool {
        return false
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        let width = UIScreen.main.bounds.width - 16 * 2
        $0.minimumLineSpacing = 12
//        $0.estimatedItemSize = .init(width: width, height: 198)
        $0.itemSize = .init(width: width, height: 198)
        $0.sectionInset = .init(top: 8, left: 16, bottom: 24, right: 16)
        $0.headerReferenceSize = .init(width: width, height: 20)
    }
    private lazy var collectionView = UICollectionView.init(
        frame: .zero,
        collectionViewLayout: self.flowLayout
    ).then {
        $0.alwaysBounceVertical = true
        $0.contentInset.top = 16
        $0.verticalScrollIndicatorInsets.top = 16
        
        $0.backgroundColor = .white
        
        $0.register(ServiceCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(
            ServiceDateCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ServiceModelSection>(
        configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath) as! ServiceCell
            cell.reactor = reactor
            
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
            
            let title = dataSource[indexPath.section].header
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath) as! ServiceDateCollectionReusableView
            
            header.bind(title)
            
            return header
        }
    )
    
    private let placeholderLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .regular[16]
        $0.textColor = .darkGray303030
        $0.textAlignment = .center
        $0.text = "종료된 서비스가 없습니다."
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.title
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: FinishedServiceListViewReactor) {
        
        //State
        reactor.state.map(\.serviceSections)
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.services)
            .map { !$0.isEmpty }
            .bind(to: self.placeholderLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading ?? false }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] isLoading in
                if self?.collectionView.refreshControl?.isRefreshing == true {
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.refreshControl?.endRefreshing()
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.retryMoreFind }
            .distinctUntilChanged()
            .map { [weak self] _ in
                let lastSection = (self?.dataSource.sectionModels.count ?? 1) - 1
                let lastIndex = self?.dataSource.sectionModels.last?.items.count ?? 0
                return .init(item: lastIndex, section: lastSection)
            }
            .map { Reactor.Action.moreFind($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //Action
        //temp: 서버 느려짐 현상으로 임시 비활성
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //temp: 서버 느려짐 현상으로 임시 비활성
//        self.rx.viewWillAppear
//            .map {_ in Reactor.Action.refresh }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(ServiceCellReactor.self)
            .map { reactor.reactorForServiceDetail(serviceId: $0.currentState.service.id) }
            .subscribe(onNext: { [weak self] reactor in
                self?.navigationPush(
                    type: ServiceDetailViewController.self,
                    reactor: reactor,
                    animated: true,
                    bottomBarHidden: true
                )
            }).disposed(by: self.disposeBag)
        
        self.collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension FinishedServiceListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSection = self.dataSource.sectionModels.count - 1
        let lastIndex = (self.dataSource.sectionModels.last?.items.count ?? 1) - 1
        if indexPath.section > lastSection {
            self.reactor?.action.onNext(.moreFind(indexPath))
        } else if indexPath.section == lastSection, indexPath.item >= lastIndex {
            self.reactor?.action.onNext(.moreFind(indexPath))
        }
    }
}

