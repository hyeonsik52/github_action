//
//  SRPButton.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import UIKit

/// TARAS 프로젝트에서 공통으로 사용되는 solid 타입 버튼입니다.
class SRPButton: UIButton {
    
    struct Appearance {
        
        enum StateColor {
            case normal(UIColor)
            case disabled(UIColor)
            
            var state: UIControl.State {
                switch self {
                case .normal:
                    return .normal
                case .disabled:
                    return .disabled
                }
            }
            
            var color: UIColor {
                switch self {
                case .normal(let color):
                    return color
                case .disabled(let color):
                    return color
                }
            }
        }
        
        var font: UIFont = .medium.16
        var titleColors: [StateColor] = [.normal(.white), .disabled(.purpleCACAEA)]
        var backgroundColors: [StateColor] = [.normal(.purple4A3C9F), .disabled(.purpleEAEAF6)]
        var cornerRadius: CGFloat = 8
        
        static let instance = Appearance()
    }
    
    init(_ title: String, appearance: Appearance = .instance) {
        super.init(frame: .zero)
        
        self.update(title, appearance: appearance)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ title: String, appearance: Appearance) {
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = appearance.font
        
        appearance.titleColors.map { ($0.color, $0.state) }
            .forEach(self.setTitleColor)
        appearance.backgroundColors.map { ($0.color, $0.state) }
            .forEach(self.setBackgroundColor)
        
        self.layer.cornerRadius = appearance.cornerRadius
    }
}
