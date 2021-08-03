//
//  Constants.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/02.
//

import UIKit

enum Constants {
    
    static var indicatorStyle: UIActivityIndicatorView.Style {
        if #available(iOS 13.0, *) {
            return .medium
        } else {
            return .gray
        }
    }
}
