//
//  TypeUnification.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

//protocol ServiceType {
//    var serviceIdx: Int { get set }
//    var createAt: String { get set }
//    var centralAlsName: String? { get set }
//    var deliveryStatus: DeliveryStatus { get set }
//    var destinationStopName: String? { get set }
//    var estimatedMinutesOfArrival: Int { get set }
//
//    var robot: RobotType? { get }
//    var mailBox: RobotAddOnMailboxType? { get }
//    var post: ParcelType { get }
//    var serviceUnitList: [ServiceUnitType] { get }
//}
//
//protocol RobotType {
//    var name: String { get set }
//}
//
//protocol RobotAddOnMailboxType {
//    var doorState: RobotAddOnMailboxDoorState { get set }
//    var parcelIdx: Int? { get set }
//    var name: String { get set }
//}
//
//protocol ParcelType {
//    var parcelIdx: Int { get set }
//    var createAt: String { get set }
//}
//
//protocol ServiceUnitType {
//    var stopIdx: Int? { get set }
//    var serviceUnitIdx: Int { get set }
//    var targetType: ServiceUnitTargetType { get set }
//    var status: ServiceUnitStatus { get set }
//}
//
//protocol LogType {
//    var idx: Int { get }
//    var logType: ServiceLogType? { get }
//    var createdAt: String? { get }
//    var post: ParcelType? { get }
//    var robotError: RobotErrorCode? { get }
//    var robotStatus: RobotStatus? { get }
//    var stopType: StopType? { get }
//}
//
////-------------------------------------------------------------------------------------------------
//
//extension ServiceInfo: ServiceType {
//    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
//    var post: ParcelType { self.parcel }
//    var mailBox: RobotAddOnMailboxType? { self.assignedMailbox }
//    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
//}
//extension ServiceInfo.ServiceUnit: ServiceUnitType {}
//extension ServiceInfo.Parcel: ParcelType {}
//extension ServiceInfo.AssignedRobot.AsRwsRobot: RobotType {}
//extension ServiceInfo.AssignedMailbox: RobotAddOnMailboxType {}
//
//
//extension ServiceLogInfo: LogType {
//    var idx: Int { self.serviceLogIdx }
//    var logType: ServiceLogType? { self.type }
//    var createdAt: String? { self.createAt }
//    var post: ParcelType? { self.service.asService?.parcel }
//    var robotError: RobotErrorCode? { self.service.asService?.assignedRobot?.asRobotError?.errorCode }
//    var robotStatus: RobotStatus? { self.service.asService?.assignedRobot?.asRwsRobot?.status }
//    var stopType: StopType? { self.serviceUnit?.asServiceUnit?.stopType }
//}
//extension ServiceLogInfo.Service.AsService.Parcel: ParcelType {}
