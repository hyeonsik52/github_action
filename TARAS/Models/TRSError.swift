//
//  TRSError.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

//import Foundation
//
///// 통합 오류 유형
//enum TRSError: Error {
//    /// 일반 오류
//    case common(CommonError)
//    /// 계정 관련 오류
//    case account(AccountError)
//    /// 워크스페이스 관련 오류
//    case workspace(WorkspaceError)
//    /// 기타 오류
//    case etc(String)
//}
//extension TRSError {
//
//    var description: String {
//        switch self {
//        case .common(let subError):
//            return subError.description
//        case .account(let subError):
//            return subError.description
//        case .workspace(let subError):
//            return subError.description
//        case .etc(let message):
//            return message
//        }
//    }
//}
//
///// 일반 오류 유형
//enum CommonError {
//    /// 네트워크 연결 유실
//    case networkNotConnect
//    /// 입력 형식 불만족
//    case invalidInputFormat(AccountInputType)
//    /// 타입 오류
//    case type(TypeErrorFragment)
//}
//extension CommonError {
//
//    var description: String {
//        switch self {
//        case .networkNotConnect:
//            return "네트워크 연결이 불안정합니다. 잠시 후 다시 시도해 주세요."
//        case .invalidInputFormat(let inputType):
//            return "\(inputType.rawValue) 형식이 올바르지 않습니다."
//        case .type(let error):
//            return """
//            ◦ 오류코드: \(error.typeErrorCode.rawValue)
//            ◦ \(error.key): \(error.value ?? "-")
//            │
//            ◦ 내용:
//            \(error.description ?? "-")
//            """
//        }
//    }
//}
//
///// 계정 관련 오류 유형
//enum AccountError {
//    /// 아아디 중복
//    case idExisted
//    /// 비밀번호 불일치 (비밀번호 재확인 시)
//    case passwordNotMatch
//    /// 존재하지 않는 아이디
//    case idNotExist
//    /// 아이디-비밀번호 불일치
//    case idPasswordNotMatch
//    /// 미등록 이메일 입력
//    case unregisteredEmail
//    /// 인증번호 불일치
//    case authNumberNotMatch
//    /// 아이디-이메일 불일치
//    case idEmailNotMatch
//    /// 틀린 비밀번호 입력
//    case invalidPassword
//}
//extension AccountError {
//
//    var description: String {
//        switch self {
//        case .idExisted:
//            return "이미 사용 중인 아이디입니다."
//        case .passwordNotMatch:
//            return "동일한 비밀번호를 입력해 주세요."
//        case .idNotExist:
//            return "존재하지 않는 아이디입니다."
//        case .idPasswordNotMatch:
//            return "아이디, 비밀번호를 확인해 주세요."
//        case .unregisteredEmail:
//            return "등록되어 있지 않은 이메일입니다."
//        case .authNumberNotMatch:
//            return "잘못된 인증번호입니다."
//        case .idEmailNotMatch:
//            return "등록된 이메일 정보와 일치하지 않습니다."
//        case .invalidPassword:
//            return "비밀번호를 확인해 주세요."
//        }
//    }
//}
//
///// 워크스페이스 관련 오류 유형
//enum WorkspaceError {
//    /// 유효하지 않은 코드
//    case invalidWorkspaceCode
//}
//extension WorkspaceError {
//
//    var description: String {
//        switch self {
//        case .invalidWorkspaceCode:
//            return "입력한 코드와 일치하는 워크스페이스가 없습니다."
//        }
//    }
//}
//
//
///// 서비스 오류 유형
//enum ServiceLogError: Error {
//    /// 경로 계획 실패
//    case pathPlanningFailure
//    /// 로봇 주행 실패
//    case robotDrivingFailure
//    /// 기기 오류
//    case robotError
//    /// 비상 정지
//    case emergencyStop
//    /// 연결 끊김
//    case disconnected
//    /// 알 수 없음
//    case unknown
//}
//extension ServiceLogError {
//
//    var description: String {
//        switch self {
//        case .pathPlanningFailure:
//            return "경로 생성에 실패하였습니다."
//        case .robotDrivingFailure:
//            return "로봇이 주행할 수 없는 환경입니다."
//        case .robotError:
//            return "로봇에 오류가 발생하였습니다."
//        case .emergencyStop:
//            return "비상 정지 버튼이 활성화되었습니다."
//        case .disconnected:
//            return "로봇의 연결이 끊어졌습니다."
//        case .unknown:
//            return "알 수 없는 오류가 발생했습니다."
//        }
//    }
//
//    init(raw: ErrorStatus) {
//        switch raw {
//        case .planningPathFailed:
//            self = .pathPlanningFailure
//        case .executionFailed:
//            self = .robotDrivingFailure
//        case .robotError:
//            self = .robotError
//        case .robotEmergency:
//            self = .emergencyStop
//        case .disconnected:
//            self = .disconnected
//        default:
//            self = .unknown
//        }
//    }
//}
//
//extension TypeErrorFragment {
//
//    var message: String {
//
//        let info: String = {
//            switch self.typeErrorCode {
//            case .required:
//                return "필수 값, \(self.key)(이)가 누락되었습니다."
//            case .invalidInteger,
//                 .invalidPosInteger,
//                 .invalidNegInteger,
//                 .invalidNonNegInteger,
//                 .invalidFloat,
//                 .invalidString,
//                 .invalidBoolean,
//                 .invalidBinary,
//                 .invalidDatetime,
//                 .invalidEnum,
//                 .invalidList:
//                return "잘못된 \(self.key)입니다."
//            case .tooSmallInteger,
//                 .tooSmallFloat:
//                guard let value = self.value else {
//                    return "\(self.key)(이)가 너무 작습니다."
//                }
//                return "\(self.key), '\(value)'(은)는 너무 작습니다."
//            case .tooBigInteger,
//                 .tooBigFloat:
//                guard let value = self.value else {
//                    return "\(self.key)(이)가 너무 큽니다."
//                }
//                return "\(self.key), '\(value)'(은)는 너무 큽니다."
//            case .tooShortString:
//                guard let value = self.value else {
//                    return "\(self.key)(이)가 너무 짧습니다."
//                }
//                return "\(self.key), '\(value)'(은)는 너무 짧습니다."
//            case .tooLongString:
//                guard let value = self.value else {
//                    return "\(self.key)(이)가 너무 깁니다."
//                }
//                return "\(self.key), '\(value)'(은)는 너무 깁니다."
//            case .__unknown(let value):
//                return "알 수 없는 오류입니다. (\(value))"
//            }
//        }()
//
//        return """
//            \(info)
//
//            참고: \(self.description ?? "-")
//            """
//    }
//}
