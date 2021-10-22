//
//  TargetInfoView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/15.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

/// CreateServiceCell 에서 사용되는 view 입니다.
/// 대상의 정보(순번, 프로필 이미지, 이름, 소속 그룹 이름) 를 표출합니다.
class TargetInfoView: UIView {
    
    private let numberContainer = UIView()
    
    let numberLabel = UILabel().then {
        $0.text = "1"
        $0.clipsToBounds = true
        $0.cornerRadius = 10
        $0.font = .bold[12]
        $0.textColor = .white
        $0.backgroundColor = .skyblue85AEFF
        $0.textAlignment = .center
        $0.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black0F0F0F
        $0.textAlignment = .left
    }
    
    let arrowImageView = UIImageView(image: UIImage(named: "service-arrow-down"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        let verticalStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fillProportionally
            $0.spacing = 2
        }
        
        self.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let numberTextStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 6
        }
        verticalStackView.addArrangedSubview(numberTextStackView)
        numberTextStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        numberTextStackView.addArrangedSubview(self.numberContainer)
        self.numberContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        self.numberContainer.addSubview(self.numberLabel)
        self.numberLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        numberTextStackView.addArrangedSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        let arrowContainerView = UIView()
        arrowContainerView.addSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.size.equalTo(CGSize(width: 10, height: 10))
        }
        
        numberTextStackView.addArrangedSubview(arrowContainerView)
    }
    
    func bind(_ model: Stop) {
        self.nameLabel.text = model.name
    }
}
