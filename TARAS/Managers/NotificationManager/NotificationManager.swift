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
    
    private let queue = OperationQueue()
    private let lock = NSLock()
    private var storage = [AnyObject]()
    private var tokenStorage = [String: NSObjectProtocol]()
    
    func observe<T, N: Notification<T>>(
        to: N.Type, repeat: Int = 0,
        _ closure: @escaping ObserveClosure<T>
    ) {
        self.lock.lock(); defer { self.lock.unlock() }
        if `repeat` > 0, let stacked = self.storage.filter({ $0 is N }) as? [N] {
            stacked.enumerated().forEach {
                guard $0.0 < `repeat` else { return }
                closure($0.1.object)
            }
        }
        self.tokenStorage[N.name] = NotificationCenter.default.addObserver(
            forName: .init(rawValue: to.name),
            object: nil,
            queue: self.queue,
            using: { [weak self] notification in
                guard let self = self,
                      let object = notification.object as? T else { return }
                self.lock.lock(); defer { self.lock.unlock() }
                Log.debug("\(#function): \(to.name): received: \(object)")
                let notification = N.init(object)
                self.storage.insert(notification, at: 0)
                closure(object)
            }
        )
        Log.debug("\(#function): \(to.name)")
    }
    
    func post<T: Hashable, N: Notification<T>>(_ notification: N) {
        if let existed = self.storage.first as? N, existed == notification {
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
        guard let token = self.tokenStorage[N.name] else { return }
        NotificationCenter.default.removeObserver(token)
        self.tokenStorage.removeValue(forKey: N.name)
        self.storage.removeAll(where: { ($0 as? N) != nil })
        Log.debug("\(#function): \(to.name)")
    }
}

final class AddOrUpdateServiceUnit: Notification<ServiceUnitCreationModel> {}
final class UpdateService: Notification<Service> {}

final class ToggleServiceUnit: Notification<ToggleServiceUnitType> {}
struct ToggleServiceUnitType: Hashable {
    var serviceUnit: ServiceUnit
    var isOpened: Bool
    
    static func ==(lhs: ToggleServiceUnitType, rhs: ToggleServiceUnitType) -> Bool {
        return (lhs.serviceUnit == rhs.serviceUnit && lhs.isOpened == rhs.isOpened)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.serviceUnit)
        hasher.combine(self.isOpened)
    }
}
