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
    
    struct Anchor {
        var vertical: VerticalAnchor = .center
        var horizontal: HorizontalAnchor = .center
        
        static let center = Anchor()
        static let top = Anchor(vertical: .top)
        static let bottom = Anchor(vertical: .bottom)
        static let left = Anchor(horizontal: .left)
        static let right = Anchor(horizontal: .right)
    }
    
    var anchor: Anchor = .center
    var offset: CGPoint = .zero
    
    var isTop: Bool {
        return (self.anchor.vertical == .top)
    }
    
    var isCenterY: Bool {
        return (self.anchor.vertical == .center)
    }
    
    var isBottom: Bool {
        return (self.anchor.vertical == .bottom)
    }
    
    var isLeft: Bool {
        return (self.anchor.horizontal == .left)
    }
    
    var isCenterX: Bool {
        return (self.anchor.horizontal == .center)
    }
    
    var isRight: Bool {
        return (self.anchor.horizontal == .right)
    }
    
    var isCenter: Bool {
        return (self.isCenterX && self.isCenterY)
    }
}
