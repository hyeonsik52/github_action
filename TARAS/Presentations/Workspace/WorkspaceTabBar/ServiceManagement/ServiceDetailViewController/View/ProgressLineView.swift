//
//  ProgressLineView.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/08.
//

import UIKit

class ProgressLineView: UIView {
    
    private var lineAxis: NSLayoutConstraint.Axis
    private var lineWidth: CGFloat
    private var lineColor: UIColor
    private var lineCapStyle: CGLineCap
    private var isLineDashed: Bool
    
    init(
        lineAxis: NSLayoutConstraint.Axis,
        lineWidth: CGFloat = 1,
        lineColor: UIColor = .black,
        lineCapStyle: CGLineCap = .square,
        isLineDashed: Bool = false
    ) {
        self.lineAxis = lineAxis
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.lineCapStyle = lineCapStyle
        self.isLineDashed = isLineDashed
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let isAxisHorizontal = (self.lineAxis == .horizontal)
        return .init(
            width: isAxisHorizontal ? 0: self.lineWidth,
            height: isAxisHorizontal ? self.lineWidth: 0
        )
    }
    
    override func draw(_ rect: CGRect) {
        
        let isAxisHorizontal = (self.lineAxis == .horizontal)
        
        let path = UIBezierPath()
        if isAxisHorizontal {
            path.move(to: .init(x: rect.minX+self.lineWidth/2, y: rect.midY))
            path.addLine(to: .init(x: rect.maxX-self.lineWidth/2, y: rect.midY))
        } else {
            path.move(to: .init(x: rect.midX, y: rect.minY+self.lineWidth/2))
            path.addLine(to: .init(x: rect.midX, y: rect.maxY-self.lineWidth/2))
        }
        
        let gap: CGFloat = 4
        let unit = (isAxisHorizontal ? rect.width: rect.height)
        let remainder = (unit-self.lineWidth).truncatingRemainder(dividingBy: gap)
        
        self.lineColor.set()
        path.lineWidth = self.lineWidth
        path.lineCapStyle = self.lineCapStyle
        if self.isLineDashed {
            let pattern: [CGFloat] = [0, gap]
            path.setLineDash(pattern, count: pattern.count, phase: remainder/2)
        }
        path.stroke()
    }
    
    func update(
        lineWidth: CGFloat? = nil,
        lineColor: UIColor? = nil,
        lineCapStyle: CGLineCap? = nil,
        isLineDashed: Bool? = nil
    ) {
        self.lineWidth = lineWidth ?? self.lineWidth
        self.lineColor = lineColor ?? self.lineColor
        self.lineCapStyle = lineCapStyle ?? self.lineCapStyle
        self.isLineDashed = isLineDashed ?? self.isLineDashed
        self.setNeedsDisplay()
    }
}
