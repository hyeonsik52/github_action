//
//  WorkspaceShortcutView.swift
//  TARAS-KD
//
//  Created by nexmond on 2021/01/20.
//  Copyright © 2021 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkspaceShortcutView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .bold.18
        $0.textColor = UIColor(hex: "#0F0F0F")
    }
    
    let contentLabel = UILabel().then {
        $0.font = .medium.14
        $0.textColor = UIColor(hex: "#0F0F0F")
        $0.numberOfLines = 0
    }
    
    let button = SRPButton("").then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 23
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.backgroundColor = UIColor(hex: "#F8F8F8")
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(46)
        }
    }
}
