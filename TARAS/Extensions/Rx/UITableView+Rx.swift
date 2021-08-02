//
//  UITableView+Rx.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/09/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

//import RxSwift
//import RxCocoa
//import SkeletonView
//
//extension Reactive where Base: UITableView {
//    ///섹션 별 스켈레톤
//    var skeleton: Binder<([Bool?])> {
//        return Binder(base) { base, pair in
//            let tuples = base.indexPathsForVisibleRows?
//                .map { (indexPath: $0, cell: base.cellForRow(at: $0)) }
//            
//            guard pair.count == 2 else { return }
//            switch (pair[0], pair[1]) {
//            case (nil, true):
//                tuples?.forEach {
//                    $0.cell?.showAnimatedGradientSkeleton(transition: .none)
//                }
//            case (true, false):
//                tuples?.forEach {
//                    $0.cell?.hideSkeleton()
//                }
//            default: break
//            }
//        }
//    }
//}
