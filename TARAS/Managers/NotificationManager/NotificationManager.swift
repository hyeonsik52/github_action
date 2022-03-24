//
//  NotificationManager.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/30.
//

import Foundation

class Notification<T: Hashable>: Equatable {
    
    static var name: String {
        return "\(self)"
    }
    
    let object: T
    
    required init(_ object: T) {
        self.object = object
    }
    
    static func ==(lhs: Notification, rhs: Notification) -> Bool {
        return (type(of: lhs) == type(of: rhs) && lhs.object.hashValue == rhs.object.hashValue)
    }
}

class NotificationManager: BaseManager, NotificationManagerType {
    
    class NotificationStorageItem<T: Hashable, N: Notification<T>> {
        
        private let lock = NSLock()
        private var token: NSObjectProtocol!
        
        private var storage = [AnyObject]()
        private var closures: [ObserveClosure<T>]
        
        var isInvalidated = false
        
        var stacked: [N] {
            guard !self.isInvalidated else { return [] }
            return self.storage as! [N]
        }
        
        init(queue: OperationQueue, closure: @escaping ObserveClosure<T>) {
            self.closures = [closure]
            self.token = NotificationCenter.default.addObserver(
                forName: .init(rawValue: N.name),
                object: nil,
                queue: queue,
                using: { [weak self] notification in
                    guard let self = self,
                          !self.isInvalidated,
                          let object = notification.object as? T else { return }
                    self.lock.lock(); defer { self.lock.unlock() }
                    Log.debug("\(#function): \(N.name): received: \(object)")
                    let notification = N.init(object)
                    self.storage.insert(notification, at: 0)
                    self.closures.forEach { $0(object) }
                }
            )
        }
        
        func add(closure: @escaping ObserveClosure<T>) {
            self.lock.lock(); defer { self.lock.unlock() }
            guard !self.isInvalidated else { return }
            self.closures.append(closure)
        }
        
        func invalidate() {
            self.lock.lock(); defer { self.lock.unlock() }
            NotificationCenter.default.removeObserver(self.token!)
            self.storage.removeAll()
            self.closures.removeAll()
            self.token = nil
            self.isInvalidated = true
        }
    }
    
    private let lock = NSLock()
    private let queue = OperationQueue()
    private var storage = [String: AnyObject]()
    
    private func convertedStorageItem<T: Hashable, N: Notification<T>>(_ type: N.Type) -> NotificationStorageItem<T, N>? {
        return self.storage[N.name] as? NotificationStorageItem<T, N>
    }
    
    func observe<T, N: Notification<T>>(
        to: N.Type, repeat: Int = 0,
        _ closure: @escaping ObserveClosure<T>
    ) {
        self.lock.lock(); defer { self.lock.unlock() }
        let storageItem = self.convertedStorageItem(N.self)
        if `repeat` > 0, let unwrapped = storageItem {
            unwrapped.stacked.enumerated().forEach {
                guard $0.0 < `repeat` else { return }
                closure($0.1.object)
            }
        }
        if let unwrapped = storageItem {
            unwrapped.add(closure: closure)
        } else {
            self.storage[N.name] = NotificationStorageItem<T, N>(queue: self.queue, closure: closure)
        }
        Log.debug("\(#function): \(to.name)")
    }
    
    func post<T: Hashable, N: Notification<T>>(_ notification: N) {
        if let existed = self.convertedStorageItem(N.self)?.stacked.first as? N, existed == notification {
            Log.debug("\(#function): \(N.name) is ignored")
            return
        }
        NotificationCenter.default.post(
            name: .init(rawValue: N.name),
            object: notification.object
        )
        Log.debug("\(#function): \(N.name)")
    }
    
    func dispose<T, N: Notification<T>>(to: N.Type) {
        self.lock.lock(); defer { self.lock.unlock() }
        guard let existed = self.convertedStorageItem(N.self) else { return }
        existed.invalidate()
        self.storage.removeValue(forKey: N.name)
        Log.debug("\(#function): \(to.name)")
    }
}

final class AddOrUpdateServiceUnit: Notification<ServiceUnitCreationModel> {}
final class UpdateService: Notification<Service> {}
