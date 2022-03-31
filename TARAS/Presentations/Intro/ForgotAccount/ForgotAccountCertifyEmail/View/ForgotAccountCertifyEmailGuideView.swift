//
//  ForgotAccountCertifyEmailGuideView.swift
//  TARAS
//
//  Created by 오현식 on 2022/03/31.
//

import UIKit
import Then
import SnapKit

class ForgotAccountCertifyEmailGuideView: UIView {
    
    private var titleView: LargeTitleView!
    private var screenGuideLabel: UILabel!
    
    init(_ title: String, guideText: String) {
        super.init(frame: .zero)
        
        self.titleView = LargeTitleView(title)
        self.screenGuideLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .medium[16]
            $0.numberOfLines = 0
            $0.text = guideText
        }
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        self.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.screenGuideLabel)
        self.screenGuideLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
}
