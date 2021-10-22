//
//  MessageView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MessageView: UIView {
    
    var didTap = PublishRelay<Void>()
    
    let disposeBag = DisposeBag()
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .grayF8F8F8
        $0.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let messageTextfield = UITextField().then {
        $0.font = .bold[18]
        $0.placeholder = "요청사항 입력"
        $0.textColor = .black0F0F0F
    }
    
    let button = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
            $0.bottom.equalToSuperview()
        }
        
        self.backgroundView.addSubview(self.messageTextfield)
        self.messageTextfield.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints {
            $0.edges.equalTo(self.backgroundView)
        }
        
        self.button.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.didTap.accept(())
        }).disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
