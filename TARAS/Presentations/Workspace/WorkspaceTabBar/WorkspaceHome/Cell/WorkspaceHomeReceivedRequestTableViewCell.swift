//
//  WorkspaceHomeReceivedRequestTableViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources
//import SkeletonView

class WorkspaceHomeReceivedRequestTableViewCell: UITableViewCell, View {
    typealias Reactor = ServiceContainerCellReactor
    
    weak var delegate: ServiceCellDelegate?
    
    var disposeBag = DisposeBag()
    
    let flowLayout = UICollectionViewFlowLayout().then{
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 20
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then{
        
        $0.decelerationRate = .fast
        
        $0.backgroundColor = .clear
        
        $0.register(WorkspaceHomeReceivedRequestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        $0.showsHorizontalScrollIndicator = false
        
//        $0.isSkeletonable = true
    }
    
    private var draggingBeginIndex: Int!
    
    private let cellWidth = UIScreen.main.bounds.width - 22*2
    private let minCellWidth = UIScreen.main.bounds.width - 40*2
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ServiceModelSection>(configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WorkspaceHomeReceivedRequestCollectionViewCell
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
        
//        self.isSkeletonable = true
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
//                let service = reactor.currentState.service
//                let serviceUnit = reactor.currentState.serviceUnit
//                delegate.didSelect(service, serviceUnit, false)
            })
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension WorkspaceHomeReceivedRequestTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = self.dataSource[indexPath.section].items.count
        if count > 3 {
            return CGSize(width: minCellWidth, height: 66)
        }else{
            return CGSize(width: cellWidth, height: 66)
        }
    }
    
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
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = screenWidth - 40*2
        let cellPadding: CGFloat = 20
        return Int((scrollView.contentOffset.x+(cellPadding+screenWidth)/2.0)/(cellWidth+cellPadding))
    }
    
    func scrollContentOffsetX(_ scrollView: UIScrollView, by targetIdx: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = screenWidth - 40*2
        let cellPadding: CGFloat = 20
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.size.width - scrollView.contentInset.left
        
        return min(max(0, CGFloat(targetIdx)*(cellWidth+cellPadding)-(screenWidth-22*2-cellWidth)*0.5), maxOffsetX)
    }
}
