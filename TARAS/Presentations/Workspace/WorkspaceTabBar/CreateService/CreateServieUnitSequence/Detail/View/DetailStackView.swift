//
//  DetailStackView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

class DetailStackView: UIStackView {
    
    let headerView = DetailHeaderCellView()
    
    let loadView = FreightListView(type: .load)
    
    let unloadView = FreightListView(type: .unload)
    
    let messageView = MessageView()
    
    let recipientsView = RecipientListView()
    
    let footerView = UIView()
    
    init() {
        super.init(frame: .zero)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillProportionally
        
        self.addArrangedSubview(self.headerView)
        self.headerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addArrangedSubview(self.loadView)
        self.loadView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        self.addArrangedSubview(self.unloadView)
        self.unloadView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        self.addArrangedSubview(self.messageView)
        self.messageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(72+24)
        }
        
        self.addArrangedSubview(self.recipientsView)
        self.recipientsView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        self.addArrangedSubview(self.footerView)
        self.footerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
