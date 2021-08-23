//
//  WorkspaceHomeSendedRequestTableViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources
import SkeletonView

class WorkspaceHomeSendedRequestTableViewCell: UITableViewCell, View {
    typealias Reactor = ServiceContainerCellReactor
    
    weak var delegate: ServiceCellDelegate?
    
    var disposeBag = DisposeBag()
    
    private let flowLayout = UICollectionViewFlowLayout().then{
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 260, height: 198)
        $0.minimumLineSpacing = 10
        $0.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then{
        
        $0.decelerationRate = .fast
        
        $0.backgroundColor = .clear
        
        $0.register(WorkspaceHomeSendedRequestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        $0.showsHorizontalScrollIndicator = false
        
        $0.isSkeletonable = true
    }
    
    private var draggingBeginIndex: Int!
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ServiceModelSection>(configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WorkspaceHomeSendedRequestCollectionViewCell
        cell.reactor = reactor
        
        return cell
    })
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.isSkeletonable = true
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: ServiceContainerCellReactor) {
        
        //Action
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.modelSelected(ServiceCellReactor.self)
            .subscribe(onNext: { [weak self] reactor in
                guard let delegate = self?.delegate else { return }
                let service = reactor.currentState.service
                delegate.didSelect(service, nil, true)
            })
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension WorkspaceHomeSendedRequestTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.draggingBeginIndex = self.scrollTargetIdx(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let numberOfItems = self.reactor?.currentState.first?.items.count else { return }

        var targetIndex = 0
        if velocity.x > 0 {
            targetIndex = min(draggingBeginIndex + 1, numberOfItems)
        }else if velocity.x < 0 {
            targetIndex = max(draggingBeginIndex - 1, 0)
        }else{
            targetIndex = self.scrollTargetIdx(scrollView)
        }
        
        targetContentOffset.pointee.x = self.scrollContentOffsetX(scrollView, by: targetIndex)
    }
    
    var scrollTargetIdx: Int {
        return self.scrollTargetIdx(self.collectionView)
    }
    
    func scrollTargetIdx(_ scrollView: UIScrollView) -> Int {
        let cellWidth: CGFloat = 260
        let cellPadding: CGFloat = 10
        return Int((scrollView.contentOffset.x+cellWidth*0.5+cellPadding)/(cellWidth+cellPadding))
    }
    
    func scrollContentOffsetX(_ scrollView: UIScrollView, by targetIdx: Int) -> CGFloat {
        let cellWidth: CGFloat = 260
        let cellPadding: CGFloat = 10
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.size.width - scrollView.contentInset.left
        
        return min(max(0, CGFloat(targetIdx)*(cellWidth+cellPadding)), maxOffsetX)
    }
}
