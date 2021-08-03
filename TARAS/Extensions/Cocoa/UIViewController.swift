//
//  UIViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    ///네비게이션에서 최상단 뷰컨트롤러까지 pop 한 후,  dismiss 하기
    func back(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        if let navi = self.navigationController {
            if navi.viewControllers.count == 1 {
                self.dismiss(animated: flag, completion: completion)
            }else{
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                navi.popViewController(animated: flag)
                CATransaction.commit()
            }
        }else{
            self.dismiss(animated: flag, completion: completion)
        }
    }
}
