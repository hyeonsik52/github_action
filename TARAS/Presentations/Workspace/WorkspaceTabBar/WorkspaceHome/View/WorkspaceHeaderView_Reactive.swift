//
//  WorkspaceHeaderView_Reactive.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: WorkspaceHeaderView {
    var user: Binder<UserInfo> {
        return Binder(base) { base, user in
            base.bind(user)
        }
    }
}
