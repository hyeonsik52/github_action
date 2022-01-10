//
//  NotificationManager+Rx.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/30.
//

import RxSwift

extension NotificationManagerType {
    
    func observe<T, N: Notification<T>>(to: N.Type, repeat: Int = 0) -> Observable<T> {
        return .create { observer in
            self.observe(to: to, repeat: `repeat`) { object in
                observer.onNext(object)
            }
            return Disposables.create {
                self.dispose(to: to)
            }
        }
    }
}

extension Reactive where Base: NotificationManagerType {
    
    func post<T, N: Notification<T>>(_ notification: N) -> Binder<N> {
        Binder(self.base) { manager, notification in
            manager.post(notification)
        }
    }
}
