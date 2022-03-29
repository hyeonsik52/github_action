//
//  ServiceCreationHeader.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import UIKit
import SnapKit
import Then

class ServiceCreationHeader: UICollectionReusableView {
    
    let titleLabel = UILabel().then{
        $0.font = .bold[16]
        $0.textColor = .darkGray303030
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.backgroundColor = .white
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
    
    func bind(_ title: String) {
        self.titleLabel.text = title
    }
}
