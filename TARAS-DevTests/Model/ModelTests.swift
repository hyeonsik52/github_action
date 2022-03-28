//
//  ModelTests.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/02/28.
//

import XCTest

@testable import TARAS_Dev

class ModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAccount() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        //basic
        let account = DummyModel.account_basic
        
        XCTAssertEqual(account.ID, DummyModel.id)
        XCTAssertEqual(account.id, DummyModel.username)
        XCTAssertEqual(account.password, nil)
        XCTAssertEqual(account.name, DummyModel.displayName)
        XCTAssertEqual(account.email, DummyModel.email)
        XCTAssertEqual(account.phoneNumber, nil)
        
        //optional
        let optionalAccount = DummyModel.account_optional
        
        XCTAssertEqual(optionalAccount.ID, DummyModel.id)
        XCTAssertEqual(optionalAccount.id, DummyModel.username)
        XCTAssertEqual(optionalAccount.password, nil)
        XCTAssertEqual(optionalAccount.name, DummyModel.displayName)
        XCTAssertEqual(optionalAccount.email, nil)
        XCTAssertEqual(optionalAccount.phoneNumber, nil)
        
        //equal
        XCTAssertEqual(account, optionalAccount)
    }
    
    func testUser() throws {

        //basic
        let user = DummyModel.user_basic
        
        XCTAssertEqual(user.id, DummyModel.id)
        XCTAssertEqual(user.username, DummyModel.username)
        XCTAssertEqual(user.displayName, DummyModel.displayName)
        XCTAssertEqual(user.email, DummyModel.email)
        XCTAssertEqual(user.phonenumber, DummyModel.phoneNumber)
        XCTAssertEqual(user.role, nil)
        
        //optional
        let optionalUser = DummyModel.user_optional
        
        XCTAssertEqual(optionalUser.id, DummyModel.id)
        XCTAssertEqual(optionalUser.username, DummyModel.username)
        XCTAssertEqual(optionalUser.displayName, DummyModel.displayName)
        XCTAssertEqual(optionalUser.email, nil)
        XCTAssertEqual(optionalUser.phonenumber, nil)
        XCTAssertEqual(optionalUser.role, nil)
        
        //member
        if let member = DummyModel.user_member {
            
            XCTAssertEqual(member.id, DummyModel.id)
            XCTAssertEqual(member.username, "")
            XCTAssertEqual(member.displayName, DummyModel.displayName)
            XCTAssertEqual(member.email, nil)
            XCTAssertEqual(member.phonenumber, nil)
            XCTAssertEqual(member.role, nil)
        }
        
        //raw
        let rawUser = DummyModel.user_raw
        
        XCTAssertEqual(rawUser.id, DummyModel.id)
        XCTAssertEqual(rawUser.username, DummyModel.username)
        XCTAssertEqual(rawUser.displayName, DummyModel.displayName)
        XCTAssertEqual(rawUser.email, DummyModel.email)
        XCTAssertEqual(rawUser.phonenumber, DummyModel.phoneNumber)
        XCTAssertEqual(rawUser.role, nil)
    }
    
    func testRobot() throws {
        
        //basic
        let robot = DummyModel.robot_basic
        
        XCTAssertEqual(robot.id, DummyModel.id)
        XCTAssertEqual(robot.name, DummyModel.displayName)
        
        //optional
        let optionalRobot = DummyModel.robot_optional
        
        XCTAssertEqual(optionalRobot.id, DummyModel.id)
        XCTAssertNotEqual(optionalRobot.name, DummyModel.displayName)
        
        //raw
        let rawRobot = DummyModel.robot_raw
        
        XCTAssertEqual(rawRobot.id, DummyModel.id)
        XCTAssertEqual(rawRobot.name, DummyModel.displayName)
    }
    
    func testStop() throws {
        
        //basic
        let stopTypeLoading = StopType.loading
        let stop = DummyModel.stop_basic(type: stopTypeLoading)
        
        XCTAssertEqual(stop.id, DummyModel.id)
        XCTAssertEqual(stop.name, DummyModel.displayName)
        XCTAssertEqual(stop.stopType, stopTypeLoading)
        XCTAssertEqual(stop.stopType.isLoading, true)
        
        //optional
        let optionalStop = DummyModel.stop_optional
        
        XCTAssertEqual(optionalStop.id, Stop.unknownId)
        XCTAssertNotEqual(optionalStop.name, DummyModel.displayName)
        
        //raw
        let stopTypeNormal = StopType.normal
        let rawStop = try DummyModel.stop_raw(type: stopTypeNormal)
        
        XCTAssertEqual(rawStop.id, DummyModel.id)
        XCTAssertEqual(rawStop.name, DummyModel.displayName)
        XCTAssertEqual(rawStop.stopType, stopTypeNormal)
    }
    
    func testWorkpsace() throws {
        
        //basic
        let workspace = DummyModel.workspace_basic
        
        XCTAssertEqual(workspace.id, DummyModel.id)
        XCTAssertEqual(workspace.name, DummyModel.displayName)
        XCTAssertEqual(
            Int(workspace.createdAt.timeIntervalSince1970),
            Int(DummyModel.createdAt.timeIntervalSince1970)
        )
        XCTAssertEqual(workspace.memberCount, DummyModel.workspaceMemberCount)
        XCTAssertEqual(workspace.isRequiredUserEmailToJoin, nil)
        XCTAssertEqual(workspace.isRequiredUserPhoneNumberToJoin, nil)
        XCTAssertEqual(workspace.myMemberState, DummyModel.myMemberStatus)
        XCTAssertEqual(workspace.code, DummyModel.workspaceCode)
        
        //optional
        let optionalWorkspace = DummyModel.workspace_optional
        
        XCTAssertEqual(optionalWorkspace.id, DummyModel.id)
        XCTAssertEqual(optionalWorkspace.name, DummyModel.displayName)
        XCTAssertNotEqual(workspace.createdAt, DummyModel.createdAt)
        XCTAssertNotEqual(optionalWorkspace.memberCount, DummyModel.workspaceMemberCount)
        XCTAssertEqual(optionalWorkspace.isRequiredUserEmailToJoin, nil)
        XCTAssertEqual(optionalWorkspace.isRequiredUserPhoneNumberToJoin, nil)
        XCTAssertEqual(optionalWorkspace.myMemberState, DummyModel.myMemberStatus)
        XCTAssertNotEqual(optionalWorkspace.code, DummyModel.workspaceCode)
        
        //only
        let onlyWorkspace = DummyModel.workspace_only
        
        XCTAssertEqual(onlyWorkspace.id, DummyModel.id)
        XCTAssertEqual(onlyWorkspace.name, DummyModel.displayName)
        XCTAssertEqual(
            Int(workspace.createdAt.timeIntervalSince1970),
            Int(DummyModel.createdAt.timeIntervalSince1970)
        )
        XCTAssertEqual(onlyWorkspace.memberCount, DummyModel.workspaceMemberCount)
        XCTAssertEqual(onlyWorkspace.isRequiredUserEmailToJoin, true)
        XCTAssertEqual(onlyWorkspace.isRequiredUserPhoneNumberToJoin, true)
        XCTAssertEqual(onlyWorkspace.myMemberState, DummyModel.myMemberStatus)
        XCTAssertEqual(onlyWorkspace.code, DummyModel.workspaceCode)
    }
    
    func testServiceUnit() throws {
        
        //basic
        let serviceUnit = DummyModel.serviceUnit_basic
        
        XCTAssertEqual(serviceUnit.id, DummyModel.id)
        XCTAssertEqual(serviceUnit.state, DummyModel.serviceUnitState)
        XCTAssertEqual(serviceUnit.stop, DummyModel.stop_basic(type: .normal))
        XCTAssertEqual(serviceUnit.recipients.first, DummyModel.user_basic)
        XCTAssertEqual(serviceUnit.orderWithinService, DummyModel.serviceCurrentStep)
        XCTAssertEqual(serviceUnit.isMyWork(DummyModel.id), true)
        
        //optional
        let optionalServiceUnit = DummyModel.serviceUnit_optional
        
        XCTAssertEqual(optionalServiceUnit.id, DummyModel.id)
        XCTAssertEqual(optionalServiceUnit.state, DummyModel.serviceUnitState)
        XCTAssertNotEqual(optionalServiceUnit.stop, DummyModel.stop_basic(type: .normal))
        XCTAssertEqual(optionalServiceUnit.recipients.first, nil)
        XCTAssertEqual(optionalServiceUnit.orderWithinService, DummyModel.serviceCurrentStep)
        
        //only
        let rawServiceUnit = try DummyModel.serviceUnit_raw()
        XCTAssertEqual(rawServiceUnit.id, DummyModel.id)
        XCTAssertNotEqual(rawServiceUnit.state, DummyModel.serviceUnitState)
        XCTAssertEqual(rawServiceUnit.stop, DummyModel.stop_basic(type: .normal))
        XCTAssertEqual(rawServiceUnit.recipients.first, DummyModel.user_basic)
        XCTAssertEqual(rawServiceUnit.orderWithinService, DummyModel.serviceCurrentStep)
    }
    
    func testServiceLog() throws {
        
        let check: (ServiceLogState, ServiceLogState, String) throws -> Void = {
            XCTAssertEqual($0, $1)
            XCTAssertTrue($0.message.contains($2))
            XCTAssertTrue($0.styledMessage.string.contains($2))
        }
        
        try check(
            DummyModel.serviceLog_created.type,
            .created(creator: DummyModel.displayName),
            "서비스를 요청"
        )
        
        try check(
            DummyModel.serviceLog_assigined.type,
            .robotAssigned(robot: DummyModel.displayName),
            "로봇이 배정"
        )
        
//        try check(
//            MockModel.serviceLog_departed.type,
//            .robotDeparted(destination: "알 수 없는 위치"),
//            "로봇이 출발"
//        )
        
        try check(
            DummyModel.serviceLog_arrived.type,
            .robotArrived(serviceUnitIdx: 0, destination: "알 수 없는 위치"),
            "도착"
        )
        
        try check(
            DummyModel.serviceLog_jobDone.type,
            .workCompleted(destination: "알 수 없는 위치"),
            "작업이 완료"
        )
        
        try check(
            DummyModel.serviceLog_finished.type,
            .finished,
            "서비스가 완료"
        )
        
        try check(
            DummyModel.serviceLog_canceled.type,
            .canceled,
            "서비스를 취소"
        )
        
        try check(
            DummyModel.serviceLog_failed(description: "timeout").type,
            .failed(.timeout),
            "대기시간 초과로 서비스가 종료"
        )
        
        try check(
            DummyModel.serviceLog_failed(description: "emergency").type,
            .failed(.emergency),
            "비상정지로 서비스가 종료"
        )
        
        try check(
            DummyModel.serviceLog_failed(description: "robot").type,
            .failed(.robot),
            "기기 오류로 서비스가 종료"
        )
        
        try check(
            DummyModel.serviceLog_failed(description: "server").type,
            .failed(.server),
            "서버 오류로 서비스가 종료"
        )
    }
    
    func testServiceLogSet() throws {
        
        let serviceLogSet = DummyModel.serviceLogSet_completed
        
        XCTAssertEqual(serviceLogSet.isServiceCompleted, true)
        XCTAssertEqual(serviceLogSet.isServiceCanceled, false)
        XCTAssertEqual(serviceLogSet.isServiceFailed, false)
        XCTAssertEqual(serviceLogSet.canceledMessage, nil)
        XCTAssertEqual(serviceLogSet.failedMessage, nil)
        
        if serviceLogSet.isServiceCompleted,
           let requestedAt = serviceLogSet.requestedAt,
           let startedAt = serviceLogSet.startedAt,
           let finishedAt = serviceLogSet.finishedAt {
            XCTAssertTrue(requestedAt <= startedAt)
            XCTAssertTrue(startedAt <= finishedAt)
        }
    }
    
    func testServiceState() throws {
        
        let check: (ServiceState, String...) throws -> Void = {
            for state in $1 {
                let value = ServiceState(state: state)
                XCTAssertTrue(value == $0)
            }
            XCTAssertTrue($0.rawValues.sorted() == $1.sorted())
        }
        
        try check(
            .robotAssigning,
            "Initialized",
            "waiting_for_robot_to_be_assigned_to_mission"
        )
        
        try check(
            .waiting,
            "waiting_for_robot_to_depart"
        )
        
        try check(
            .moving,
            "waiting_for_robot_to_arrive"
        )
        
        try check(
            .arrived,
            "waiting_for_work_to_complete",
            "waiting_for_verification_code",
            "waiting_for_opening_parcel_lift",
            "waiting_for_closing_parcel_lift"
        )
        
        try check(
            .finished,
            "Finished"
        )
        
        try check(
            .canceled,
            "Canceled"
        )
        
        try check(
            .failed,
            "Failed"
        )
        
        try check(
            .returning,
            "Returning"
        )
        
        XCTAssertTrue(ServiceState.unknown.rawValues.isEmpty)
    }
    
    func testServicePhase() throws {
        
        let serviceLogSet = DummyModel.serviceLogSet_completed
        
        let check: (ServicePhase, String, ServiceState, ServiceLogSet) throws -> ServicePhase = {
            let phase = ServicePhase(phase: $1, state: $2, logset: $3)
            XCTAssertEqual(phase, $0)
            XCTAssertEqual(phase.toString, $1)
            return phase
        }
        
        let waiting = try check(
            .waiting,
            "Initialization",
            .robotAssigning,
            serviceLogSet
        )
        
        let delivering = try check(
            .delivering,
            "Executing",
            .moving,
            serviceLogSet
        )
        
        let completed = try check(
            .completed,
            "Done",
            .finished,
            serviceLogSet
        )
        
        let canceled = try check(
            .canceled,
            "Done",
            .canceled,
            serviceLogSet
        )
        
        let returning = try check(
            .completed,
            "Done",
            .returning,
            serviceLogSet
        )
        
        XCTAssertTrue(waiting.sortOrder == delivering.sortOrder)
        XCTAssertTrue(completed.sortOrder == canceled.sortOrder)
        XCTAssertTrue(returning.sortOrder < waiting.sortOrder)
    }
    
    func testService() throws {
        
        //basic
        let service = try DummyModel.service_basic()
        
        XCTAssertEqual(service.id, DummyModel.id)
        XCTAssertEqual(service.type, .general)
        XCTAssertEqual(service.status, .finished)
        XCTAssertEqual(service.phase, .completed)
        XCTAssertEqual(service.serviceNumber, DummyModel.serviceNumber)
        XCTAssertEqual(service.requestedAt, DummyModel.createdAt)
        XCTAssertNotEqual(service.startedAt, DummyModel.createdAt)
        XCTAssertNotEqual(service.finishedAt, DummyModel.createdAt)
        XCTAssertEqual(service.robot, DummyModel.robot_basic)
        XCTAssertEqual(service.creator.username, DummyModel.username)
        XCTAssertEqual(service.currentServiceUnitIdx, DummyModel.serviceCurrentStep)
        XCTAssertEqual(service.serviceUnits.isEmpty, false)
        XCTAssertEqual(service.travelDistance, DummyModel.serviceMovingDistance)
        XCTAssertEqual(service.serviceLogSet.serviceLogs.isEmpty, false)
        
        XCTAssertEqual(service.isMyTurn(DummyModel.id), false)
        XCTAssertEqual(service.currentServiceUnit?.orderWithinService, DummyModel.serviceCurrentStep)
        
        XCTAssertEqual(service.canceledDescription, nil)
        XCTAssertEqual(service.stateDescription, "서비스 완료")
        XCTAssertEqual(service.stateColor.hashValue, UIColor(hex: "#F5F5F5").hashValue)
        
        //optional
        let optionalService = DummyModel.service_optional
        
        XCTAssertEqual(optionalService.id, Service.unknownId)
        XCTAssertEqual(optionalService.type, .unknown)
        XCTAssertEqual(optionalService.status, .unknown)
        XCTAssertEqual(optionalService.phase, .waiting)
        XCTAssertEqual(optionalService.serviceNumber, "-")
        XCTAssertNotEqual(optionalService.requestedAt, DummyModel.createdAt)
        XCTAssertEqual(optionalService.startedAt, nil)
        XCTAssertEqual(optionalService.finishedAt, nil)
        XCTAssertEqual(optionalService.robot, nil)
        XCTAssertEqual(optionalService.creator.id, User.unknownId)
        XCTAssertEqual(optionalService.currentServiceUnitIdx, 0)
        XCTAssertEqual(optionalService.serviceUnits.isEmpty, true)
        XCTAssertEqual(optionalService.travelDistance, nil)
        XCTAssertEqual(optionalService.serviceLogSet.serviceLogs.isEmpty, true)
        
        //raw
        let rawService = try DummyModel.service_raw()
        
        XCTAssertEqual(rawService.id, DummyModel.id)
        XCTAssertEqual(rawService.type, .general)
        XCTAssertEqual(rawService.status, .finished)
        XCTAssertEqual(rawService.phase, .completed)
        XCTAssertEqual(rawService.serviceNumber, DummyModel.serviceNumber)
        XCTAssertEqual(rawService.requestedAt, DummyModel.createdAt)
        XCTAssertNotEqual(rawService.startedAt, DummyModel.createdAt)
        XCTAssertNotEqual(rawService.finishedAt, DummyModel.createdAt)
        XCTAssertEqual(rawService.robot, nil)
        XCTAssertEqual(rawService.creator.username, DummyModel.username)
        XCTAssertEqual(rawService.currentServiceUnitIdx, DummyModel.serviceCurrentStep)
        XCTAssertEqual(rawService.serviceUnits.isEmpty, false)
        XCTAssertEqual(rawService.travelDistance, DummyModel.serviceMovingDistance)
        XCTAssertEqual(rawService.serviceLogSet.serviceLogs.isEmpty, false)
        
        //canceled, failed, returning
        let canceledService = DummyModel.canceledService()
        XCTAssertNotNil(canceledService.canceledDescription)
        XCTAssertNotNil(canceledService.stateDescription == "서비스 취소")
        
        let failedService = DummyModel.failedService()
        XCTAssertNotNil(failedService.canceledDescription)
        XCTAssertNotNil(failedService.stateDescription == "서비스 취소")
        
        let returningCancledService = DummyModel.canceledService(isStateReturning: true)
        XCTAssertNotNil(returningCancledService.canceledDescription)
        
        let returningFailedService = DummyModel.failedService(isStateReturning: true)
        XCTAssertNotNil(returningFailedService.canceledDescription)
    }
    
    func testVersion() throws {
        
        let thisAppVersion = Version.thisAppVersion
        XCTAssertEqual(thisAppVersion.minimumBuildNumber, 1)
        XCTAssertEqual(thisAppVersion.currentBuildNumber.description, Info.appBuild)
        XCTAssertEqual(thisAppVersion.currentVersion, Info.appVersion)
        
        //basic
        let basicVersion = DummyModel.version_basic_latest
        XCTAssertEqual(basicVersion.isLatest, true)
        XCTAssertEqual(basicVersion.mustUpdate, false)
        
        //optional
        let optionalVersion = DummyModel.version_optional_new
        XCTAssertEqual(optionalVersion.isLatest, false)
        XCTAssertEqual(optionalVersion.mustUpdate, false)
        
        //mustUpdate
        let mustUpdateVersion = DummyModel.version_must_update
        XCTAssertEqual(mustUpdateVersion.isLatest, false)
        XCTAssertEqual(mustUpdateVersion.mustUpdate, true)
    }
    
    func testServiceTemplate() throws {
        
        //basic
        let basicServiceTemplate = try DummyModel.serviceTemplate_basic_general()
        
        XCTAssertEqual(basicServiceTemplate.id, DummyModel.id)
        XCTAssertEqual(basicServiceTemplate.name, DummyModel.displayName)
        XCTAssertTrue(basicServiceTemplate.type.isGeneral)
        XCTAssertEqual(basicServiceTemplate.description, DummyModel.description)
        XCTAssertEqual(basicServiceTemplate.serviceBuilder.arguments.isEmpty, false)
        XCTAssertEqual(basicServiceTemplate.isCompiled, false)
        
        //optional
        let optionalServiceTemplate = try DummyModel.serviceTemplate_optional_shortcut()
        
        XCTAssertEqual(optionalServiceTemplate.id, DummyModel.id)
        XCTAssertEqual(optionalServiceTemplate.name, DummyModel.displayName)
        XCTAssertTrue(optionalServiceTemplate.type.isShortcut)
        XCTAssertEqual(optionalServiceTemplate.description, nil)
        XCTAssertEqual(optionalServiceTemplate.serviceBuilder.arguments.isEmpty, true)
        XCTAssertEqual(optionalServiceTemplate.isCompiled, true)
    }
}
