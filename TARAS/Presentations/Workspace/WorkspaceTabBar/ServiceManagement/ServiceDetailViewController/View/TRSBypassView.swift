//
//  TRSBypassView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import CoreGraphics

class TRSBypassView: UIView {

    //w*h = 38*36
    private let iconView = UIView().then {
        
        let lineShapeLayer = CAShapeLayer().then {

            $0.path = UIBezierPath().then {
                $0.move(to: CGPoint(x: 19, y: 6))
                $0.addLine(to: CGPoint(x: 19, y: 6+29))
            }.cgPath
            
            $0.strokeColor = Color.LIGHT_PUPLE_EBEAF4.cgColor
            $0.lineWidth = 4
            $0.lineCap = .round
        }
        
        let dotShapeLayer = CAShapeLayer().then {
            
            $0.path = UIBezierPath().then {
                $0.addArc(
                    withCenter: CGPoint(x: 19, y: 20),
                    radius: 4,
                    startAngle: .zero,
                    endAngle: .pi*2,
                    clockwise: true
                )
            }.cgPath
            
            $0.fillColor = Color.SKY_BLUE_85AEFF.cgColor
            $0.lineWidth = 0
        }
        
        $0.layer.addSublayer(lineShapeLayer)
        $0.layer.addSublayer(dotShapeLayer)
    }
    
    private let textLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = Color.BLACK_0F0F0F
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.iconView)
        self.iconView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.height.equalTo(42)
            $0.width.equalTo(38)
        }
        
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(self.iconView.snp.trailing).offset(4)
        }
    }
    
    func bind(text: String) {
        self.textLabel.text = text
    }
}
