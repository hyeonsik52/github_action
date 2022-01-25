//
//  UIView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {

    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor.init(cgColor: color)
            } else {
                return nil
            }
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable var outlineWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var outlineColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor.init(cgColor: color)
            } else {
                return nil
            }
        }
    }
}

extension UIView {
    
    static var kUIViewMaskPathOutline = "kUIViewMaskPathOutline"

    var maskPathOutline: CAShapeLayer? {
        set {
            objc_sync_enter(self); defer {objc_sync_exit(self)}
            objc_setAssociatedObject(self, &UIView.kUIViewMaskPathOutline, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            objc_sync_enter(self); defer {objc_sync_exit(self)}
            return objc_getAssociatedObject(self, &UIView.kUIViewMaskPathOutline) as? CAShapeLayer
        }
    }
    
    func maskPath(_ path: UIBezierPath) {
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        //테두리가 있다면 패스를 따라서 라인을 추가한다
        if self.outlineWidth > 0, self.layer.cornerRadius == 0 {
            
            //동기
            objc_sync_enter(self);
            defer {
                objc_sync_exit(self)
            }
            
            //현재 적용된 패스 모양에 맞춰 테두리 생성
            let borderLayer = CAShapeLayer()
            borderLayer.path = path.cgPath
            borderLayer.lineWidth = self.outlineWidth*2
            borderLayer.strokeColor = self.outlineColor?.cgColor ?? UIColor.black.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.frame = self.bounds
            
            //이미 존재하면 레이어 교체
            if let outline = self.maskPathOutline {
                self.layer.replaceSublayer(outline, with: borderLayer)
            }else{
                //없으면 추가
                self.layer.addSublayer(borderLayer)
            }
            
            //비교를 위해 저장
            self.maskPathOutline = borderLayer
        }
    }
    
    /// 레이어의 각 코너의 레디우스를 스트링으로 설정
    /// - parameter query: all:topLeft/topRight/bottomRight/bottomLeft
    ///            (default: "2:///14" -> 좌하단14 나머지2)
    func radiusQuery(_ query: String = "2:///14") {
        guard layer.cornerRadius == 0 else { return }
        layoutIfNeeded()

        let allComponents = query.components(separatedBy: ":")
        if let strValue = allComponents.first, let dValue = Double(strValue) {

            var topLeft = CGFloat(dValue)
            var topRight = CGFloat(dValue)
            var bottomRight = CGFloat(dValue)
            var bottomLeft = CGFloat(dValue)

            if allComponents.count > 1 {
                let partComponets = allComponents[1].components(separatedBy: "/")
                if partComponets.count == 4 {
                    if let dValue = Double(partComponets[0]) {
                        topLeft = CGFloat(dValue)
                    }
                    if let dValue = Double(partComponets[1]) {
                        topRight = CGFloat(dValue)
                    }
                    if let dValue = Double(partComponets[2]) {
                        bottomRight = CGFloat(dValue)
                    }
                    if let dValue = Double(partComponets[3]) {
                        bottomLeft = CGFloat(dValue)
                    }
                }
            }

            let width = bounds.width
            let height = bounds.height

            let path = UIBezierPath()

            path.move(to: CGPoint(x: topLeft, y: 0))

            path.addLine(to: CGPoint(x: width-topRight, y: 0))

            path.addArc(withCenter: CGPoint(x: width-topRight, y: topRight), radius: topRight, startAngle: .pi*3/2, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: width, y: height-bottomRight))

            path.addArc(withCenter: CGPoint(x: width-bottomRight, y: height-bottomRight), radius: bottomRight, startAngle: 0, endAngle: .pi/2, clockwise: true)
            path.addLine(to: CGPoint(x: bottomLeft, y: height))

            path.addArc(withCenter: CGPoint(x: bottomLeft, y: height-bottomLeft), radius: bottomLeft, startAngle: .pi/2, endAngle: .pi, clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: topLeft))

            path.addArc(withCenter: CGPoint(x: topLeft, y: topLeft), radius: topLeft, startAngle: .pi, endAngle: .pi*3/2, clockwise: true)

            self.maskPath(path)
        }
    }
}
