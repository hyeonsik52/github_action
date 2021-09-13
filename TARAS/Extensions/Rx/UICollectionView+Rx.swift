//
//  UICollectionView+Rx.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

//import RxSwift
//import RxCocoa
////import SkeletonView
//
//extension Reactive where Base: UICollectionView {
//    ///섹션 별 스켈레톤
//    var skeleton: Binder<(Int,[Bool?])> {
//        return Binder(base) { base, info in
//            let section = info.0
//            let pair = info.1
//
//            let tuples = base.indexPathsForVisibleItems
//                .filter { $0.section == section }
//                .map { (indexPath: $0, cell: base.cellForItem(at: $0)) }
//
//            guard pair.count == 2 else { return }
//            switch (pair[0], pair[1]) {
//            case (nil, true):
//                tuples.forEach {
//                    $0.cell?.showAnimatedGradientSkeleton(transition: .none)
//                }
//            case (true, false):
//                tuples.forEach {
//                    $0.cell?.hideSkeleton()
//                }
//            default: break
//            }
//        }
//    }
//}
