//
//  Position.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/19.
//

import UIKit

struct Position {
    
    enum VerticalAnchor {
        case top, center, bottom
    }
    enum HorizontalAnchor {
        case left, center, right
    }
    
    var anchorY: VerticalAnchor = .center
    var anchorX: HorizontalAnchor = .center
    var offset: CGPoint = .zero
    
    var isTop: Bool {
        return (self.anchorY == .top)
    }
    
    var isCenterY: Bool {
        return (self.anchorY == .center)
    }
    
    var isBottom: Bool {
        return (self.anchorY == .bottom)
    }
    
    var isLeft: Bool {
        return (self.anchorX == .left)
    }
    
    var isCenterX: Bool {
        return (self.anchorX == .center)
    }
    
    var isRight: Bool {
        return (self.anchorX == .right)
    }
}
