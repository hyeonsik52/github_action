//
//  CSUTargetDelegate.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

/// 대상 선택 화면은 pageViewController 입니다. 각 pageVC 에서 대상이 선택되었음을 전달합니다.
/// - CSU는 Create Service-Unit(단위서비스 생성) 의 약자입니다.
protocol CSUTargetDelegate: AnyObject {
    func didTargetSelected(_ serviceUnitModel: CreateServiceUnitModel)
}
