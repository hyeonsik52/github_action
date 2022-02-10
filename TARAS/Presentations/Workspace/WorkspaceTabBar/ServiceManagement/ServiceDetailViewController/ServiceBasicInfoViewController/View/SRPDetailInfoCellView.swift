//
//  SRPDetailInfoCellView.swift
//  Dev-ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SRPDetailInfoCellView: UIView {

    private let titleLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black0F0F0F
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
    }
    private let contentLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black0F0F0F
    }
    private let arrowImageView = UIImageView().then {
        $0.contentMode = .center
        $0.image = UIImage(named: "setting-detail")
        $0.setContentCompressionResistancePriority(.defaultHigh+2, for: .horizontal)
        $0.isHidden = true
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
        }
        
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        stackView.addArrangedSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(12)
        }
    }
    
    func bind(text: String? = nil) {
        self.contentLabel.isHidden = (text == nil)
        self.contentLabel.text = text ?? "-"
    }
}
