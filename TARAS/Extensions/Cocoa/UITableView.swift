//
//  UITableView.swift
//
//  Created by Suzy Park on 2020/04/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        self.register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell>(
        ofType type: T.Type,
        indexPath: IndexPath
    ) -> T where T: ReusableView {
        return self.dequeueReusableCell(
            withIdentifier: T.defaultReuseIdentifier,
            for: indexPath
            ) as! T
    }
}

protocol ReusableView {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
