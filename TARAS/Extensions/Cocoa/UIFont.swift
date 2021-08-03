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
    
    static var regular: UIFont {
        return self.weight(.regular)
    }
    
    static var medium: UIFont {
        return self.weight(.medium)
    }
    
    static var bold: UIFont {
        return self.weight(.bold)
    }
}
