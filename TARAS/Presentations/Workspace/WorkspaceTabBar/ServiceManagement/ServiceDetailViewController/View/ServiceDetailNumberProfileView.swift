//
//  ServiceDetailNumberProfileView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ServiceDetailNumberProfileView: UIView {

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 20
    }
    
    private let numberContainer = UIView()
    
    private let numberLabel = UILabel().then {
        $0.clipsToBounds = true
        $0.cornerRadius = 10
        $0.font = .bold[12]
        $0.textColor = .white
        $0.backgroundColor = .skyBlue85AEFF
        $0.textAlignment = .center
        $0.setContentHuggingPriority(.defaultLow+1, for: .horizontal)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .medium[12]
        $0.textColor = .gray8C8C8C
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        let verticalStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 8
        }
        self.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(10)
        }
        
        let numberTextStackView = UIStackView().then {
            $0.axis = .horizontal
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
        
        numberTextStackView.addArrangedSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        verticalStackView.addArrangedSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func bind(number: Int?, title: String?, content: String?, profileImage: String?) {
        
        self.profileImageView.setImage(strUrl: profileImage)
        
        if let number = number {
            self.numberLabel.text = number.description
            self.numberContainer.isHidden = false
        }else{
            self.numberContainer.isHidden = true
            self.numberLabel.text = nil
        }
        
        self.titleLabel.text = title
        
        if let content = content {
            self.contentLabel.text = content
            self.contentLabel.isHidden = false
        }else{
            self.contentLabel.isHidden = true
        }
    }
}
