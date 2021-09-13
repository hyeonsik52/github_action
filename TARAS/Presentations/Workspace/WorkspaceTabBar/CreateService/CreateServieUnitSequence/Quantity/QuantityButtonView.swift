//
//  QuantityButtonView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class QuantityButton: UIButton {
    
    enum quantityButtonType {
        case plusGray
        case plusPurple
        case minus
        case delete
    }
    
    let didTap = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    
    init(type: quantityButtonType) {
        super.init(frame: .zero)
        
        self.backgroundColor = .LIGHT_GRAY_F6F6F6
        self.cornerRadius = 12
        self.clipsToBounds = true
        
        switch type {
        case .plusGray:
            self.setImage(UIImage(named: "service-product-plusGray"), for: .normal)
        case .plusPurple:
            self.setImage(UIImage(named: "service-product-plusPurple"), for: .normal)
        case .minus:
            self.setImage(UIImage(named: "service-product-minus"), for: .normal)
        case .delete:
            self.setImage(UIImage(named: "service-product-delete"), for: .normal)
        }
        
        self.contentMode = .scaleAspectFit
        
        self.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.didTap.accept(())
        }).disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
