////
////  ServiceManager.swift
////  TARAS-2.0
////
////  Created by nexmond on 2021/01/12.
////
//
//import UIKit
//
//protocol ServiceManagerType: AnyObject {
//    func convert(service: ServiceFragment) -> Service?
//    func convert(log json: [String: Any]) -> ServiceLog?
//}
//
//class ServiceManager: BaseManager, ServiceManagerType {
//
//    private let dateFormatter = ISO8601DateFormatter()
//
//    func convert(service: ServiceFragment) -> Service? {
//        guard let createdAt = self.dateFormatter.date(from: service.createdAt) else {
//            return nil
//        }
////
////        let tempTemplate = ServiceTemplate(idx: -1, code: "coffee", name: "커피 주문")
////        let robot = Robot(result: service.assignedRobot?.asRwsRobot?.fragments.robotFragment)
////
////        let serviceUnits = service.serviceUnits
////            .compactMap { $0.fragments.serviceUnitFragment }
////            .compactMap { ServiceUnit(result: $0, with: self.provider.userManager) }
////
////        let progressDescription: NSMutableAttributedString? = {
////            guard let processing = serviceUnits.last(where: { $0.status == .moving || $0.status == .stop || $0.status == .working }) else { return nil }
////            let text: String? = (processing.status == .moving ? "(으)로 이동 중입니다":
////                                    ((processing.status == .stop || processing.status == .working) ? "에 도착했습니다.": nil))
////            if let rear = text {
////                let attributed = NSMutableAttributedString(
////                    string: "'\(processing.stop.name)'\(rear)",
////                    attributes: [
////                        .font: UIFont.medium[14],
////                        .foregroundColor: UIColor.black
////                    ]
////                )
////                attributed.addAttribute(
////                    .foregroundColor,
////                    value: .purple4A3C9F,
////                    range: .init(location: 0, length: processing.stop.name.utf16.count+2)
////                )
////                return attributed
////            }
////            return nil
////        }()
////
////        return .init(
////            idx: service.serviceIdx,
////            template: tempTemplate,
////            status: .init(raw: service.status),
////            serviceId: service.serviceNum,
////            createAt: createAt,
////            robot: robot,
////            serviceUnits: serviceUnits,
////            progressDescription: progressDescription
////        )
//        return nil
//    }
//
//    func convert(log json: [String: Any]) -> ServiceLog? {
////
////        let content: NSAttributedString = {
////            switch type {
////            case .created:
////                let userName = log.user?.asUser?.fragments.userFragment.name ?? "알 수 없는 사용자"
////                let attributed = NSMutableAttributedString(
////                    string: "\(userName)님이 서비스를 생성하였습니다.",
////                    attributes: [
////                        .font: UIFont.medium[16],
////                        .foregroundColor: UIColor.black
////                    ]
////                )
////                attributed.addAttribute(
////                    .foregroundColor,
////                    value: .purple4A3C9F,
////                    range: .init(location: 0, length: userName.utf16.count)
////                )
////                return attributed
////            case .robotAssigned:
////                return .init(
////                    string: "로봇이 배정되었습니다. 서비스가 시작되었습니다.",
////                    attributes: [
////                        .font: UIFont.medium[16],
////                        .foregroundColor: UIColor.black
////                    ]
////                )
////            case .arrived:
////                let stopName = log.serviceUnit?.asServiceUnit?.fragments.serviceUnitFragment
////                    .stop?.asStop?.fragments.stopFragment.name ?? "알 수 없는 위치"
////                let attributed = NSMutableAttributedString(
////                    string: "로봇이 \(stopName)에 도착하였습니다.",
////                    attributes: [
////                        .font: UIFont.medium[16],
////                        .foregroundColor: UIColor.black
////                    ]
////                )
////                attributed.addAttribute(
////                    .foregroundColor,
////                    value: .purple4A3C9F,
////                    range: .init(location: 4, length: stopName.utf16.count)
////                )
////                return attributed
////            case .workComplete:
////                let serviceUnit = log.serviceUnit?.asServiceUnit?.fragments.serviceUnitFragment
////                let isLoadingType = serviceUnit?.station?.asStation?.stationType == .some(.loading)
////                if isLoadingType {
////                    return .init(
////                        string: "로봇이 상하차 작업을 완료하였습니다.",
////                        attributes: [
////                            .font: UIFont.medium[16],
////                            .foregroundColor: UIColor.black
////                        ]
////                    )
////                }else{
////                    let userName = log.user?.asUser?.fragments.userFragment.name ?? "알 수 없는 사용자"
////                    let attributed = NSMutableAttributedString(
////                        string: "\(userName)님이 작업을 완료하였습니다.",
////                        attributes: [
////                            .font: UIFont.medium[16],
////                            .foregroundColor: UIColor.black
////                        ]
////                    )
////                    attributed.addAttribute(
////                        .foregroundColor,
////                        value: .purple4A3C9F,
////                        range: .init(location: 0, length: userName.utf16.count)
////                    )
////                    return attributed
////                }
////            case .complete:
////                return .init(
////                    string: "서비스가 완료되었습니다.",
////                    attributes: [
////                        .font: UIFont.medium[16],
////                        .foregroundColor: UIColor.black
////                    ]
////                )
////            case .canceled:
////                return .init(
////                    string: "관리자에 의해 서비스가 중단되었습니다.",
////                    attributes: [
////                        .font: UIFont.medium[16],
////                        .foregroundColor: .redEc5C4A
////                    ]
////                )
////            case .error(let error):
////                return .init(
////                    string: error.description,
////                    attributes: [
////                        .font: UIFont.medium[16],
////                        .foregroundColor: .redEc5C4A
////                    ]
////                )
////            }
////        }()
////
////        return .init(
////            idx: log.serviceLogIdx,
////            type: type,
////            date: date,
////            content: content
////        )
//        return nil
//    }
//}
//
//extension ServiceManagerType {
//
//    var dummyServices: [Service] {
//
////        let template = ServiceTemplate(idx: -1, code: "coffee", name: "커피 주문")
////        let serviceId = "20210131"
////        let date = Date()
////        let robot = Robot(id: "robot-1", name: "로봇1")
////
////        func serviceUnits(
////            first: ServiceUnitStatus,
////            second: ServiceUnitStatus,
////            firstIsMe: Bool = true
////        ) -> [ServiceUnit] {
////            return [
////                .init(
////                    idx: 0,
////                    status: first,
////                    requestAt: date,
////                    stop: .init(idx: 0, name: "33층 카페"),
////                    worker: .init(idx: 0, name: "카페매니저", isMe: firstIsMe),
////                    requestContent: "아이스 카페라떼 1잔, 따뜻한 아메리카노 5잔 가져다주세요."
////                ),
////                .init(
////                    idx: 1,
////                    status: second,
////                    requestAt: date,
////                    stop: .init(idx: 0, name: "내 좌석"),
////                    worker: .init(idx: 0, name: "나", isMe: !firstIsMe),
////                    requestContent: ""
////                )
////            ]
////        }
////
////        let robotAssigning = Service(
////            idx: 0,
////            template: template,
////            status: .robotAssigning,
////            serviceId: serviceId,
////            createAt: date,
////            robot: nil,
////            serviceUnits: serviceUnits(first: .waiting, second: .waiting),
////            progressDescription: nil
////        )
////
////        let waiting = Service(
////            idx: 0,
////            template: template,
////            status: .waiting,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .waiting, second: .waiting),
////            progressDescription: nil
////        )
////
////        let waitingToMove = Service(
////            idx: 0,
////            template: template,
////            status: .waiting,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .waitingToMove, second: .waiting),
////            progressDescription: nil
////        )
////
////        let moving = Service(
////            idx: 0,
////            template: template,
////            status: .moving,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .moving, second: .waiting),
////            progressDescription: nil
////        )
////
////        let arrived = Service(
////            idx: 0,
////            template: template,
////            status: .arrived,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .stop, second: .waiting),
////            progressDescription: nil
////        )
////
////        let working = Service(
////            idx: 0,
////            template: template,
////            status: .arrived,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .working, second: .waiting),
////            progressDescription: nil
////        )
////
////        let completed = Service(
////            idx: 0,
////            template: template,
////            status: .completed,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .completed, second: .waiting),
////            progressDescription: nil
////        )
////
////        let robotAssigning2 = Service(
////            idx: 0,
////            template: template,
////            status: .robotAssigning,
////            serviceId: serviceId,
////            createAt: date,
////            robot: nil,
////            serviceUnits: serviceUnits(first: .completed, second: .waiting, firstIsMe: false),
////            progressDescription: nil
////        )
////
////        let waiting2 = Service(
////            idx: 0,
////            template: template,
////            status: .waiting,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .completed, second: .waiting, firstIsMe: false),
////            progressDescription: nil
////        )
////
////        let waitingToMove2 = Service(
////            idx: 0,
////            template: template,
////            status: .waiting,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .completed, second: .waitingToMove, firstIsMe: false),
////            progressDescription: nil
////        )
////
////        let moving2 = Service(
////            idx: 0,
////            template: template,
////            status: .moving,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .completed, second: .moving, firstIsMe: false),
////            progressDescription: nil
////        )
////
////        let arrived2 = Service(
////            idx: 0,
////            template: template,
////            status: .arrived,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .completed, second: .stop, firstIsMe: false),
////            progressDescription: nil
////        )
////
////        let working2 = Service(
////            idx: 0,
////            template: template,
////            status: .arrived,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .completed, second: .working, firstIsMe: false),
////            progressDescription: nil
////        )
////
////        let completed2 = Service(
////            idx: 0,
////            template: template,
////            status: .completed,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .completed, second: .completed, firstIsMe: false),
////            progressDescription: nil
////        )
////
////        let terminated = Service(
////            idx: 0,
////            template: template,
////            status: .terminated,
////            serviceId: serviceId,
////            createAt: date,
////            robot: robot,
////            serviceUnits: serviceUnits(first: .canceled, second: .canceled, firstIsMe: false),
////            progressDescription: nil
////        )
//
//        return [
////            robotAssigning, waiting, waitingToMove, moving, arrived, working, completed,
////            robotAssigning2, waiting2, waitingToMove2, moving2, arrived2, working2, completed2,
////            terminated
//        ]
//    }
//
//    var dummyLogs: [ServiceLog] {
//        return []
//    }
//}
