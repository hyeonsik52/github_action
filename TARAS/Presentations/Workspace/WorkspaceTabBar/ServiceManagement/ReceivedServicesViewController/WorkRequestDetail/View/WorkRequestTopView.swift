//
//  WorkRequestTopView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/14.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkRequestTopView: UIView {

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 20
        $0.backgroundColor = .lightGrayF1F1F1
    }
    
    private let numberLabelContainer = UIView().then { $0.isHidden = true }
    
    private let numberLabel = UILabel().then {
        $0.font = .bold[12]
        $0.textColor = .white
        $0.clipsToBounds = true
        $0.cornerRadius = 10
        $0.backgroundColor = .skyBlue85AEFF
        $0.textAlignment = .center
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black
        $0.lineBreakMode = .byTruncatingMiddle
    }
    
    private let subContentLabel = UILabel().then {
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
        
        let verticalContentStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 2
        }
        self.addSubview(verticalContentStackView)
        verticalContentStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(6)
        }
        
        let horizontalContentStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 6
        }
        verticalContentStackView.addArrangedSubview(horizontalContentStackView)
        horizontalContentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        horizontalContentStackView.addArrangedSubview(self.numberLabelContainer)
        self.numberLabelContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        self.numberLabelContainer.addSubview(self.numberLabel)
        self.numberLabel.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        horizontalContentStackView.addArrangedSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        verticalContentStackView.addArrangedSubview(self.subContentLabel)
        self.subContentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func bind(content: String?, subContent: String?, profileImageUrl: String?, number: Int?) {
        
        self.profileImageView.setImage(strUrl: profileImageUrl)
        self.contentLabel.text = content
        
        if let subContent = subContent {
            self.subContentLabel.isHidden = false
            self.subContentLabel.text = subContent
        }else{
            self.subContentLabel.isHidden = true
        }
        
        if let number = number?.description {
            self.numberLabelContainer.isHidden = false
            self.numberLabel.text = number
        }else{
            self.numberLabelContainer.isHidden = true
        }
    }
}
