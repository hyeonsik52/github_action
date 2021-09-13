//
//  CreateServiceFooterView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

class CreateServiceFooterView: UIView {
    
    let didSelect = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    let addButton = UIButton().then {
        $0.setBackgroundColor(color: .LIGHT_PUPLE_EBEAF4, forState: .normal)
        $0.titleLabel?.font = .bold.20
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.purple4A3C9F, for: .normal)
        $0.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(self.addButton)
        self.addButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        addButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.didSelect.accept(())
        }).disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
