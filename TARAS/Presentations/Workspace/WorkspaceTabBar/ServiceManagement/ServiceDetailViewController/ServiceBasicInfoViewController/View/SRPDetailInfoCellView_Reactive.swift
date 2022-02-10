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
    var content: Binder<String?> {
        return Binder(base) { base, content in
            base.bind(text: content)
        }
    }
}
