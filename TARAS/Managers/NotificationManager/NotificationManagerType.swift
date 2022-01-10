//
//  NotificationManagerType.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/15.
//

import Foundation

protocol NotificationManagerType: AnyObject {
    
    typealias ObserveClosure<T> = (T) -> Void
    
    func observe<T, N: Notification<T>>(to: N.Type, repeat: Int, _ closure: @escaping ObserveClosure<T>)
    func post<T, N: Notification<T>>(_ notification: N)
    func dispose<T, N: Notification<T>>(to: N.Type)
}
