//
//  ServiceUnitCreationModel.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import Foundation

struct ServiceUnitCreationModel: Identifiable {
    
    enum StopState {
        case isWait(Bool)
        case isLoading(Bool)
        
        var hash: Int {
            switch self {
            case .isWait(let value):
                return 1 << (value ? 1: 0)
            case .isLoading(let value):
                return (1 << 2) << (value ? 1: 0)
            }
        }
        
        static func title(_ closure: (Bool) -> Self) -> String {
            switch closure(true) {
            case .isWait:
                return "작업대기"
            case .isLoading:
                return "상/하차"
            }
        }
        
        static var waitableTitle: String {
            return self.title(Self.isWait)
        }
        static var loadableTitle: String {
            return self.title(Self.isLoading)
        }
        
        var isWaitable: Bool {
            return (self.isWaitValue != nil)
        }
        
        var isLoadable: Bool {
            return (self.isLoadingValue != nil)
        }
        
        var isWaitValue: Bool? {
            guard case .isWait(let value) = self else { return nil }
            return value
        }
        
        var isLoadingValue: Bool? {
            guard case .isLoading(let value) = self else { return nil }
            return value
        }
    }
    
    //immutable
    let id: String = UUID().uuidString
    
    //required
    var stop: ServiceUnitTargetModel! = nil
    var stopState: StopState? = nil
    
    //optional
    var receivers: [ServiceUnitTargetModel] = []
    var detail: String? = nil
}

extension ServiceUnitCreationModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.stop)
        hasher.combine(self.receivers)
        hasher.combine(self.detail)
        hasher.combine(self.stopState?.hash ?? 0)
    }
}

extension ServiceUnitCreationModel {
    
    mutating func updateStopState(with process: STProcess) {
        //템플릿에서 서비스 타입이 로딩인지 확인
        if process.isServiceTypeLS {
            let isNotLoading = process.peek(with: "loading_command")?.asArgument?.ui.asComponent(String.self)?.defaultValue == "UNLOAD"
            if stop.name.hasPrefix("LS") {
                //로딩이고 정차지가 LS이면 상/하차 표시
                self.stopState = .isLoading(!isNotLoading)
            } else {
                //로딩이고 정차지가 일반이면 표시하지 앟음
                self.stopState = nil
            }
        } else {
            //로딩이 아니면 작업대기 표시
            if let isWaitArgs = process.peek(with: "is_waited")?.asArgument {
                let isWait = isWaitArgs.ui.asComponent(Bool.self)?.defaultValue ?? false
                self.stopState = .isWait(isWait)
            } else {
                self.stopState = nil
            }
        }
    }
}
