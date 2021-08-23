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
    var info: Binder<(String?,Bool,String?,Bool)> {
        return Binder(base) { base, info in
            base.bind(text: info.0, fixedProfile: info.1, profileImageUrl: info.2, usingArrow: info.3)
        }
    }
}
