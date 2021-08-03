//
//  RxSwift+Operator.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/08/11.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    ///일정 개수만큼의 공간을 할당하고, 뒤에서 앞으로 쌓으면서 밀려나는 큐
    public func queueing(_ n: Int) -> Observable<[Element]> {
        return self.scan([]) { acc, item in Array((acc + [item]).suffix(n)) }.filter { $0.count == n }
    }
    
    /// takeWhileWithIndex
    public func takeWhile(with index: Int) -> Observable<Element> {
        return self.enumerated().takeWhile { $0.index < index }.map { $0.element }
    }
}
