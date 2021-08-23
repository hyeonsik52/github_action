//
//  FreightTypeSelectView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class FreightTypeSelectView: UIView {
    
    let didTap = PublishRelay<Void>()
    
    private var type: ServiceUnitFreightType = .unload
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - UI
    
    private let loadLabel = UILabel().then {
        $0.text = "실을 물품" // 고정
        $0.textColor = Color.GRAY_999999
        $0.font = Font.BOLD_15
    }
    
    private let unLoadLabel = UILabel().then {
        $0.text = "내릴 물품" // 고정
        $0.textColor = Color.BLACK_0F0F0F
        $0.font = Font.BOLD_15
    }
    
    private let barView = UIView().then {
        $0.backgroundColor = Color.LIGHT_PUPLE_EBEAF4
        $0.cornerRadius = 2
    }
    
    private let thumbNailView = UIView().then {
        $0.backgroundColor = Color.PURPLE_4A3C9F
        $0.cornerRadius = 6
    }
    
    private let button = UIButton()
    
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        self.setupConstraints()
        
        self.button.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.didTap.accept(())
        }).disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constraints
    
    func setupConstraints() {
        self.addSubview(self.barView)
        self.barView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 4))
            $0.center.equalToSuperview()
        }
        
        self.addSubview(self.thumbNailView)
        self.thumbNailView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
            $0.centerY.equalTo(self.barView)
            $0.leading.equalTo(self.barView).offset(16)
        }
        
        self.addSubview(self.loadLabel)
        self.loadLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.barView)
            $0.trailing.equalTo(self.barView.snp.leading).offset(-12)
        }
        
        self.addSubview(self.unLoadLabel)
        self.unLoadLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.barView)
            $0.leading.equalTo(self.barView.snp.trailing).offset(12)
        }
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func toggleFreightMode(_ type: ServiceUnitFreightType) {
        self.type = type
        
        let isLoad = (type == .load)
        self.loadLabel.textColor = isLoad ? Color.BLACK_0F0F0F: Color.GRAY_999999
        self.unLoadLabel.textColor = isLoad ? Color.GRAY_999999: Color.BLACK_0F0F0F
        let thumbNailLeadingMargin: CGFloat = isLoad ? 3: 16

        self.thumbNailView.snp.updateConstraints {
            $0.leading.equalTo(self.barView).offset(thumbNailLeadingMargin)
        }
    }
}
