//
//  SimplificationGraphqlTypes.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/04.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import Foundation

typealias CreatedServices = CreatedServicesConnectionQuery
extension CreatedServicesConnectionQuery {
    typealias Service = Data.CreatedServicesConnection.Edge.Node
    typealias Creator = Service.CreatorUser.AsUser
    typealias CreatorSWSInfo = Creator.UserSwsInfo.AsUserSwsInfo
    typealias CreatorSWSInfoGroup = CreatorSWSInfo.GroupsConnection.Edge.Node
    typealias ServiceUnit = Service.ServiceUnit
    typealias Target = ServiceUnit.Target
    typealias TargetUser = ServiceUnit.Target.AsUser
    typealias TargetUserSWSInfo = TargetUser.UserSwsInfo.AsUserSwsInfo
    typealias TargetUserGroup = TargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias TargetGroup = ServiceUnit.Target.AsGroup
    typealias TargetStop = ServiceUnit.Target.AsStop
    typealias Worker = ServiceUnit.WorkerUser.AsUser
    
    typealias Acceptor = ServiceUnit.Acceptor
    typealias AcceptorUser = Acceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias AcceptorUserSWSInfo = AcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias AcceptorGroup = Acceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias Rejector = ServiceUnit.RejectorUser
    typealias Stop = ServiceUnit.Stop.AsStop
    typealias Freight = ServiceUnit.Freight
    typealias Recipient = ServiceUnit.Recipient
    typealias RecipientUser = Recipient.AsServiceUnitRecipientUser.User.AsUser
    typealias RecipientUserSWSInfo = RecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias RecipientUserSWSInfoGroup = RecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias RecipientGroup = Recipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias Robot = Service.AssignedRobot.AsRwsRobot
    typealias Response = ServiceUnit.RecipientUserAndResponseList
    typealias ResponseUser = Response.User
    typealias ResponseUserSWSInfo = ResponseUser.UserSwsInfo.AsUserSwsInfo
}

typealias ReceivedServices = ReceivedServicesConnectionQuery
extension ReceivedServicesConnectionQuery {
    typealias Service = Data.ReceivedServicesConnection.Edge.Node
    typealias Creator = Service.CreatorUser.AsUser
    typealias CreatorSWSInfo = Creator.UserSwsInfo.AsUserSwsInfo
    typealias CreatorSWSInfoGroup = CreatorSWSInfo.GroupsConnection.Edge.Node
    typealias ServiceUnit = Service.ServiceUnit
    typealias Target = ServiceUnit.Target
    typealias TargetUser = ServiceUnit.Target.AsUser
    typealias TargetUserSWSInfo = TargetUser.UserSwsInfo.AsUserSwsInfo
    typealias TargetUserGroup = TargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias TargetGroup = ServiceUnit.Target.AsGroup
    typealias TargetStop = ServiceUnit.Target.AsStop
    typealias Worker = ServiceUnit.WorkerUser.AsUser
    
    typealias Acceptor = ServiceUnit.Acceptor
    typealias AcceptorUser = Acceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias AcceptorUserSWSInfo = AcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias AcceptorGroup = Acceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias Rejector = ServiceUnit.RejectorUser
    typealias Stop = ServiceUnit.Stop.AsStop
    typealias Freight = ServiceUnit.Freight
    typealias Recipient = ServiceUnit.Recipient
    typealias RecipientUser = Recipient.AsServiceUnitRecipientUser.User.AsUser
    typealias RecipientUserSWSInfo = RecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias RecipientUserSWSInfoGroup = RecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias RecipientGroup = Recipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias Robot = Service.AssignedRobot.AsRwsRobot
    typealias Response = ServiceUnit.RecipientUserAndResponseList
    typealias ResponseUser = Response.User
    typealias ResponseUserSWSInfo = ResponseUser.UserSwsInfo.AsUserSwsInfo
}

typealias SingleService = ServiceByServiceIdxQuery
extension ServiceByServiceIdxQuery {
    typealias Service = Data.ServiceByServiceIdx.AsService
    typealias Creator = Service.CreatorUser.AsUser
    typealias CreatorSWSInfo = Creator.UserSwsInfo.AsUserSwsInfo
    typealias CreatorSWSInfoGroup = CreatorSWSInfo.GroupsConnection.Edge.Node
    typealias ServiceUnit = Service.ServiceUnit
    typealias Target = ServiceUnit.Target
    typealias TargetUser = ServiceUnit.Target.AsUser
    typealias TargetUserSWSInfo = TargetUser.UserSwsInfo.AsUserSwsInfo
    typealias TargetUserGroup = TargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias TargetGroup = ServiceUnit.Target.AsGroup
    typealias TargetStop = ServiceUnit.Target.AsStop
    typealias Worker = ServiceUnit.WorkerUser.AsUser
    
    typealias Acceptor = ServiceUnit.Acceptor
    typealias AcceptorUser = Acceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias AcceptorUserSWSInfo = AcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias AcceptorGroup = Acceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias Rejector = ServiceUnit.RejectorUser
    typealias Stop = ServiceUnit.Stop.AsStop
    typealias Freight = ServiceUnit.Freight
    typealias Recipient = ServiceUnit.Recipient
    typealias RecipientUser = Recipient.AsServiceUnitRecipientUser.User.AsUser
    typealias RecipientUserSWSInfo = RecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias RecipientUserSWSInfoGroup = RecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias RecipientGroup = Recipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias Robot = Service.AssignedRobot.AsRwsRobot
    typealias Response = ServiceUnit.RecipientUserAndResponseList
    typealias ResponseUser = Response.User
    typealias ResponseUserSWSInfo = ResponseUser.UserSwsInfo.AsUserSwsInfo
}

typealias UserInfoes = UserByUserIdxQuery
extension UserByUserIdxQuery {
    typealias User = Data.UserByUserIdx.AsUser
    typealias SWSInfo = User.UserSwsInfo.AsUserSwsInfo
    typealias Group = SWSInfo.GroupsConnection.Edge.Node
    typealias ChargeStop = Group.StopsConnection.Edge.Node
    typealias Stop = SWSInfo.Stop.AsStop
    typealias GroupStop = SWSInfo.GroupStop.AsStop
}

typealias MyUserInfoes = MyUserInfoQuery
extension MyUserInfoQuery {
    typealias User = Data.MyUserInfo.AsUser
    typealias SWSInfo = User.UserSwsInfo.AsUserSwsInfo
    typealias Group = SWSInfo.GroupsConnection.Edge.Node
    typealias Stop = SWSInfo.Stop.AsStop
    typealias GroupStop = SWSInfo.GroupStop.AsStop
}

typealias UpdateUserInfo = UpdateUserInfoMutationMutation
extension UpdateUserInfoMutationMutation {
    typealias User = Data.UpdateUserInfoMutation.AsUser
    typealias Error = Data.UpdateUserInfoMutation.AsUpdateUserInfoError
    typealias SWSInfo = User.UserSwsInfo.AsUserSwsInfo
    typealias Group = SWSInfo.GroupsConnection.Edge.Node
    typealias Stop = SWSInfo.Stop.AsStop
    typealias GroupStop = SWSInfo.GroupStop.AsStop
}

typealias UpdateUserSWSInfo = UpdateUserSwsInfoMutationMutation
extension UpdateUserSwsInfoMutationMutation {
    typealias SWSInfo = Data.UpdateUserSwsInfoMutation.AsUserSwsInfo
    typealias Error = Data.UpdateUserSwsInfoMutation.AsUpdateUserSwsInfoError
    typealias Group = SWSInfo.GroupsConnection.Edge.Node
    typealias Stop = SWSInfo.Stop.AsStop
    typealias GroupStop = SWSInfo.GroupStop.AsStop
}

typealias UpdateUserSWSInfoStop = UpdateUserSwsInfoStopMutationMutation
extension UpdateUserSwsInfoStopMutationMutation {
    typealias SWSInfo = Data.UpdateUserSwsInfoStopMutation.AsUserSwsInfo
    typealias Error = Data.UpdateUserSwsInfoStopMutation.AsUpdateUserSwsInfoStopError
    typealias Group = SWSInfo.GroupsConnection.Edge.Node
    typealias Stop = SWSInfo.Stop.AsStop
    typealias GroupStop = SWSInfo.GroupStop.AsStop
}

typealias SWSInfo = SwsBySwsIdxQuery
extension SwsBySwsIdxQuery {
    typealias SWS = Data.SwsBySwsIdx.AsSws
    typealias EnvMap = SWS.EnvMap
}

typealias SWSStops = SwsStopsConnectionQuery
extension SwsStopsConnectionQuery {
    typealias Stop = Data.SwsStopsConnection.Edge.Node
}

typealias MySWSStops = SwsStopsToSetMyStopConnectionQuery
extension SwsStopsToSetMyStopConnectionQuery {
    typealias Stop = Data.SwsStopsToSetMyStopConnection.Edge.Node
}

typealias ServiceLogs = ServiceLogsByServiceIdxConnectionQuery
extension ServiceLogsByServiceIdxConnectionQuery {
    typealias Log = Data.ServiceLogsByServiceIdxConnection.Edge.Node
    typealias User = Log.User.AsUser
    typealias UserSWSInfo = User.UserSwsInfo.AsUserSwsInfo
    typealias Service = Log.Service.AsService
    typealias Creator = Service.CreatorUser.AsUser
    typealias CreatorSWSInfo = Creator.UserSwsInfo.AsUserSwsInfo
    typealias CreatorSWSInfoGroup = CreatorSWSInfo.GroupsConnection.Edge.Node
    typealias Robot = Service.AssignedRobot.AsRwsRobot
    typealias ServiceUnit = Service.ServiceUnit
    typealias Target = ServiceUnit.Target
    typealias TargetUser = ServiceUnit.Target.AsUser
    typealias TargetUserSWSInfo = TargetUser.UserSwsInfo.AsUserSwsInfo
    typealias TargetUserGroup = TargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias TargetGroup = ServiceUnit.Target.AsGroup
    typealias TargetStop = ServiceUnit.Target.AsStop
    typealias Worker = ServiceUnit.WorkerUser.AsUser
    
    typealias Acceptor = ServiceUnit.Acceptor
    typealias AcceptorUser = Acceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias AcceptorUserSWSInfo = AcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias AcceptorGroup = Acceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias Rejector = ServiceUnit.RejectorUser
    typealias Stop = ServiceUnit.Stop.AsStop
    typealias Freight = ServiceUnit.Freight
    typealias Recipient = ServiceUnit.Recipient
    typealias RecipientUser = Recipient.AsServiceUnitRecipientUser.User.AsUser
    typealias RecipientUserSWSInfo = RecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias RecipientUserSWSInfoGroup = RecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias RecipientGroup = Recipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias ServiceServiceUnit = Log.ServiceUnit.AsServiceUnit
}

typealias ServiceBySwsIdxSubscription = ServiceBySwsIdxSubscriptionSubscription
extension ServiceBySwsIdxSubscriptionSubscription {
    typealias CreatedService = Data.ServiceBySwsIdxSubscription.AsServiceCreated.Item
    typealias CreatedCreator = CreatedService.CreatorUser.AsUser
    typealias CreatedCreatorSWSInfo = CreatedCreator.UserSwsInfo.AsUserSwsInfo
    typealias CreatedCreatorSWSInfoGroup = CreatedCreatorSWSInfo.GroupsConnection.Edge.Node
    typealias CreatedServiceUnit = CreatedService.ServiceUnit
    typealias CreatedTarget = CreatedServiceUnit.Target
    typealias CreatedTargetUser = CreatedServiceUnit.Target.AsUser
    typealias CreatedTargetUserSWSInfo = CreatedTargetUser.UserSwsInfo.AsUserSwsInfo
    typealias CreatedTargetUserGroup = CreatedTargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias CreatedTargetGroup = CreatedServiceUnit.Target.AsGroup
    typealias CreatedTargetStop = CreatedServiceUnit.Target.AsStop
    typealias CreatedWorker = CreatedServiceUnit.WorkerUser.AsUser
    
    typealias CreatedAcceptor = CreatedServiceUnit.Acceptor
    typealias CreatedAcceptorUser = CreatedAcceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias CreatedAcceptorUserSWSInfo = CreatedAcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias CreatedAcceptorGroup = CreatedAcceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias CreatedRejector = CreatedServiceUnit.RejectorUser
    typealias CreatedStop = CreatedServiceUnit.Stop.AsStop
    typealias CreatedFreight = CreatedServiceUnit.Freight
    typealias CreatedRecipient = CreatedServiceUnit.Recipient
    typealias CreatedRecipientUser = CreatedRecipient.AsServiceUnitRecipientUser.User.AsUser
    typealias CreatedRecipientUserSWSInfo = CreatedRecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias CreatedRecipientUserSWSInfoGroup = CreatedRecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias CreatedRecipientGroup = CreatedRecipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias CreatedRobot = CreatedService.AssignedRobot.AsRwsRobot
    typealias CreatedResponse = CreatedServiceUnit.RecipientUserAndResponseList
    typealias CreatedResponseUser = CreatedResponse.User
    typealias CreatedResponseUserSWSInfo = CreatedResponseUser.UserSwsInfo.AsUserSwsInfo
    
    typealias UpdatedService = Data.ServiceBySwsIdxSubscription.AsServiceUpdated.Item
    typealias UpdatedCreator = UpdatedService.CreatorUser.AsUser
    typealias UpdatedCreatorSWSInfo = UpdatedCreator.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedCreatorSWSInfoGroup = UpdatedCreatorSWSInfo.GroupsConnection.Edge.Node
    typealias UpdatedServiceUnit = UpdatedService.ServiceUnit
    typealias UpdatedTarget = UpdatedServiceUnit.Target
    typealias UpdatedTargetUser = UpdatedServiceUnit.Target.AsUser
    typealias UpdatedTargetUserSWSInfo = UpdatedTargetUser.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedTargetUserGroup = UpdatedTargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias UpdatedTargetGroup = UpdatedServiceUnit.Target.AsGroup
    typealias UpdatedTargetStop = UpdatedServiceUnit.Target.AsStop
    typealias UpdatedWorker = UpdatedServiceUnit.WorkerUser.AsUser
    
    typealias UpdatedAcceptor = UpdatedServiceUnit.Acceptor
    typealias UpdatedAcceptorUser = UpdatedAcceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias UpdatedAcceptorUserSWSInfo = UpdatedAcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedAcceptorGroup = UpdatedAcceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias UpdatedRejector = UpdatedServiceUnit.RejectorUser
    typealias UpdatedStop = UpdatedServiceUnit.Stop.AsStop
    typealias UpdatedFreight = UpdatedServiceUnit.Freight
    typealias UpdatedRecipient = UpdatedServiceUnit.Recipient
    typealias UpdatedRecipientUser = UpdatedRecipient.AsServiceUnitRecipientUser.User.AsUser
    typealias UpdatedRecipientUserSWSInfo = UpdatedRecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedRecipientUserSWSInfoGroup = UpdatedRecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias UpdatedRecipientGroup = UpdatedRecipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias UpdatedRobot = UpdatedService.AssignedRobot.AsRwsRobot
    typealias UpdatedResponse = UpdatedServiceUnit.RecipientUserAndResponseList
    typealias UpdatedResponseUser = UpdatedResponse.User
    typealias UpdatedResponseUserSWSInfo = UpdatedResponseUser.UserSwsInfo.AsUserSwsInfo
    
    typealias DeletedService = Data.ServiceBySwsIdxSubscription.AsServiceDeleted
}

typealias ReceivedServiceSubscription = ReceivedServiceSubscriptionSubscription
extension ReceivedServiceSubscriptionSubscription {
    typealias CreatedService = Data.ReceivedServiceSubscription.AsServiceCreated.Item
    typealias CreatedCreator = CreatedService.CreatorUser.AsUser
    typealias CreatedCreatorSWSInfo = CreatedCreator.UserSwsInfo.AsUserSwsInfo
    typealias CreatedCreatorSWSInfoGroup = CreatedCreatorSWSInfo.GroupsConnection.Edge.Node
    typealias CreatedServiceUnit = CreatedService.ServiceUnit
    typealias CreatedTarget = CreatedServiceUnit.Target
    typealias CreatedTargetUser = CreatedServiceUnit.Target.AsUser
    typealias CreatedTargetUserSWSInfo = CreatedTargetUser.UserSwsInfo.AsUserSwsInfo
    typealias CreatedTargetUserGroup = CreatedTargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias CreatedTargetGroup = CreatedServiceUnit.Target.AsGroup
    typealias CreatedTargetStop = CreatedServiceUnit.Target.AsStop
    typealias CreatedWorker = CreatedServiceUnit.WorkerUser.AsUser
    
    typealias CreatedAcceptor = CreatedServiceUnit.Acceptor
    typealias CreatedAcceptorUser = CreatedAcceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias CreatedAcceptorUserSWSInfo = CreatedAcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias CreatedAcceptorGroup = CreatedAcceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias CreatedRejector = CreatedServiceUnit.RejectorUser
    typealias CreatedStop = CreatedServiceUnit.Stop.AsStop
    typealias CreatedFreight = CreatedServiceUnit.Freight
    typealias CreatedRecipient = CreatedServiceUnit.Recipient
    typealias CreatedRecipientUser = CreatedRecipient.AsServiceUnitRecipientUser.User.AsUser
    typealias CreatedRecipientUserSWSInfo = CreatedRecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias CreatedRecipientUserSWSInfoGroup = CreatedRecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias CreatedRecipientGroup = CreatedRecipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias CreatedRobot = CreatedService.AssignedRobot.AsRwsRobot
    typealias CreatedResponse = CreatedServiceUnit.RecipientUserAndResponseList
    typealias CreatedResponseUser = CreatedResponse.User
    typealias CreatedResponseUserSWSInfo = CreatedResponseUser.UserSwsInfo.AsUserSwsInfo
    
    typealias UpdatedService = Data.ReceivedServiceSubscription.AsServiceUpdated.Item
    typealias UpdatedCreator = UpdatedService.CreatorUser.AsUser
    typealias UpdatedCreatorSWSInfo = UpdatedCreator.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedCreatorSWSInfoGroup = UpdatedCreatorSWSInfo.GroupsConnection.Edge.Node
    typealias UpdatedServiceUnit = UpdatedService.ServiceUnit
    typealias UpdatedTarget = UpdatedServiceUnit.Target
    typealias UpdatedTargetUser = UpdatedServiceUnit.Target.AsUser
    typealias UpdatedTargetUserSWSInfo = UpdatedTargetUser.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedTargetUserGroup = UpdatedTargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias UpdatedTargetGroup = UpdatedServiceUnit.Target.AsGroup
    typealias UpdatedTargetStop = UpdatedServiceUnit.Target.AsStop
    typealias UpdatedWorker = UpdatedServiceUnit.WorkerUser.AsUser
    
    typealias UpdatedAcceptor = UpdatedServiceUnit.Acceptor
    typealias UpdatedAcceptorUser = UpdatedAcceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias UpdatedAcceptorUserSWSInfo = UpdatedAcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedAcceptorGroup = UpdatedAcceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias UpdatedRejector = UpdatedServiceUnit.RejectorUser
    typealias UpdatedStop = UpdatedServiceUnit.Stop.AsStop
    typealias UpdatedFreight = UpdatedServiceUnit.Freight
    typealias UpdatedRecipient = UpdatedServiceUnit.Recipient
    typealias UpdatedRecipientUser = UpdatedRecipient.AsServiceUnitRecipientUser.User.AsUser
    typealias UpdatedRecipientUserSWSInfo = UpdatedRecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias UpdatedRecipientUserSWSInfoGroup = UpdatedRecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias UpdatedRecipientGroup = UpdatedRecipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias UpdatedRobot = UpdatedService.AssignedRobot.AsRwsRobot
    typealias UpdatedResponse = UpdatedServiceUnit.RecipientUserAndResponseList
    typealias UpdatedResponseUser = UpdatedResponse.User
    typealias UpdatedResponseUserSWSInfo = UpdatedResponseUser.UserSwsInfo.AsUserSwsInfo
    
    typealias DeletedService = Data.ReceivedServiceSubscription.AsServiceDeleted
}

typealias ServiceByServiceIdxSubscription = ServiceByServiceIdxSubscriptionSubscription
extension ServiceByServiceIdxSubscriptionSubscription {
    typealias Service = Data.ServiceByServiceIdxSubscription.AsService
    typealias Creator = Service.CreatorUser.AsUser
    typealias CreatorSWSInfo = Creator.UserSwsInfo.AsUserSwsInfo
    typealias CreatorSWSInfoGroup = CreatorSWSInfo.GroupsConnection.Edge.Node
    typealias ServiceUnit = Service.ServiceUnit
    typealias Target = ServiceUnit.Target
    typealias TargetUser = ServiceUnit.Target.AsUser
    typealias TargetUserSWSInfo = TargetUser.UserSwsInfo.AsUserSwsInfo
    typealias TargetUserGroup = TargetUserSWSInfo.GroupsConnection.Edge.Node
    typealias TargetGroup = ServiceUnit.Target.AsGroup
    typealias TargetStop = ServiceUnit.Target.AsStop
    typealias Worker = ServiceUnit.WorkerUser.AsUser
    
    typealias Acceptor = ServiceUnit.Acceptor
    typealias AcceptorUser = Acceptor.AsServiceUnitAcceptorUser.User.AsUser
    typealias AcceptorUserSWSInfo = AcceptorUser.UserSwsInfo.AsUserSwsInfo
    typealias AcceptorGroup = Acceptor.AsServiceUnitAcceptorGroup.Group.AsGroup
    
    typealias Rejector = ServiceUnit.RejectorUser
    typealias Stop = ServiceUnit.Stop.AsStop
    typealias Freight = ServiceUnit.Freight
    typealias Recipient = ServiceUnit.Recipient
    typealias RecipientUser = Recipient.AsServiceUnitRecipientUser.User.AsUser
    typealias RecipientUserSWSInfo = RecipientUser.UserSwsInfo.AsUserSwsInfo
    typealias RecipientUserSWSInfoGroup = RecipientUserSWSInfo.GroupsConnection.Edge.Node
    typealias RecipientGroup = Recipient.AsServiceUnitRecipientGroup.Group.AsGroup
    typealias Robot = Service.AssignedRobot.AsRwsRobot
    typealias Response = ServiceUnit.RecipientUserAndResponseList
    typealias ResponseUser = Response.User
    typealias ResponseUserSWSInfo = ResponseUser.UserSwsInfo.AsUserSwsInfo
}

//MARK: - Service -

protocol ServiceType {
    var serviceIdx: Int { set get }
    var createAt: String { set get }
    var status: ServiceStatus { set get }
    var previousStatus: ServiceStatus? { set get }
    var requestRobotAssignmentAt: String? { set get }
    var robotAssignAt: String? { set get }
    var completeAt: String? { set get }
    var serviceNum: String { set get }
    var retryTimeout: Int { set get }
    
    var creator: CreatorType? { get }
    var serviceUnitList: [ServiceUnitType] { get }
    var requestAt: String? { get }
    var beginAt: String? { get }
    var endAt: String? { get }
    var robot: RobotType? { get }
}
extension CreatedServices.Service: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}
extension ReceivedServices.Service: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}
extension SingleService.Service: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}
extension ServiceLogs.Service: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}

extension ServiceBySwsIdxSubscription.CreatedService: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}
extension ServiceBySwsIdxSubscription.UpdatedService: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}
extension ServiceBySwsIdxSubscription.DeletedService: ServiceType {
    var createAt: String { set {} get { "" } }
    var status: ServiceStatus { set {} get { .__unknown("") } }
    var previousStatus: ServiceStatus? { set {} get { nil } }
    var requestRobotAssignmentAt: String? { set {} get { nil } }
    var robotAssignAt: String? { set {} get { nil } }
    var completeAt: String? { set {} get { nil } }
    var serviceNum: String { set {} get { "" } }
    var retryTimeout: Int { set {} get { 0 } }
    var creator: CreatorType? { set {} get { nil } }
    var serviceUnitList: [ServiceUnitType]  { set {} get { [] } }
    var requestAt: String? { set {} get { nil } }
    var beginAt: String? { set {} get { nil } }
    var endAt: String? { set {} get { nil } }
    var robot: RobotType? { set {} get { nil } }
}
extension ReceivedServiceSubscription.CreatedService: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}
extension ReceivedServiceSubscription.UpdatedService: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}
extension ReceivedServiceSubscription.DeletedService: ServiceType {
    var createAt: String { set {} get { "" } }
    var status: ServiceStatus { set {} get { .__unknown("") } }
    var previousStatus: ServiceStatus? { set {} get { nil } }
    var requestRobotAssignmentAt: String? { set {} get { nil } }
    var robotAssignAt: String? { set {} get { nil } }
    var completeAt: String? { set {} get { nil } }
    var serviceNum: String { set {} get { "" } }
    var retryTimeout: Int { set {} get { 0 } }
    var creator: CreatorType? { set {} get { nil } }
    var serviceUnitList: [ServiceUnitType]  { set {} get { [] } }
    var requestAt: String? { set {} get { nil } }
    var beginAt: String? { set {} get { nil } }
    var endAt: String? { set {} get { nil } }
    var robot: RobotType? { set {} get { nil } }
}
extension ServiceByServiceIdxSubscription.Service: ServiceType {
    var creator: CreatorType? { self.creatorUser.asUser }
    var serviceUnitList: [ServiceUnitType] { self.serviceUnits }
    var requestAt: String? { self.createAt }
    var beginAt: String? { self.robotAssignAt }
    var endAt: String? { self.completeAt }
    var robot: RobotType? { self.assignedRobot?.asRwsRobot }
}


//MARK: - ServiceUnit -

protocol ServiceUnitType {
    var serviceUnitIdx: Int { set get }
    var message: String? { set get }
    var status: ServiceUnitStatus { set get }
    var targetType: ServiceUnitTargetType { set get }
    var completeAt: String? { set get }
    var responseType: ServiceUnitResponseType? { set get }
    
    var bypass: Bool { get }
    var recipientList: [RecipientType] { get }
    var worker: BaseUserType? { get }
    var acceptorList: [AcceptorType] { get }
    var rejectors: [BaseUserType] { get }
    var serviceStop: ServiceStopType? { get }
    var freightList: [FreightType] { get }
    var serviceTarget: ServiceTargetType? { get }
    var stopFixed: Bool { get }
    var amIReceiver: Bool { get }
    var responseList: [ServiceUnitUserResponseType] { get }
}
extension CreatedServices.ServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { self.recipientUserAndResponseList }
}
extension ReceivedServices.ServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { self.recipientUserAndResponseList }
}
extension SingleService.ServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { self.recipientUserAndResponseList }
}
extension ServiceLogs.ServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { [] }
}
extension ServiceLogs.ServiceServiceUnit: ServiceUnitType {
    var responseType: ServiceUnitResponseType? { set{} get{ nil } }
    var message: String? { set{} get{ nil } }
    var status: ServiceUnitStatus { set{} get{ .__unknown("") } }
    var targetType: ServiceUnitTargetType { set{} get{ .__unknown("") } }
    var completeAt: String? { set{} get{ nil } }
    
    var bypass: Bool { false }
    var recipientList: [RecipientType] { [] }
    var worker: BaseUserType? { nil }
    var acceptorList: [AcceptorType] { [] }
    var rejectors: [BaseUserType] { [] }
    var serviceStop: ServiceStopType? { nil }
    var freightList: [FreightType] { [] }
    var serviceTarget: ServiceTargetType? { nil }
    var stopFixed: Bool { false }
    var amIReceiver: Bool { false }
    var responseList: [ServiceUnitUserResponseType] { [] }
}

extension ServiceBySwsIdxSubscription.CreatedServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { [] }
}
extension ServiceBySwsIdxSubscription.UpdatedServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { [] }
}
extension ReceivedServiceSubscription.CreatedServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { [] }
}
extension ReceivedServiceSubscription.UpdatedServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { [] }
}
extension ServiceByServiceIdxSubscription.ServiceUnit: ServiceUnitType {
    var bypass: Bool { self.isBypass == "1" }
    var recipientList: [RecipientType] { self.recipients }
    var worker: BaseUserType? { self.workerUser?.asUser }
    var acceptorList: [AcceptorType] { self.acceptors }
    var rejectors: [BaseUserType] { self.rejectorUsers }
    var serviceStop: ServiceStopType? { self.stop?.asStop }
    var freightList: [FreightType] { self.freights }
    var serviceTarget: ServiceTargetType? { self.target }
    var stopFixed: Bool { self.isStopFixed == "1" }
    var amIReceiver: Bool { self.amIRecipient == "1" }
    var responseList: [ServiceUnitUserResponseType] { [] }
}


//MARK: - User -

protocol BaseTargetType {
    var id: String { set get }
    var name: String { set get }
    var profileImageUrl: String? { set get }
}
protocol BaseUserType: BaseTargetType {
    var userIdx: Int { set get }
}
protocol BaseStopType {
    var id: String { set get }
    var stopIdx: Int { set get }
    var name: String { set get }
    var profileImage: String? { set get }
}
extension BaseStopType {
    var profileImage: String? {
        set {}
        get { nil }
    }
}

//MARK: - Group -

protocol GroupType: BaseTargetType {
    var groupIdx: Int { set get }
    
    var stop: ServiceStopType? { get }
    var stopsInCharge: [ServiceStopType] { get }
}
extension GroupType {
    var stop: ServiceStopType? { nil }
    var stopsInCharge: [ServiceStopType] { [] }
}

extension CreatedServices.CreatorSWSInfoGroup: GroupType {}
extension CreatedServices.TargetUserGroup: GroupType {}
extension CreatedServices.RecipientUserSWSInfoGroup: GroupType {}
extension ReceivedServices.CreatorSWSInfoGroup: GroupType {}
extension ReceivedServices.TargetUserGroup: GroupType {}
extension ReceivedServices.RecipientUserSWSInfoGroup: GroupType {}
extension SingleService.CreatorSWSInfoGroup: GroupType {}
extension SingleService.TargetUserGroup: GroupType {}
extension SingleService.RecipientUserSWSInfoGroup: GroupType {}
extension ServiceLogs.CreatorSWSInfoGroup: GroupType {}
extension ServiceLogs.TargetUserGroup: GroupType {}
extension ServiceLogs.RecipientUserSWSInfoGroup: GroupType {}

extension ServiceBySwsIdxSubscription.CreatedCreatorSWSInfoGroup: GroupType {}
extension ServiceBySwsIdxSubscription.CreatedTargetUserGroup: GroupType {}
extension ServiceBySwsIdxSubscription.CreatedRecipientUserSWSInfoGroup: GroupType {}
extension ServiceBySwsIdxSubscription.UpdatedCreatorSWSInfoGroup: GroupType {}
extension ServiceBySwsIdxSubscription.UpdatedTargetUserGroup: GroupType {}
extension ServiceBySwsIdxSubscription.UpdatedRecipientUserSWSInfoGroup: GroupType {}
extension ReceivedServiceSubscription.CreatedCreatorSWSInfoGroup: GroupType {}
extension ReceivedServiceSubscription.CreatedTargetUserGroup: GroupType {}
extension ReceivedServiceSubscription.CreatedRecipientUserSWSInfoGroup: GroupType {}
extension ReceivedServiceSubscription.UpdatedCreatorSWSInfoGroup: GroupType {}
extension ReceivedServiceSubscription.UpdatedTargetUserGroup: GroupType {}
extension ReceivedServiceSubscription.UpdatedRecipientUserSWSInfoGroup: GroupType {}
extension ServiceByServiceIdxSubscription.CreatorSWSInfoGroup: GroupType {}
extension ServiceByServiceIdxSubscription.TargetUserGroup: GroupType {}
extension ServiceByServiceIdxSubscription.RecipientUserSWSInfoGroup: GroupType {}

extension UserInfoes.Group: GroupType {
    var stopsInCharge: [ServiceStopType] { self.stopsConnection.edges.compactMap{ $0.node } }
}
extension MyUserInfoes.Group: GroupType {
    var stopsInCharge: [ServiceStopType] { [] }
}
extension UpdateUserInfo.Group: GroupType {
    var stopsInCharge: [ServiceStopType] { [] }
}
extension UpdateUserSWSInfo.Group: GroupType {
    var stopsInCharge: [ServiceStopType] { [] }
}
extension UpdateUserSWSInfoStop.Group: GroupType {
    var stopsInCharge: [ServiceStopType] { [] }
}


//MARK: - Target -

protocol ServiceTargetType {
    var asTargetUser: TargetUserType? { get }
    var asTargetGroup: TargetGroupType? { get }
    var asTargetStop: TargetStopType? { get }
}
extension CreatedServices.Target: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}
extension ReceivedServices.Target: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}
extension SingleService.Target: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}
extension ServiceLogs.Target: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}

extension ServiceBySwsIdxSubscription.CreatedTarget: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}
extension ServiceBySwsIdxSubscription.UpdatedTarget: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}
extension ReceivedServiceSubscription.CreatedTarget: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}
extension ReceivedServiceSubscription.UpdatedTarget: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}
extension ServiceByServiceIdxSubscription.Target: ServiceTargetType {
    var asTargetUser: TargetUserType? { self.asUser }
    var asTargetGroup: TargetGroupType? { self.asGroup }
    var asTargetStop: TargetStopType? { self.asStop }
}

protocol TargetUserType: BaseUserType {
    var teamName: String? { get }
    var swsInfo: SWSInfoType? { get }
}
extension CreatedServices.TargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServices.TargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension SingleService.TargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceLogs.TargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}

extension ServiceBySwsIdxSubscription.CreatedTargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceBySwsIdxSubscription.UpdatedTargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.CreatedTargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.UpdatedTargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceByServiceIdxSubscription.TargetUser: TargetUserType {
    var teamName: String? { self.userSwsInfo?.asUserSwsInfo?.groupsConnection.edges.first?.node?.name }
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}

protocol TargetGroupType: BaseTargetType {
    var groupIdx: Int { set get }
}
extension CreatedServices.TargetGroup: TargetGroupType {}
extension CreatedServices.TargetUserGroup: TargetGroupType {}
extension ReceivedServices.TargetGroup: TargetGroupType {}
extension ReceivedServices.TargetUserGroup: TargetGroupType {}
extension SingleService.TargetGroup: TargetGroupType {}
extension SingleService.TargetUserGroup: TargetGroupType {}
extension ServiceLogs.TargetGroup: TargetGroupType {}
extension ServiceLogs.TargetUserGroup: TargetGroupType {}

extension ServiceBySwsIdxSubscription.CreatedTargetGroup: TargetGroupType {}
extension ServiceBySwsIdxSubscription.CreatedTargetUserGroup: TargetGroupType {}
extension ServiceBySwsIdxSubscription.UpdatedTargetGroup: TargetGroupType {}
extension ServiceBySwsIdxSubscription.UpdatedTargetUserGroup: TargetGroupType {}
extension ReceivedServiceSubscription.CreatedTargetGroup: TargetGroupType {}
extension ReceivedServiceSubscription.CreatedTargetUserGroup: TargetGroupType {}
extension ReceivedServiceSubscription.UpdatedTargetGroup: TargetGroupType {}
extension ReceivedServiceSubscription.UpdatedTargetUserGroup: TargetGroupType {}
extension ServiceByServiceIdxSubscription.TargetGroup: TargetGroupType {}
extension ServiceByServiceIdxSubscription.TargetUserGroup: TargetGroupType {}

protocol TargetStopType: BaseStopType {}
extension CreatedServices.TargetStop: TargetStopType {}
extension ReceivedServices.TargetStop: TargetStopType {}
extension SingleService.TargetStop: TargetStopType {}
extension ServiceLogs.TargetStop: TargetStopType {}

extension ServiceBySwsIdxSubscription.CreatedTargetStop: TargetStopType {}
extension ServiceBySwsIdxSubscription.UpdatedTargetStop: TargetStopType {}
extension ReceivedServiceSubscription.CreatedTargetStop: TargetStopType {}
extension ReceivedServiceSubscription.UpdatedTargetStop: TargetStopType {}
extension ServiceByServiceIdxSubscription.TargetStop: TargetStopType {}

//MARK: User
protocol LogUserType: BaseUserType {
    var swsInfo: SWSInfoType? { get }
}
extension ServiceLogs.User: LogUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}


//MARK: Creator

protocol CreatorType: BaseUserType {
    var swsInfo: SWSInfoType? { get }
}
extension CreatedServices.Creator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServices.Creator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension SingleService.Creator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceLogs.Creator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}

extension ServiceBySwsIdxSubscription.CreatedCreator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceBySwsIdxSubscription.UpdatedCreator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.CreatedCreator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.UpdatedCreator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceByServiceIdxSubscription.Creator: CreatorType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}


//MARK: - Worker -

protocol WorkerType: BaseUserType {}
extension CreatedServices.Worker: WorkerType {}
extension ReceivedServices.Worker: WorkerType {}
extension SingleService.Worker: WorkerType {}
extension ServiceLogs.Worker: WorkerType {}

extension ServiceBySwsIdxSubscription.CreatedWorker: WorkerType {}
extension ServiceBySwsIdxSubscription.UpdatedWorker: WorkerType {}
extension ReceivedServiceSubscription.CreatedWorker: WorkerType {}
extension ReceivedServiceSubscription.UpdatedWorker: WorkerType {}
extension ServiceByServiceIdxSubscription.Worker: WorkerType {}

//MARK: - Rejector -

protocol RejectorType: BaseUserType {}
extension CreatedServices.Rejector: RejectorType {}
extension ReceivedServices.Rejector: RejectorType {}
extension SingleService.Rejector: RejectorType {}
extension ServiceLogs.Rejector: RejectorType {}

extension ServiceBySwsIdxSubscription.CreatedRejector: RejectorType {}
extension ServiceBySwsIdxSubscription.UpdatedRejector: RejectorType {}
extension ReceivedServiceSubscription.CreatedRejector: RejectorType {}
extension ReceivedServiceSubscription.UpdatedRejector: RejectorType {}
extension ServiceByServiceIdxSubscription.Rejector: RejectorType {}


//MARK: - Recipient -

protocol RecipientType {
    var asRecipientUser: RecipientUserType? { get }
    var asRecipientGroup: RecipientGroupType? { get }
}
extension CreatedServices.Recipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}
extension ReceivedServices.Recipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}
extension SingleService.Recipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}
extension ServiceLogs.Recipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}

extension ServiceBySwsIdxSubscription.CreatedRecipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}
extension ServiceBySwsIdxSubscription.UpdatedRecipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}
extension ReceivedServiceSubscription.CreatedRecipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}
extension ReceivedServiceSubscription.UpdatedRecipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}
extension ServiceByServiceIdxSubscription.Recipient: RecipientType {
    var asRecipientUser: RecipientUserType? { self.asServiceUnitRecipientUser?.user.asUser }
    var asRecipientGroup: RecipientGroupType? { self.asServiceUnitRecipientGroup?.group.asGroup }
}


//MARK: Recipient User

protocol RecipientUserType: BaseUserType {
    var swsInfo: SWSInfoType? { get }
}
extension CreatedServices.RecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension CreatedServices.ResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServices.RecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServices.ResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension SingleService.RecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension SingleService.ResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceLogs.RecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}

extension ServiceBySwsIdxSubscription.CreatedRecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceBySwsIdxSubscription.CreatedResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceBySwsIdxSubscription.UpdatedRecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceBySwsIdxSubscription.UpdatedResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.CreatedRecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.CreatedResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.UpdatedRecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.UpdatedResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceByServiceIdxSubscription.RecipientUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceByServiceIdxSubscription.ResponseUser: RecipientUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}


//MARK: Recipient Group

protocol RecipientGroupType: BaseTargetType {
    var groupIdx: Int { set get }
}
extension CreatedServices.RecipientGroup: RecipientGroupType {}
extension ReceivedServices.RecipientGroup: RecipientGroupType {}
extension SingleService.RecipientGroup: RecipientGroupType {}
extension ServiceLogs.RecipientGroup: RecipientGroupType {}

extension ServiceBySwsIdxSubscription.CreatedRecipientGroup: RecipientGroupType {}
extension ServiceBySwsIdxSubscription.UpdatedRecipientGroup: RecipientGroupType {}
extension ReceivedServiceSubscription.CreatedRecipientGroup: RecipientGroupType {}
extension ReceivedServiceSubscription.UpdatedRecipientGroup: RecipientGroupType {}
extension ServiceByServiceIdxSubscription.RecipientGroup: RecipientGroupType {}

//MARK: Stop

protocol ServiceStopType: BaseStopType {
    var stopIdx: Int { set get }
}
extension CreatedServices.Stop: ServiceStopType {}
extension ReceivedServices.Stop: ServiceStopType {}
extension SingleService.Stop: ServiceStopType {}
extension ServiceLogs.Stop: ServiceStopType {}

extension UserInfoes.Stop: ServiceStopType {}
extension UserInfoes.GroupStop: ServiceStopType {}
extension UserInfoes.ChargeStop: ServiceStopType {}

extension MyUserInfoes.Stop: ServiceStopType {}
extension MyUserInfoes.GroupStop: ServiceStopType {}

extension UpdateUserInfo.Stop: ServiceStopType {}
extension UpdateUserInfo.GroupStop: ServiceStopType {}

extension UpdateUserSWSInfo.Stop: ServiceStopType {}
extension UpdateUserSWSInfo.GroupStop: ServiceStopType {}

extension UpdateUserSWSInfoStop.Stop: ServiceStopType {}
extension UpdateUserSWSInfoStop.GroupStop: ServiceStopType {}

extension SWSStops.Stop: ServiceStopType {}
extension MySWSStops.Stop: ServiceStopType {}

extension ServiceBySwsIdxSubscription.CreatedStop: ServiceStopType {}
extension ServiceBySwsIdxSubscription.UpdatedStop: ServiceStopType {}
extension ReceivedServiceSubscription.CreatedStop: ServiceStopType {}
extension ReceivedServiceSubscription.UpdatedStop: ServiceStopType {}
extension ServiceByServiceIdxSubscription.Stop: ServiceStopType {}


//MARK: Freight

protocol FreightType {
    var id: String { set get }
    var name: String { set get }
    var type: ServiceUnitFreightType { set get }
    var quantity: Int { set get }
}
extension CreatedServices.Freight: FreightType {}
extension ReceivedServices.Freight: FreightType {}
extension SingleService.Freight: FreightType {}
extension ServiceLogs.Freight: FreightType {}

extension ServiceBySwsIdxSubscription.CreatedFreight: FreightType {}
extension ServiceBySwsIdxSubscription.UpdatedFreight: FreightType {}
extension ReceivedServiceSubscription.CreatedFreight: FreightType {}
extension ReceivedServiceSubscription.UpdatedFreight: FreightType {}
extension ServiceByServiceIdxSubscription.Freight: FreightType {}

//MARK: UserInfo

protocol UserInfoType: BaseTargetType {
    var userIdx: Int { set get }
    var userId: String { set get }
    var phoneNumber: String? { set get }
    var email: String { set get }
    var swsInfo: SWSInfoType? { get }
}
extension UserInfoes.User: UserInfoType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension MyUserInfoes.User: UserInfoType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension UpdateUserInfo.User: UserInfoType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}

//MARK: SWS

protocol SWSInfoType {
    var id: String { set get }
    var name: String? { set get }
    var profileImageUrl: String? { set get }
    var userIdx: Int { set get }
    var phoneNumber: String? { set get }
    var email: String? { set get }
//    var userSwsInfoIdx: Int { set get }
    
    var swsStop: ServiceStopType? { get }
    var groupPlace: ServiceStopType? { get }
    var groups: [GroupType] { get }
}
extension SWSInfoType {
    var phoneNumber: String? {
        get { return nil }
        set {}
    }
    var email: String? {
        get { return nil }
        set {}
    }
    
    var swsStop: ServiceStopType? { nil }
    var groupPlace: ServiceStopType? { nil }
}
extension CreatedServices.TargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension CreatedServices.CreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension CreatedServices.RecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension CreatedServices.AcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension CreatedServices.ResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ReceivedServices.TargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServices.CreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServices.RecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServices.AcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ReceivedServices.ResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension SingleService.TargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension SingleService.CreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension SingleService.RecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension SingleService.AcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension SingleService.ResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ServiceLogs.TargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceLogs.CreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceLogs.RecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceLogs.UserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ServiceLogs.AcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}

extension UserInfoes.SWSInfo: SWSInfoType {
    var swsStop: ServiceStopType? { self.stop?.asStop }
    var groupPlace: ServiceStopType? { self.groupStop?.asStop }
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{ $0.node } }
}
extension MyUserInfoes.SWSInfo: SWSInfoType {
    var swsStop: ServiceStopType? { self.stop?.asStop }
    var groupPlace: ServiceStopType? { self.groupStop?.asStop }
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{ $0.node } }
}
extension UpdateUserInfo.SWSInfo: SWSInfoType {
    var swsStop: ServiceStopType? { self.stop?.asStop }
    var groupPlace: ServiceStopType? { self.groupStop?.asStop }
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{ $0.node } }
}
extension UpdateUserSWSInfo.SWSInfo: SWSInfoType {
    var swsStop: ServiceStopType? { self.stop?.asStop }
    var groupPlace: ServiceStopType? { self.groupStop?.asStop }
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{ $0.node } }
}
extension UpdateUserSWSInfoStop.SWSInfo: SWSInfoType {
    var swsStop: ServiceStopType? { self.stop?.asStop }
    var groupPlace: ServiceStopType? { self.groupStop?.asStop }
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{ $0.node } }
}

extension ServiceBySwsIdxSubscription.CreatedTargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceBySwsIdxSubscription.CreatedCreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceBySwsIdxSubscription.CreatedRecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceBySwsIdxSubscription.CreatedAcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ServiceBySwsIdxSubscription.CreatedResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ServiceBySwsIdxSubscription.UpdatedTargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceBySwsIdxSubscription.UpdatedCreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceBySwsIdxSubscription.UpdatedRecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceBySwsIdxSubscription.UpdatedAcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ServiceBySwsIdxSubscription.UpdatedResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}

extension ReceivedServiceSubscription.CreatedTargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServiceSubscription.CreatedCreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServiceSubscription.CreatedRecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServiceSubscription.CreatedAcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ReceivedServiceSubscription.CreatedResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ReceivedServiceSubscription.UpdatedTargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServiceSubscription.UpdatedCreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServiceSubscription.UpdatedRecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ReceivedServiceSubscription.UpdatedAcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ReceivedServiceSubscription.UpdatedResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}

extension ServiceByServiceIdxSubscription.TargetUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceByServiceIdxSubscription.CreatorSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceByServiceIdxSubscription.RecipientUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { self.groupsConnection.edges.compactMap{$0.node} }
}
extension ServiceByServiceIdxSubscription.AcceptorUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}
extension ServiceByServiceIdxSubscription.ResponseUserSWSInfo: SWSInfoType {
    var groups: [GroupType] { [] }
}

//---

protocol SWSType: BaseTargetType {
    var swsIdx: Int { set get }
    var profileImageUrl: String? { set get }
    var memberCount: Int { set get }
    
    var createAt: String { get }
    var envMapList: [EnvMapType] { get }
}
extension SWSInfo.SWS: SWSType {
    var envMapList: [EnvMapType] { self.envMaps }
}


//EnvMap

protocol EnvMapType {
    var id: String { set get }
    var name: String { set get }
    var imageUrl: String { set get }
    var version: String { set get }
}
extension SWSInfo.EnvMap: EnvMapType {}


//Robot
protocol RobotType {
    var id: String { set get }
    var name: String { set get }
}
extension CreatedServices.Robot: RobotType {}
extension ReceivedServices.Robot: RobotType {}
extension SingleService.Robot: RobotType {}
extension ServiceLogs.Robot: RobotType {}

extension ServiceBySwsIdxSubscription.CreatedRobot: RobotType {}
extension ServiceBySwsIdxSubscription.UpdatedRobot: RobotType {}
extension ReceivedServiceSubscription.CreatedRobot: RobotType {}
extension ReceivedServiceSubscription.UpdatedRobot: RobotType {}
extension ServiceByServiceIdxSubscription.Robot: RobotType {}

//Response
protocol ServiceUnitUserResponseType {
    var id: String { set get }
    var response: ServiceUnitResponse { set get }
    var responseType: ServiceUnitResponseType? { set get }
    
    var receiver: RecipientUserType { get }
}
extension CreatedServices.Response: ServiceUnitUserResponseType {
    var receiver: RecipientUserType { self.user }
}
extension ReceivedServices.Response: ServiceUnitUserResponseType {
    var receiver: RecipientUserType { self.user }
}
extension SingleService.Response: ServiceUnitUserResponseType {
    var receiver: RecipientUserType { self.user }
}



//MARK: - Acceptor -

protocol AcceptorType {
    var id: String { set get }
    var responseAt: String { set get }
    var responseType: ServiceUnitResponseType { set get }
    var serviceUnitIdx: Int { set get }
    var userIdx: Int { set get }
    
    var target: BaseTargetType? { get }
}
extension CreatedServices.Acceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}
extension ReceivedServices.Acceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}
extension SingleService.Acceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}
extension ServiceLogs.Acceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}

extension ServiceBySwsIdxSubscription.CreatedAcceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}
extension ServiceBySwsIdxSubscription.UpdatedAcceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}
extension ReceivedServiceSubscription.CreatedAcceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}
extension ReceivedServiceSubscription.UpdatedAcceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}
extension ServiceByServiceIdxSubscription.Acceptor: AcceptorType {
    
    var target: BaseTargetType? {
        if let user = self.asServiceUnitAcceptorUser?.user?.asUser {
            return user
        }else if let group = self.asServiceUnitAcceptorGroup?.group?.asGroup {
            return group
        }
        return nil
    }
}


protocol AcceptorUserType: BaseUserType {
    var swsInfo: SWSInfoType? { get }
}
extension CreatedServices.AcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServices.AcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension SingleService.AcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceLogs.AcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}

extension ServiceBySwsIdxSubscription.CreatedAcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceBySwsIdxSubscription.UpdatedAcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.CreatedAcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ReceivedServiceSubscription.UpdatedAcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}
extension ServiceByServiceIdxSubscription.AcceptorUser: AcceptorUserType {
    var swsInfo: SWSInfoType? { self.userSwsInfo?.asUserSwsInfo }
}


protocol AcceptorGroupType: BaseTargetType {
    var groupIdx: Int { set get }
}
extension CreatedServices.AcceptorGroup: AcceptorGroupType {}
extension ReceivedServices.AcceptorGroup: AcceptorGroupType {}
extension SingleService.AcceptorGroup: AcceptorGroupType {}
extension ServiceLogs.AcceptorGroup: AcceptorGroupType {}

extension ServiceBySwsIdxSubscription.CreatedAcceptorGroup: AcceptorGroupType {}
extension ServiceBySwsIdxSubscription.UpdatedAcceptorGroup: AcceptorGroupType {}
extension ReceivedServiceSubscription.CreatedAcceptorGroup: AcceptorGroupType {}
extension ReceivedServiceSubscription.UpdatedAcceptorGroup: AcceptorGroupType {}
extension ServiceByServiceIdxSubscription.AcceptorGroup: AcceptorGroupType {}


//MARK: - Customs -

struct ServiceUnitSet {
    var bypassServiceUnit: ServiceUnitType?
    var serviceUnit: ServiceUnitType!
}
