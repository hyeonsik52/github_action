//
//  UIImageView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

extension UIImageView {
    
    static let placeholder = UIColor.lightGrayF1F1F1.toImage
    
    func setImage(strUrl: String?) {
        
        if let strUrl = strUrl,
           let url = URL(string: strUrl) {
            self.kf.setImage(with: url)
            self.backgroundColor = .clear
        }else{
            self.kf.cancelDownloadTask()
            self.image = Self.placeholder
        }
    }
}

extension Reactive where Base: UIImageView {
    var image: Binder<String?> {
        return Binder(base) { $0.setImage(strUrl: $1) }
    }
}
