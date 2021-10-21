//
//  WorkspaceTitleView.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/22.
//

import UIKit
import SnapKit
import Then

class WorkspaceTitleView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .bold[24]
        $0.textColor = .black
    }
    
    init(title: String, button: UIButton, buttonWidth: CGFloat) {
        super.init(frame: .zero)
        self.setupConstraints(title, button, buttonWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ title: String, _ button: UIButton, _ buttonWidth: CGFloat) {
        
        self.titleLabel.text = title
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(button)
        button.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonWidth).priority(.high)
            $0.height.lessThanOrEqualTo(self.snp.height).priority(.required)
        }
        
        let line = UIView().then {
            $0.backgroundColor = .lightGrayF1F1F1
        }
        self.addSubview(line)
        line.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
