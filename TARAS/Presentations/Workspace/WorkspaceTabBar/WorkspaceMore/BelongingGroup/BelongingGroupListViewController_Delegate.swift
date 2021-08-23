//
//  BelongingGroupListViewController_Delegate.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

extension BelongingGroupListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
