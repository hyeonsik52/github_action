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
        let account = MockModel.account_basic
        
        XCTAssertEqual(account.ID, MockModel.id)
        XCTAssertEqual(account.id, MockModel.username)
        XCTAssertEqual(account.password, nil)
        XCTAssertEqual(account.name, MockModel.displayName)
        XCTAssertEqual(account.email, MockModel.email)
        XCTAssertEqual(account.phoneNumber, nil)
        
        //optional
        let optionalAccount = MockModel.account_optional
        
        XCTAssertEqual(optionalAccount.ID, MockModel.id)
        XCTAssertEqual(optionalAccount.id, MockModel.username)
        XCTAssertEqual(optionalAccount.password, nil)
        XCTAssertEqual(optionalAccount.name, MockModel.displayName)
        XCTAssertEqual(optionalAccount.email, nil)
        XCTAssertEqual(optionalAccount.phoneNumber, nil)
        
        //equal
        XCTAssertEqual(account, optionalAccount)
    }
    
    func testUser() throws {

        //basic
        let user = MockModel.user_basic
        
        XCTAssertEqual(user.id, MockModel.id)
        XCTAssertEqual(user.username, MockModel.username)
        XCTAssertEqual(user.displayName, MockModel.displayName)
        XCTAssertEqual(user.email, MockModel.email)
        XCTAssertEqual(user.phonenumber, MockModel.phoneNumber)
        XCTAssertEqual(user.role, nil)
        
        //optional
        let optionalUser = MockModel.user_optional
        
        XCTAssertEqual(optionalUser.id, MockModel.id)
        XCTAssertEqual(optionalUser.username, MockModel.username)
        XCTAssertEqual(optionalUser.displayName, MockModel.displayName)
        XCTAssertEqual(optionalUser.email, nil)
        XCTAssertEqual(optionalUser.phonenumber, nil)
        XCTAssertEqual(optionalUser.role, nil)
        
        //member
        if let member = MockModel.user_member {
            
            XCTAssertEqual(member.id, MockModel.id)
            XCTAssertEqual(member.username, "")
            XCTAssertEqual(member.displayName, MockModel.displayName)
            XCTAssertEqual(member.email, nil)
            XCTAssertEqual(member.phonenumber, nil)
            XCTAssertEqual(member.role, nil)
        }
        
        //raw
        let rawUser = MockModel.user_raw
        
        XCTAssertEqual(rawUser.id, MockModel.id)
        XCTAssertEqual(rawUser.username, MockModel.username)
        XCTAssertEqual(rawUser.displayName, MockModel.displayName)
        XCTAssertEqual(rawUser.email, MockModel.email)
        XCTAssertEqual(rawUser.phonenumber, MockModel.phoneNumber)
        XCTAssertEqual(rawUser.role, nil)
    }
    
    func testRobot() throws {
        
        //basic
        let robot = MockModel.robot_basic
        
        XCTAssertEqual(robot.id, MockModel.id)
        XCTAssertEqual(robot.name, MockModel.displayName)
        
        //optional
        let optionalRobot = MockModel.robot_optional
        
        XCTAssertEqual(optionalRobot.id, MockModel.id)
        XCTAssertNotEqual(optionalRobot.name, MockModel.displayName)
        
        //raw
        let rawRobot = MockModel.robot_raw
        
        XCTAssertEqual(rawRobot.id, MockModel.id)
        XCTAssertEqual(rawRobot.name, MockModel.displayName)
    }
    
    func testStop() throws {
        
        //basic
        let stopTypeLoading = StopType.loading
        let stop = MockModel.stop_basic(type: stopTypeLoading)
        
        XCTAssertEqual(stop.id, MockModel.id)
        XCTAssertEqual(stop.name, MockModel.displayName)
        XCTAssertEqual(stop.stopType, stopTypeLoading)
        XCTAssertEqual(stop.stopType.isLoading, true)
        
        //optional
        let optionalStop = MockModel.stop_optional
        
        XCTAssertEqual(optionalStop.id, Stop.unknownId)
        XCTAssertNotEqual(optionalStop.name, MockModel.displayName)
        
        //raw
        let stopTypeNormal = StopType.normal
        let rawStop = try MockModel.stop_raw(type: stopTypeNormal)
        
        XCTAssertEqual(rawStop.id, MockModel.id)
        XCTAssertEqual(rawStop.name, MockModel.displayName)
        XCTAssertEqual(rawStop.stopType, stopTypeNormal)
    }
    
    func testWorkpsace() throws {
        
        //basic
        let workspace = MockModel.workspace_basic
        
        XCTAssertEqual(workspace.id, MockModel.id)
        XCTAssertEqual(workspace.name, MockModel.displayName)
        XCTAssertEqual(
            Int(workspace.createdAt.timeIntervalSince1970),
            Int(MockModel.createdAt.timeIntervalSince1970)
        )
        XCTAssertEqual(workspace.memberCount, MockModel.workspaceMemberCount)
        XCTAssertEqual(workspace.isRequiredUserEmailToJoin, nil)
        XCTAssertEqual(workspace.isRequiredUserPhoneNumberToJoin, nil)
        XCTAssertEqual(workspace.myMemberState, MockModel.myMemberStatus)
        XCTAssertEqual(workspace.code, MockModel.workspaceCode)
        
        //optional
        let optionalWorkspace = MockModel.workspace_optional
        
        XCTAssertEqual(optionalWorkspace.id, MockModel.id)
        XCTAssertEqual(optionalWorkspace.name, MockModel.displayName)
        XCTAssertNotEqual(workspace.createdAt, MockModel.createdAt)
        XCTAssertNotEqual(optionalWorkspace.memberCount, MockModel.workspaceMemberCount)
        XCTAssertEqual(optionalWorkspace.isRequiredUserEmailToJoin, nil)
        XCTAssertEqual(optionalWorkspace.isRequiredUserPhoneNumberToJoin, nil)
        XCTAssertEqual(optionalWorkspace.myMemberState, MockModel.myMemberStatus)
        XCTAssertNotEqual(optionalWorkspace.code, MockModel.workspaceCode)
        
        //only
        let onlyWorkspace = MockModel.workspace_only
        
        XCTAssertEqual(onlyWorkspace.id, MockModel.id)
        XCTAssertEqual(onlyWorkspace.name, MockModel.displayName)
        XCTAssertEqual(
            Int(workspace.createdAt.timeIntervalSince1970),
            Int(MockModel.createdAt.timeIntervalSince1970)
        )
        XCTAssertEqual(onlyWorkspace.memberCount, MockModel.workspaceMemberCount)
        XCTAssertEqual(onlyWorkspace.isRequiredUserEmailToJoin, true)
        XCTAssertEqual(onlyWorkspace.isRequiredUserPhoneNumberToJoin, true)
        XCTAssertEqual(onlyWorkspace.myMemberState, MockModel.myMemberStatus)
        XCTAssertEqual(onlyWorkspace.code, MockModel.workspaceCode)
    }
    
    func testServiceUnit() throws {
        
        //basic
        let serviceUnit = MockModel.serviceUnit_basic
        
        XCTAssertEqual(serviceUnit.id, MockModel.id)
        XCTAssertEqual(serviceUnit.state, MockModel.serviceUnitState)
        XCTAssertEqual(serviceUnit.stop, MockModel.stop_basic(type: .normal))
        XCTAssertEqual(serviceUnit.recipients.first, MockModel.user_basic)
        XCTAssertEqual(serviceUnit.orderWithinService, MockModel.serviceCurrentStep)
        XCTAssertEqual(serviceUnit.isMyWork(MockModel.id), true)
        
        //optional
        let optionalServiceUnit = MockModel.serviceUnit_optional
        
        XCTAssertEqual(optionalServiceUnit.id, MockModel.id)
        XCTAssertEqual(optionalServiceUnit.state, MockModel.serviceUnitState)
        XCTAssertNotEqual(optionalServiceUnit.stop, MockModel.stop_basic(type: .normal))
        XCTAssertEqual(optionalServiceUnit.recipients.first, nil)
        XCTAssertEqual(optionalServiceUnit.orderWithinService, MockModel.serviceCurrentStep)
        
        //only
        let rawServiceUnit = try MockModel.serviceUnit_raw()
        XCTAssertEqual(rawServiceUnit.id, MockModel.id)
        XCTAssertNotEqual(rawServiceUnit.state, MockModel.serviceUnitState)
        XCTAssertEqual(rawServiceUnit.stop, MockModel.stop_basic(type: .normal))
        XCTAssertEqual(rawServiceUnit.recipients.first, MockModel.user_basic)
        XCTAssertEqual(rawServiceUnit.orderWithinService, MockModel.serviceCurrentStep)
    }
    
    func testServiceLog() throws {
        
        let check: (ServiceLogState, ServiceLogState, String) throws -> Void = {
            XCTAssertEqual($0, $1)
            XCTAssertTrue($0.message.contains($2))
            XCTAssertTrue($0.styledMessage.string.contains($2))
        }
        
        try check(
            MockModel.serviceLog_created.type,
            .created(creator: MockModel.displayName),
            "서비스를 요청"
        )
        
        try check(
            MockModel.serviceLog_assigined.type,
            .robotAssigned(robot: MockModel.displayName),
            "로봇이 배정"
        )
        
//        try check(
//            MockModel.serviceLog_departed.type,
//            .robotDeparted(destination: "알 수 없는 위치"),
//            "로봇이 출발"
//        )
        
        try check(
            MockModel.serviceLog_arrived.type,
            .robotArrived(serviceUnitIdx: 0, destination: "알 수 없는 위치"),
            "도착"
        )
        
        try check(
            MockModel.serviceLog_jobDone.type,
            .workCompleted(destination: "알 수 없는 위치"),
            "작업이 완료"
        )
        
        try check(
            MockModel.serviceLog_finished.type,
            .finished,
            "서비스가 완료"
        )
        
        try check(
            MockModel.serviceLog_canceled.type,
            .canceled,
            "서비스를 취소"
        )
        
        try check(
            MockModel.serviceLog_failed(description: "timeout").type,
            .failed(.timeout),
            "대기시간 초과로 서비스가 종료"
        )
        
        try check(
            MockModel.serviceLog_failed(description: "emergency").type,
            .failed(.emergency),
            "비상정지로 서비스가 종료"
        )
        
        try check(
            MockModel.serviceLog_failed(description: "robot").type,
            .failed(.robot),
            "기기 오류로 서비스가 종료"
        )
        
        try check(
            MockModel.serviceLog_failed(description: "server").type,
            .failed(.server),
            "서버 오류로 서비스가 종료"
        )
    }
    
    func testServiceLogSet() throws {
        
        let serviceLogSet = MockModel.serviceLogSet_completed
        
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
        
        let serviceLogSet = MockModel.serviceLogSet_completed
        
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
        let service = try MockModel.service_basic()
        
        XCTAssertEqual(service.id, MockModel.id)
        XCTAssertEqual(service.type, .general)
        XCTAssertEqual(service.status, .finished)
        XCTAssertEqual(service.phase, .completed)
        XCTAssertEqual(service.serviceNumber, MockModel.serviceNumber)
        XCTAssertEqual(service.requestedAt, MockModel.createdAt)
        XCTAssertNotEqual(service.startedAt, MockModel.createdAt)
        XCTAssertNotEqual(service.finishedAt, MockModel.createdAt)
        XCTAssertEqual(service.robot, MockModel.robot_basic)
        XCTAssertEqual(service.creator.username, MockModel.username)
        XCTAssertEqual(service.currentServiceUnitIdx, MockModel.serviceCurrentStep)
        XCTAssertEqual(service.serviceUnits.isEmpty, false)
        XCTAssertEqual(service.travelDistance, MockModel.serviceMovingDistance)
        XCTAssertEqual(service.serviceLogSet.serviceLogs.isEmpty, false)
        
        XCTAssertEqual(service.isMyTurn(MockModel.id), false)
        XCTAssertEqual(service.currentServiceUnit?.orderWithinService, MockModel.serviceCurrentStep)
        
        XCTAssertEqual(service.canceledDescription, nil)
        XCTAssertEqual(service.stateDescription, "서비스 완료")
        XCTAssertEqual(service.stateColor.hashValue, UIColor(hex: "#F5F5F5").hashValue)
        
        //optional
        let optionalService = MockModel.service_optional
        
        XCTAssertEqual(optionalService.id, Service.unknownId)
        XCTAssertEqual(optionalService.type, .unknown)
        XCTAssertEqual(optionalService.status, .unknown)
        XCTAssertEqual(optionalService.phase, .waiting)
        XCTAssertEqual(optionalService.serviceNumber, "-")
        XCTAssertNotEqual(optionalService.requestedAt, MockModel.createdAt)
        XCTAssertEqual(optionalService.startedAt, nil)
        XCTAssertEqual(optionalService.finishedAt, nil)
        XCTAssertEqual(optionalService.robot, nil)
        XCTAssertEqual(optionalService.creator.id, User.unknownId)
        XCTAssertEqual(optionalService.currentServiceUnitIdx, 0)
        XCTAssertEqual(optionalService.serviceUnits.isEmpty, true)
        XCTAssertEqual(optionalService.travelDistance, nil)
        XCTAssertEqual(optionalService.serviceLogSet.serviceLogs.isEmpty, true)
        
        //raw
        let rawService = try MockModel.service_raw()
        
        XCTAssertEqual(rawService.id, MockModel.id)
        XCTAssertEqual(rawService.type, .general)
        XCTAssertEqual(rawService.status, .finished)
        XCTAssertEqual(rawService.phase, .completed)
        XCTAssertEqual(rawService.serviceNumber, MockModel.serviceNumber)
        XCTAssertEqual(rawService.requestedAt, MockModel.createdAt)
        XCTAssertNotEqual(rawService.startedAt, MockModel.createdAt)
        XCTAssertNotEqual(rawService.finishedAt, MockModel.createdAt)
        XCTAssertEqual(rawService.robot, nil)
        XCTAssertEqual(rawService.creator.username, MockModel.username)
        XCTAssertEqual(rawService.currentServiceUnitIdx, MockModel.serviceCurrentStep)
        XCTAssertEqual(rawService.serviceUnits.isEmpty, false)
        XCTAssertEqual(rawService.travelDistance, MockModel.serviceMovingDistance)
        XCTAssertEqual(rawService.serviceLogSet.serviceLogs.isEmpty, false)
        
        //canceled, failed, returning
        let canceledService = MockModel.canceledService()
        XCTAssertNotNil(canceledService.canceledDescription)
        XCTAssertNotNil(canceledService.stateDescription == "서비스 취소")
        
        let failedService = MockModel.failedService()
        XCTAssertNotNil(failedService.canceledDescription)
        XCTAssertNotNil(failedService.stateDescription == "서비스 취소")
        
        let returningCancledService = MockModel.canceledService(isStateReturning: true)
        XCTAssertNotNil(returningCancledService.canceledDescription)
        
        let returningFailedService = MockModel.failedService(isStateReturning: true)
        XCTAssertNotNil(returningFailedService.canceledDescription)
    }
    
    func testVersion() throws {
        
        let thisAppVersion = Version.thisAppVersion
        XCTAssertEqual(thisAppVersion.minimumBuildNumber, 1)
        XCTAssertEqual(thisAppVersion.currentBuildNumber.description, Info.appBuild)
        XCTAssertEqual(thisAppVersion.currentVersion, Info.appVersion)
        
        //basic
        let basicVersion = MockModel.version_basic_latest
        XCTAssertEqual(basicVersion.isLatest, true)
        XCTAssertEqual(basicVersion.mustUpdate, false)
        
        //optional
        let optionalVersion = MockModel.version_optional_new
        XCTAssertEqual(optionalVersion.isLatest, false)
        XCTAssertEqual(optionalVersion.mustUpdate, false)
        
        //mustUpdate
        let mustUpdateVersion = MockModel.version_must_update
        XCTAssertEqual(mustUpdateVersion.isLatest, false)
        XCTAssertEqual(mustUpdateVersion.mustUpdate, true)
    }
    
    func testServiceTemplate() throws {
        
        //basic
        let basicServiceTemplate = try MockModel.serviceTemplate_basic_general()
        
        XCTAssertEqual(basicServiceTemplate.id, MockModel.id)
        XCTAssertEqual(basicServiceTemplate.name, MockModel.displayName)
        XCTAssertTrue(basicServiceTemplate.type.isGeneral)
        XCTAssertEqual(basicServiceTemplate.description, MockModel.description)
        XCTAssertEqual(basicServiceTemplate.serviceBuilder.arguments.isEmpty, false)
        XCTAssertEqual(basicServiceTemplate.isCompiled, false)
        
        //optional
        let optionalServiceTemplate = try MockModel.serviceTemplate_optional_shortcut()
        
        XCTAssertEqual(optionalServiceTemplate.id, MockModel.id)
        XCTAssertEqual(optionalServiceTemplate.name, MockModel.displayName)
        XCTAssertTrue(optionalServiceTemplate.type.isShortcut)
        XCTAssertEqual(optionalServiceTemplate.description, nil)
        XCTAssertEqual(optionalServiceTemplate.serviceBuilder.arguments.isEmpty, true)
        XCTAssertEqual(optionalServiceTemplate.isCompiled, true)
    }
}
