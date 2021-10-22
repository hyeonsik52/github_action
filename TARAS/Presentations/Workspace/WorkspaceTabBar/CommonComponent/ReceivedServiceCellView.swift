//
//  ReceivedServiceCellView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class ReceivedServiceCellView: UIView {
    
    private var thumbnailImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22
    }
    private var titleLabel = UILabel().then{
        $0.font = .bold[16]
        $0.textColor = .black0F0F0F
    }
    private var secondaryLabel = UILabel().then{
        $0.font = .regular[12]
        $0.textColor = .gray9A9A9A
        $0.lineBreakMode = .byTruncatingMiddle
    }
    private var tertiaryLabel = UILabel().then{
        $0.font = .regular[12]
        $0.textColor = .gray9A9A9A
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.thumbnailImageView)
        self.thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        let container = UIView()
        self.addSubview(container)
        container.snp.makeConstraints{
            $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(14)
            $0.top.equalToSuperview().offset(17)
            $0.bottom.equalToSuperview().offset(-13)
            $0.trailing.equalToSuperview()
        }
        
        container.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        
        container.addSubview(self.secondaryLabel)
        self.secondaryLabel.snp.makeConstraints{
            $0.leading.bottom.equalToSuperview()
        }
        
        self.tertiaryLabel.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
        self.tertiaryLabel.setContentHuggingPriority(.defaultLow+1, for: .horizontal)
        container.addSubview(self.tertiaryLabel)
        self.tertiaryLabel.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(self.secondaryLabel.snp.trailing).offset(6)
        }
    }
    
    func bind(title: String?, subTitle: String?, detail: String? , profileImageURL: String?) {
        
        self.thumbnailImageView.setImage(strUrl: profileImageURL)
        self.titleLabel.text = title
        self.secondaryLabel.text = subTitle
        self.tertiaryLabel.text = detail
    }
}
