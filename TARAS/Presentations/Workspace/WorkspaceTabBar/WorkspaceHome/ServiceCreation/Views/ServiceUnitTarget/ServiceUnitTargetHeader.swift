//
//  ServiceUnitTargetHeader.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/11.
//

import UIKit
import SnapKit
import Then

class ServiceUnitTargetHeader: UITableViewHeaderFooterView {
    
    private var titleLabel = UILabel().then{
        $0.font = .regular[12]
        $0.textColor = .gray9A9A9A
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.backgroundView = UIView().then{
            $0.backgroundColor = .white
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func bind(_ title: String) {
        self.titleLabel.text = title
    }
}
