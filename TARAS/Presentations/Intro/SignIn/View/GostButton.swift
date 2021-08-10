//
//  GostButton.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit

/// SignInViewController 에서 사용되는 '회원가입하기' 버튼입니다.
class GostButton: UIButton {
    
    init(_ title: String, color: UIColor = .darkGray303030) {
        super.init(frame: .zero)
        
        var attributedString: NSMutableAttributedString
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.regular.12
        ]
        
        attributedString = NSMutableAttributedString(
            string: title,
            attributes: attributes
        )

        self.setBackgroundColor(color: UIColor.clear, forState: .normal)
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
