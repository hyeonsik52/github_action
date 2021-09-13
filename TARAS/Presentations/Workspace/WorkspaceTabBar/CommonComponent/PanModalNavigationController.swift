//
//  PanModalNavigationController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/17.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
//import PanModal

class PanModalNavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.panModalSetNeedsLayoutUpdate()
    }
}

extension PanModalNavigationController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        guard let presentable = self.visibleViewController as? PanModalPresentable else { return nil }
        return presentable.panScrollable
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height*0.1)
    }
    
    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }
    
    var cornerRadius: CGFloat {
        return 30
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
    
    var springDamping: CGFloat {
        return 1
    }
    
    var transitionDuration: Double {
        return 0.4
    }
}
