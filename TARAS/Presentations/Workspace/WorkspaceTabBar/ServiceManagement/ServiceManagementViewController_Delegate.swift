//
//  ServiceManagementViewController_Delegate.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

extension ServiceManagementViewController: ServiceCellDelegate {
    
    func didSelect(_ service: Service, _ serviceUnit: ServiceUnit?, _ isServiceDetail: Bool) {
        
        let viewController = ServiceDetailViewController()
        viewController.reactor = self.reactor?.reactorForServiceDetail(serviceId: service.id)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
