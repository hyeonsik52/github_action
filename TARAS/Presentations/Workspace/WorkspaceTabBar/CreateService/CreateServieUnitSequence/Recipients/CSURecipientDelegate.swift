//
//  RecipientsDelegate.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/14.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

/// 수신자 선택 화면은 pageViewController 입니다. 각 pageVC 에서 대상이 선택되었음을 전달합니다.
/// - CSU는 Create Service-Unit(단위서비스 생성) 의 약자입니다.
protocol CSURecipientDelegate: class {
    func didRecipientsSelected(_ serviceUnit: CreateServiceUnitModel)
}
