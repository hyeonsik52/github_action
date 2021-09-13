//
//  FreightListCellView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit

struct FreightListCellModel {
    var type: ServiceUnitFreightType
    var name: String
    var quantity: Int
}

class FreightListCellView: UIView, ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    let deleteButton = QuantityButton(type: .delete).then {
        $0.setBackgroundColor(color: .LIGHT_GRAY_F6F6F6, forState: .normal)
    }
    
    let freightNameLabel = UILabel().then {
        $0.font = .medium.16
        $0.textColor = .black
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    let quantityLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .black
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: FreightListCellReactor) {
        self.freightNameLabel.text = reactor.initialState.name
        self.quantityLabel.text = reactor.initialState.quantity.currencyFormatted
    }
    
    func setupConstraints() {
        self.addSubview(self.deleteButton)
        self.deleteButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.leading.equalToSuperview().offset(22)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(self.quantityLabel)
        self.quantityLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        self.addSubview(self.freightNameLabel)
        self.freightNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.deleteButton.snp.trailing).offset(14)
            $0.trailing.lessThanOrEqualTo(self.quantityLabel.snp.leading).offset(-14)
        }
    }
}
