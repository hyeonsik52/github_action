//
//  TRSError.swift
//  TARAS-2.0
//
//  Created by nexmond on 2021/01/12.
//

import Foundation

/// 통합 오류 유형
enum TRSError: Error {
    /// 일반 오류
    case common(CommonError)
    /// 계정 관련 오류
    case account(AccountError)
    /// 워크스페이스 관련 오류
    case workspace(WorkspaceError)
    /// 기타 오류
    case etc(String)
    /// 오류 목록
    case list([TRSError])
    /// 인증 관련 오류
    case certify(CertifyError)
}
extension TRSError {

    var description: String {
        switch self {
        case .common(let subError):
            return subError.description
        case .account(let subError):
            return subError.description
        case .workspace(let subError):
            return subError.description
        case .etc(let message):
            return message
        case .list(let errors):
            return errors.map(\.description).reduce("", { "\($0) | \($1)" })
        case .certify(let subError):
            return subError.description
        }
    }
}

/// 일반 오류 유형
enum CommonError {
    /// 네트워크 연결 유실
    case networkNotConnect
    /// 입력 형식 불만족
    case invalidInputFormat(AccountInputType)
}
extension CommonError {

    var description: String {
        switch self {
        case .networkNotConnect:
            return "서버와 통신이 원활하지 않습니다."
        case .invalidInputFormat(let inputType):
            return "\(inputType.rawValue) 형식이 올바르지 않습니다."
        }
    }
}

/// 계정 관련 오류 유형
enum AccountError {
    /// 아아디 중복
    case idExisted
    /// 비밀번호 불일치 (비밀번호 재확인 시)
    case passwordNotMatch
    /// 존재하지 않는 아이디
    case idNotExist
    /// 아이디-비밀번호 불일치
    case idPasswordNotMatch
    /// 아이디-이메일 불일치
    case idEmailNotMatch
    /// 틀린 비밀번호 입력
    case invalidPassword
}
extension AccountError {

    var description: String {
        switch self {
        case .idExisted:
            return "이미 사용 중인 아이디입니다."
        case .passwordNotMatch:
            return "비밀번호가 일치하지 않습니다."
        case .idNotExist:
            return "존재하지 않는 아이디입니다."
        case .idPasswordNotMatch:
            return "아이디 또는 비밀번호가 일치하지 않습니다."
        case .idEmailNotMatch:
            return "등록된 이메일 정보와 일치하지 않습니다."
        case .invalidPassword:
            return "잘못된 비밀번호입니다."
        }
    }
}

/// 워크스페이스 관련 오류 유형
enum WorkspaceError {
    /// 유효하지 않은 코드
    case invalidWorkspaceCode
}
extension WorkspaceError {

    var description: String {
        switch self {
        case .invalidWorkspaceCode:
            return "입력한 코드와 일치하는 워크스페이스가 없습니다."
        }
    }
}


/// 서비스 오류 유형
enum ServiceLogError: Error {
    ///타임아웃
    case timeout
    ///로봇오류
    case byRobot
    ///서버오류
    case byServer
    ///비상정지
    case emergencyStop
    ///관리자 취소
    case canceledByManager
    ///기타
    case unknown
}
extension ServiceLogError {

    var description: String {
        switch self {
        case .timeout:
            return "대기시간 초과로 서비스가 취소되었습니다."
        case .byRobot:
            return "기기 오류로 서비스가 취소되었습니다."
        case .byServer:
            return "서버 오류로 서비스가 취소되었습니다."
        case .emergencyStop:
            return "비상정지로 서비스가 취소되었습니다."
        case .canceledByManager:
            return "관리자가 서비스를 취소하였습니다."
        case .unknown:
            return "알 수 없는 오류로 서비스가 취소되었습니다."
        }
    }

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
}

enum CertifyError: Error {
    /// 인증번호 발송
    case sendAuthNumber(String)
    /// 인증번호 확인
    case checkAuthNumber(String)
}
extension CertifyError {
    
    var description: String {
        switch self {
        case .sendAuthNumber(let message):
            if message.contains("already exists") {
                return "이미 사용중인 이메일입니다."
            } else if message.contains("does not exist") {
                return "등록되어 있지 않은 이메일입니다."
            } else if message.contains("유효한 이메일 주소를 입력하십시오.") {
                return "유효한 이메일 주소를 입력하십시오."
            } else if message.contains("failed to get verification code") {
                return "알 수 없는 오류로 실패했습니다. 잠시 후 다시 시도해주세요."
            } else if message.contains("requested too many authentications with same email") {
                return "동일한 이메일의 인증 요청 횟수를 초과했습니다. 관리자에게 문의해주세요."
            } else if message.contains("already requested with same email") {
                return "1분 이내에 동일한 이메일로 이미 요청되었습니다. 1분 후에 다시 시도해주세요."
            } else {
                return TRSError.common(.networkNotConnect).description
            }
        case .checkAuthNumber(let message):
            if message.contains("Invalid verification number") {
                return "인증번호가 일치하지 않습니다."
            } else if message.contains("No authentication request") {
                return "토큰이 유효하지 않습니다. 인증을 다시 시도해주세요."
            } else {
                return TRSError.common(.networkNotConnect).description
            }
        }
    }
}
