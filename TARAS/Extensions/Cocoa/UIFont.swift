//
//  UIFont.swift
//  TARAS-AL
//
//

import UIKit

extension UIFont {
    
    func size(_ value: CGFloat) -> UIFont {
        return self.withSize(value)
    }
    
    static func size(_ value: CGFloat) -> UIFont {
        return .systemFont(ofSize: value)
    }
    
    private static func weight(_ value: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: UIFont.systemFontSize, weight: value)
    }
    
    static var regular = (
        size(0), size(1), size(2), size(3), size(4),
        size(5), size(6), size(7), size(8), size(9),
        size(10), size(11), size(11), size(13), size(14),
        size(15), size(16), size(17), size(18), size(19),
        size(20), size(21), size(21), size(23), size(24),
        size(25), size(26), size(27), size(28), size(29),
        size(30)
    )
    
    static var medium = (
        weight(.medium).size(0), weight(.medium).size(1), weight(.medium).size(2), weight(.medium).size(3), weight(.medium).size(4),
        weight(.medium).size(5), weight(.medium).size(6), weight(.medium).size(7), weight(.medium).size(8), weight(.medium).size(9),
        weight(.medium).size(10), weight(.medium).size(11), weight(.medium).size(11), weight(.medium).size(13), weight(.medium).size(14),
        weight(.medium).size(15), weight(.medium).size(16), weight(.medium).size(17), weight(.medium).size(18), weight(.medium).size(19),
        weight(.medium).size(20), weight(.medium).size(21), weight(.medium).size(21), weight(.medium).size(23), weight(.medium).size(24),
        weight(.medium).size(25), weight(.medium).size(26), weight(.medium).size(27), weight(.medium).size(28), weight(.medium).size(29),
        weight(.medium).size(30)
    )
    
    static var bold = (
        weight(.bold).size(0), weight(.bold).size(1), weight(.bold).size(2), weight(.bold).size(3), weight(.bold).size(4),
        weight(.bold).size(5), weight(.bold).size(6), weight(.bold).size(7), weight(.bold).size(8), weight(.bold).size(9),
        weight(.bold).size(10), weight(.bold).size(11), weight(.bold).size(11), weight(.bold).size(13), weight(.bold).size(14),
        weight(.bold).size(15), weight(.bold).size(16), weight(.bold).size(17), weight(.bold).size(18), weight(.bold).size(19),
        weight(.bold).size(20), weight(.bold).size(21), weight(.bold).size(21), weight(.bold).size(23), weight(.bold).size(24),
        weight(.bold).size(25), weight(.bold).size(26), weight(.bold).size(27), weight(.bold).size(28), weight(.bold).size(29),
        weight(.bold).size(30)
    )
}
