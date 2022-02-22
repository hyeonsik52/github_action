//
//  ServiceCreationFooter.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import UIKit
import SnapKit
import Then

class ServiceCreationFooter: UICollectionReusableView {
    
    let button = UIButton().then {
        $0.contentMode = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitle("+ 정차지 추가", for: .normal)
        $0.setTitleColor(.purple4A3C9F, for: .normal)
        $0.titleLabel?.font = .bold[16]
        $0.setBackgroundColor(color: .lightPurpleEBEAF4, forState: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
