//
//  MockModel.swift
//  TARAS-DevTests
//
//  Created by nexmond on 2022/03/07.
//

import Foundation
@testable import TARAS_Dev

struct MockModel {
    
    static let id = "01234567-abcd-bcde-cdef-890123456789"
    static let username = "username"
    static let displayName = "displayName"
    static let email = "a@b.cd"
    static let phoneNumber = "01012345678"
    static let password = "hgfH432!"
    
    static let userRole = UserRole.member
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateFormatter.locale = locale
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        return dateFormatter
    }()
    
    static var createdAt = Date()
    static var createdAtString = MockModel.createdAt.ISO8601Format
    
    //MARK: - Account
    static var account_basic: Account {
        
        let fragment = UserFragment(
            id: self.id,
            username: self.username,
            displayName: self.displayName,
            email: self.email
        )
        
        return .init(fragment)
    }
    
    static var account_optional: Account {
        
        let optionalFragment = UserFragment(
            id: self.id,
            username: self.username,
            displayName: self.displayName
        )
        
        return .init(option: optionalFragment)
    }
    
    //MARK: - User
    static var user_basic: User {
        
        let fragment = UserFragment(
            id: self.id,
            username: self.username,
            displayName: self.displayName,
            email: self.email,
            phoneNumber: self.phoneNumber
        )
        
        return .init(fragment)
    }
    
    static var user_optional: User {
        
        let optionalFragment = UserFragment(
            id: self.id,
            username: self.username,
            displayName: self.displayName
        )
        
        return .init(option: optionalFragment)
    }
    
    static var user_member: User? {
        
        let memberFragment = MemberFragment(
            id: self.id,
            username: self.username,
            displayName: self.displayName,
            email: self.email,
            phoneNumber: self.phoneNumber,
            role: self.userRole
        )
        
        return .init(member: memberFragment)
    }
    
    static var user_raw: User {
        
        let rawFragment = UserRawFragment(
            id: self.id,
            username: self.username,
            displayName: self.displayName,
            email: self.email,
            phoneNumber: self.phoneNumber
        )
        
        return .init(rawFragment)
    }
    
    //MARK: - Robot
    static var robot_basic: Robot {
        
        let fragment = RobotFragment(
            id: self.id,
            name: self.displayName
        )
        
        return .init(fragment)
    }
    
    static var robot_optional: Robot {
        
        let optionalFragment = RobotFragment(
            id: self.id
        )
        
        return .init(option: optionalFragment)
    }
    
    static var robot_raw: Robot {
        
        let rawFragment = RobotRawFragment(
            key: self.id,
            name: self.displayName
        )
        
        return .init(rawFragment)
    }
    
    //MARK: - Stop
    static func stop_basic(type: StopType) -> Stop {
        
        let remark = "{\"type\": \"\(type.rawValue.uppercased())\", \"env_map_id\": \"\(self.id)\", \"gateway_station_group_id\": \"\(self.id)\"}"
        
        //basic
        let fragment = StopFragment(
            id: self.id,
            name: self.displayName,
            isStop: true,
            remark: remark
        )
        
        return .init(fragment)
    }
    
    static var stop_optional: Stop {
        
        let optionalFragment: StopFragment? = nil
        
        return .init(option: optionalFragment)
    }
    
    static func stop_raw(type: StopType) throws -> Stop {
        
        let remark = "{\"type\": \"\(type.rawValue.uppercased())\", \"env_map_id\": \"\(self.id)\"}"
        
        //raw
        let rawFragment = StopRawFragment(
            id: self.id,
            name: self.displayName,
            isStop: true,
            remark: try .init(jsonValue: remark)
        )
        
        return .init(option: rawFragment)
    }
    
    //MARK: - Workspace
    static let workspaceCode = "ws-code"
    static let workspaceMemberCount = 1
    static let myMemberStatus = WorkspaceMemberState.member
    
    static var workspace_basic: Workspace {
        
        let fragment = WorkspaceFragment(
            id: self.id,
            name: self.displayName,
            code: self.workspaceCode,
            createdAt: self.createdAtString,
            members: .init(totalCount: self.workspaceMemberCount)
        )
        
        return .init(fragment)
    }
    
    static var workspace_optional: Workspace {
        
        let optionalFragment = WorkspaceFragment(
            id: self.id,
            name: self.displayName
        )
        
        return .init(option: optionalFragment)
    }
    
    static var workspace_only: Workspace {
        
        let onlyFragment = OnlyWorkspaceFragment(
            id: self.id,
            name: self.displayName,
            code: self.workspaceCode,
            createdAt: self.createdAt,
            role: self.userRole,
            isRequiredUserEmailToJoin: true,
            isRequiredUserPhoneNumberToJoin: true,
            totalMemberCount: self.workspaceMemberCount
        )
        
        return .init(only: onlyFragment)
    }
    
    //MARK: - ServiceUnit
    static let serviceUnitState = "serviceUnitState"
    static let serviceUnitMessage = "message"
    
    static var serviceUnit_basic: ServiceUnit {
        
        let remark = "{\"type\": \"\(StopType.normal.rawValue.uppercased())\", \"env_map_id\": \"\(self.id)\"}"
        
        let stop = ServiceUnitFragment.Stop(
            id: self.id,
            name: self.displayName,
            isStop: true,
            remark: remark
        )
        
        let receiver = ServiceUnitFragment.Receiver(
            id: self.id,
            username: self.username,
            displayName: self.displayName,
            email: self.email,
            phoneNumber: self.phoneNumber
        )
        
        let fragment = ServiceUnitFragment(
            id: self.id,
            index: self.serviceCurrentStep,
            state: self.serviceUnitState,
            message: self.serviceUnitMessage,
            stop: stop,
            receivers: [receiver]
        )
        
        return .init(fragment)
    }
    
    static var serviceUnit_optional: ServiceUnit {
        
        let fragment = ServiceUnitFragment(
            id: self.id,
            index: self.serviceCurrentStep,
            state: self.serviceUnitState
        )
        
        return .init(option: fragment)
    }
    
    static func serviceUnit_raw() throws -> ServiceUnit {
        
        let remark = "{\"type\": \"\(StopType.normal.rawValue.uppercased())\", \"env_map_id\": \"\(self.id)\"}"
        
        let rawStop = ServiceUnitRawFragment.Stop(
            id: self.id,
            name: self.displayName,
            isStop: true,
            remark: try .init(jsonValue: remark)
        )
        
        let rawReceiver = ServiceUnitRawFragment.Receiver(
            id: self.id,
            displayName: self.displayName
        )
        
        let rawFragment = ServiceUnitRawFragment(
            id: self.id,
            index: self.serviceCurrentStep,
            message: self.serviceUnitMessage,
            stop: rawStop,
            receivers: [rawReceiver]
        )
        
        return .init(rawFragment)
    }
    
    //MARK: - Service Log
    static func jsonForServiceLog(
        type: String,
        index: Int = 0,
        attributes: [String: Any] = [:]
    ) -> [String: Any] {
        var json: [String: Any] = [
            "time": Date().ISO8601Format,
            "type": type,
            "unit_index": index
        ]
        attributes.forEach { key, value in
            json[key] = value
        }
        return json
    }
    
    static func serviceLog(
        type: String,
        index: Int = 0,
        attributes: [String: Any] = [:]
    ) -> ServiceLog {
        return .init(
            json: self.jsonForServiceLog(type: type, index: index, attributes: attributes),
            with: [],
            creator: self.user_basic,
            robot: self.robot_basic
        )!
    }
    
    static var serviceLog_created: ServiceLog {
        return self.serviceLog(type: "service_created")
    }
    
    static var serviceLog_assigined: ServiceLog {
        return self.serviceLog(type: "robot_assigned")
    }
    
    static var serviceLog_departed: ServiceLog {
        return self.serviceLog(type: "robot_departed", index: 1)
    }
    
    static var serviceLog_arrived: ServiceLog {
        return self.serviceLog(type: "robot_arrived", index: 1)
    }
    
    static var serviceLog_jobDone: ServiceLog {
        return self.serviceLog(type: "job_done", index: 1)
    }
    
    static var serviceLog_finished: ServiceLog {
        return self.serviceLog(type: "service_finished", index: 1, attributes: ["description": "finished"])
    }
    
    static var serviceLog_canceled: ServiceLog {
        return self.serviceLog(type: "service_canceled", index: 1, attributes: ["canceler": self.displayName])
    }
    
    static func serviceLog_failed(description: String) -> ServiceLog {
        return self.serviceLog(type: "service_failed", index: 1, attributes: ["description": description])
    }
    
    //MARK: - ServiceLogSet
    static var jsonListFoServiceLogSet_complated: [[String: Any]] {
        return [
            self.jsonForServiceLog(type: "service_created"),
            self.jsonForServiceLog(type: "robot_assigned"),
            self.jsonForServiceLog(type: "robot_departed", index: 1),
            self.jsonForServiceLog(type: "robot_arrived", index: 1),
            self.jsonForServiceLog(type: "job done", index: 1),
            self.jsonForServiceLog(type: "robot_departed", index: 2),
            self.jsonForServiceLog(type: "robot_arrived", index: 2),
            self.jsonForServiceLog(type: "job done", index: 2),
            self.jsonForServiceLog(type: "robot_departed", index: 3),
            self.jsonForServiceLog(type: "robot_arrived", index: 3),
            self.jsonForServiceLog(type: "job done", index: 3),
            self.jsonForServiceLog(type: "service_finished", index: 3, attributes: ["description": "finished"])
        ]
    }
    
    static var serviceLogSet_completed: ServiceLogSet {
        return .init(
            jsonList: self.jsonListFoServiceLogSet_complated,
            with: [],
            creator: self.user_basic,
            robot: self.robot_basic
        )
    }
    
    //MARK: - Service
    static let servicePhase = "Done"
    static let serviceType = "GENERAL"
    static let serviceState = "Finished"
    static let serviceNumber = "991231A999"
    static let serviceMovingDistance: Double = 16.842
    static let serviceCurrentStep = 3
    
    static func service_basic() throws -> Service {
        
        let robot = ServiceFragment.Robot(
            id: self.id,
            name: self.displayName
        )
        
        let timestamps = try GenericScalar(jsonValue: self.jsonListFoServiceLogSet_complated)
        
        let creator = try GenericScalar(jsonValue: [
            "id": self.username,
            "name": self.displayName,
            "type": "user"
        ])
        
        let stop: [String : Any] = [
            "__typename": "StationGroupNode",
            "id": self.id,
            "name": self.displayName,
            "isStop": true,
            "remark": "{\"type\": \"\(StopType.normal.rawValue.uppercased())\", \"env_map_id\": \"\(self.id)\"}"
        ]
        
        let receiver = [
            "__typename": "UserNode",
            "id": self.id,
            "username": self.username,
            "displayName": self.displayName,
            "email": self.email,
            "phoneNumber": self.phoneNumber
        ]
        
        let serviceUnits: [ServiceFragment.ServiceUnit] = [
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "0",
                "index": 0,
                "state": "Finished",
                "message": nil,
                "stop": nil,
                "receivers": []
            ]),
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "1",
                "index": 1,
                "state": "Finished",
                "message": "",
                "stop": stop,
                "receivers": [receiver]
            ]),
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "2",
                "index": 2,
                "state": "Finished",
                "message": "",
                "stop": stop,
                "receivers": [receiver]
            ]),
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "3",
                "index": 3,
                "state": "Finished",
                "message": "",
                "stop": stop,
                "receivers": [receiver]
            ]),
        ]
        
        let fragment = ServiceFragment(
            id: self.id,
            phase: self.servicePhase,
            type: self.serviceType,
            state: self.serviceState,
            timestamps: timestamps,
            serviceNumber: self.serviceNumber,
            createdAt: self.createdAt,
            creator: creator,
            robot: robot,
            currentServiceUnitStep: self.serviceCurrentStep,
            serviceUnits: serviceUnits,
            totalMovingDistance: self.serviceMovingDistance
        )
        
        return .init(fragment)
    }
    
    static var service_optional: Service {
        let optionalFragment: ServiceFragment? = nil
        return .init(option: optionalFragment)
    }
    
    static func service_raw() throws -> Service {
        
        let timestamps = try GenericScalar(jsonValue: self.jsonListFoServiceLogSet_complated)
        
        let creator = try GenericScalar(jsonValue: [
            "id": self.username,
            "name": self.displayName,
            "type": "user"
        ])
        
        let stop: [String : Any] = [
            "__typename": "StationGroupNode",
            "id": self.id,
            "name": self.displayName,
            "isStop": true,
            "remark": try GenericScalar(jsonValue: [
                "type": StopType.normal.rawValue.uppercased(),
                "env_map_id": self.id
            ])
        ]
        
        let serviceUnits: [ServiceRawFragment.ServiceUnit] = [
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "0",
                "index": 0,
                "state": "Finished",
                "message": nil,
                "stop": nil,
                "receivers": []
            ]),
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "1",
                "index": 1,
                "state": "Finished",
                "message": "",
                "stop": stop,
                "receivers": []
            ]),
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "2",
                "index": 2,
                "state": "Finished",
                "message": "",
                "stop": stop,
                "receivers": []
            ]),
            .init(unsafeResultMap: [
                "__typename": "ServiceUnitNode",
                "id": "3",
                "index": 3,
                "state": "Finished",
                "message": "",
                "stop": stop,
                "receivers": []
            ]),
        ]
        
        let fragment = ServiceRawFragment(
            id: self.id,
            phase: self.servicePhase,
            type: self.serviceType,
            serviceState: self.serviceState,
            timestamps: timestamps,
            serviceNumber: self.serviceNumber,
            createdAt: self.createdAt,
            creator: creator,
            robot: nil,
            currentServiceUnitStep: self.serviceCurrentStep,
            serviceUnits: serviceUnits,
            totalMovingDistance: self.serviceMovingDistance
        )
        
        return .init(fragment)
    }
    
    static func canceledService(isStateReturning: Bool = false) -> Service {
        return .init(
            id: self.id,
            type: .general,
            status: isStateReturning ? .returning: .canceled,
            phase: .canceled,
            serviceNumber: self.serviceNumber,
            requestedAt: self.createdAt,
            startedAt: nil,
            finishedAt: nil,
            robot: nil,
            creator: self.user_basic,
            serviceUnits: [self.serviceUnit_basic],
            currentServiceUnitIdx: 0,
            travelDistance: nil,
            serviceLogSet: .init(serviceLogs: [
                self.serviceLog(type: "service_created"),
                self.serviceLog(type: "service_canceled", attributes: ["canceler": self.displayName])
            ])
        )
    }
    
    static func failedService(isStateReturning: Bool = false) -> Service {
        return .init(
            id: self.id,
            type: .general,
            status: isStateReturning ? .returning: .failed,
            phase: .canceled,
            serviceNumber: self.serviceNumber,
            requestedAt: self.createdAt,
            startedAt: Date(),
            finishedAt: Date(),
            robot: self.robot_basic,
            creator: self.user_basic,
            serviceUnits: [self.serviceUnit_basic],
            currentServiceUnitIdx: 1,
            travelDistance: self.serviceMovingDistance,
            serviceLogSet: .init(serviceLogs: [
                self.serviceLog(type: "service_created"),
                self.serviceLog(type: "robot_assigned"),
                self.serviceLog(type: "robot_departed", index: 1),
                self.serviceLog(type: "robot_arrived", index: 1),
                self.serviceLog(type: "service_failed", index: 1, attributes: ["description": "robot"])
            ])
        )
    }
    
    //MARK: - Version
    static var version_basic_latest: Version {
        
        let fragment = VersionFragment(
            minVersionCode: 1,
            currentVersionCode: 1,
            currentVersionName: "0.0.1"
        )
        
        return .init(fragment)
    }
    
    static var version_optional_new: Version {
        
        let optionalFragment = VersionFragment(
            minVersionCode: 1,
            currentVersionCode: 9999999,
            currentVersionName: "99.99.99"
        )
        
        return .init(option: optionalFragment)
    }
    
    static var version_must_update: Version {
        
        let mustUpdateFragment = VersionFragment(
            minVersionCode: 9999999,
            currentVersionCode: 9999999,
            currentVersionName: "99.99.99"
        )
        
        return .init(mustUpdateFragment)
    }
    
    //MARK: - ServiceTemplate
    static let description = "description"
    
    static func serviceTemplate_basic_general() throws -> ServiceTemplate {
        
        let arguments: [ServiceTemplateRawFragmnet.Argument] = [
            try .init(ServiceArgumentRawFragment(
                id: "1",
                arrayOf: true,
                inputType: .init(
                    name: "destinations",
                    childArguments: [
                        try .init(ServiceArgumentRawFragment(
                            id: "1",
                            arrayOf: false,
                            inputType: .init(
                                name: "String",
                                childArguments: []
                            ),
                            name: "ID",
                            required: true,
                            displayText: "목적지",
                            uiComponentType: "select",
                            uiComponentDefaultValue: "",
                            model: "$TARAS:station_group",
                            needToSet: true
                        )),
                        try .init(ServiceArgumentRawFragment(
                            id: "2",
                            arrayOf: false,
                            inputType: .init(
                                name: "String",
                                childArguments: []
                            ),
                            name: "message",
                            required: true,
                            displayText: "요청사항",
                            uiComponentType: "input",
                            uiComponentDefaultValue: "",
                            model: "",
                            needToSet: true
                        )),
                        try .init(ServiceArgumentRawFragment(
                            id: "3",
                            arrayOf: false,
                            inputType: .init(
                                name: "Boolean",
                                childArguments: []
                            ),
                            name: "is_waited",
                            required: true,
                            displayText: "작업 대기 여부",
                            uiComponentType: "checkbox",
                            uiComponentDefaultValue: "true",
                            model: "",
                            needToSet: true
                        )),
                        try .init(ServiceArgumentRawFragment(
                            id: "4",
                            arrayOf: false,
                            inputType: .init(
                                name: "String",
                                childArguments: []
                            ),
                            name: "event_name",
                            required: false,
                            displayText: "이벤트 이름",
                            uiComponentType: "input",
                            uiComponentDefaultValue: "",
                            model: "",
                            needToSet: false
                        )),
                        try .init(ServiceArgumentRawFragment(
                            id: "5",
                            arrayOf: false,
                            inputType: .init(
                                name: "String",
                                childArguments: []
                            ),
                            name: "timestamp_key",
                            required: false,
                            displayText: "타임스탬프 키",
                            uiComponentType: "input",
                            uiComponentDefaultValue: "",
                            model: "",
                            needToSet: false
                        )),
                        try .init(ServiceArgumentRawFragment(
                            id: "7",
                            arrayOf: true,
                            inputType: .init(
                                name: "Receiver",
                                childArguments: [
                                    try .init(ServiceArgumentRawFragment(
                                        id: "6",
                                        arrayOf: false,
                                        inputType: .init(
                                            name: "String",
                                            childArguments: []
                                        ),
                                        name: "ID",
                                        required: true,
                                        displayText: "수신자",
                                        uiComponentType: "select",
                                        uiComponentDefaultValue: "",
                                        model: "$TARAS:user",
                                        needToSet: true
                                    ))
                                ]
                            ),
                            name: "receivers",
                            required: true,
                            displayText: "수신자",
                            uiComponentType: "receivers",
                            uiComponentDefaultValue: "",
                            model: "",
                            needToSet: true
                        )),
                        try .init(ServiceArgumentRawFragment(
                            id: "20",
                            arrayOf: true,
                            inputType: .init(
                                name: "String",
                                childArguments: []
                            ),
                            name: "img_urls",
                            required: false,
                            displayText: "사진 목록",
                            uiComponentType: "input",
                            uiComponentDefaultValue: "",
                            model: "",
                            needToSet: false
                        )),
                        try .init(ServiceArgumentRawFragment(
                            id: "17",
                            arrayOf: false,
                            inputType: .init(
                                name: "String",
                                childArguments: []
                            ),
                            name: "name",
                            required: true,
                            displayText: "목적지 이름",
                            uiComponentType: "input",
                            uiComponentDefaultValue: "",
                            model: "$TARAS:station_group",
                            needToSet: true
                        ))
                    ]),
                name: "destinations",
                required: true,
                displayText: "목적지",
                uiComponentType: "destinations",
                uiComponentDefaultValue: "",
                model: "",
                needToSet: true
            )),
            try .init(ServiceArgumentRawFragment(
                id: "2",
                arrayOf: false,
                inputType: .init(
                    name: "Integer",
                    childArguments: []
                ),
                name: "repeat_count",
                required: true,
                displayText: "반복횟수",
                uiComponentType: "input",
                uiComponentDefaultValue: "1",
                model: "",
                needToSet: true
            ))
        ]
        
        let fragment = ServiceTemplateRawFragmnet(
            id: self.id,
            name: self.displayName,
            serviceType: self.serviceType,
            description: self.description,
            isCompiled: false,
            arguments: arguments
        )
        
        return .init(fragment)
    }
    
    static func serviceTemplate_optional_shortcut() throws -> ServiceTemplate {
        
        let optionalFragment = ServiceTemplateRawFragmnet(
            id: self.id,
            name: self.displayName,
            serviceType: self.serviceType,
            description: nil,
            isCompiled: true,
            arguments: []
        )
        
        return .init(option: optionalFragment)
    }
}
