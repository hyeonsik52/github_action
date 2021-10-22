//
//  SRPDetailInfoCellView_Reactive.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: SRPDetailInfoCellView {
    var info: Binder<(String?,Bool)> {
        return Binder(base) { base, info in
            base.bind(text: info.0, usingArrow: info.1)
        }
    }
}
