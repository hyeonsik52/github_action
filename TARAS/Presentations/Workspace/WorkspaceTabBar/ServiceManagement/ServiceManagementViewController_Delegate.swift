//
//  ServiceManagementViewController_Delegate.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension ServiceManagementViewController: ServiceCellDelegate {
    
    func didSelect(_ service: ServiceModel, _ serviceUnit: ServiceUnitModel?, _ isServiceDetail: Bool) {
        
        let viewController = ServiceDetailViewController()
        viewController.reactor = self.reactor?.reactorForServiceDetail(mode: .processing, serviceIdx: service.serviceIdx)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
