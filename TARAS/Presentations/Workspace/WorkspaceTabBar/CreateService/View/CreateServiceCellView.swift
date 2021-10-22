//
//  CreateServiceCellView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

final class CreateServiceCellView: UIView {
    
    let customBackgroundView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }

    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "navi-close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.tintColor = .grayA2A2A2
    }

    let targetInfoView = TargetInfoView()

    let messageView = SRPServiceUnitDetailView()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(self.customBackgroundView)
        self.customBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }

        let topHorizontalStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        self.customBackgroundView.addSubview(topHorizontalStackView)
        topHorizontalStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        let topLeftVerticalStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 6
        }
        topHorizontalStackView.addArrangedSubview(topLeftVerticalStackView)
        topLeftVerticalStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }

        topLeftVerticalStackView.addArrangedSubview(self.targetInfoView)
        self.targetInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        let deleteButtonContainer = UIView()
        deleteButtonContainer.addSubview(self.deleteButton)
        self.deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }

        topHorizontalStackView.addArrangedSubview(deleteButtonContainer)


        let bottomVerticalStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 20
        }
        self.customBackgroundView.addSubview(bottomVerticalStackView)
        bottomVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(topHorizontalStackView.snp.bottom).offset(30).priority(.high)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }

        bottomVerticalStackView.addArrangedSubview(self.messageView)
        self.messageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ serviceUnitModel: CreateServiceUnitModel) {
        
        // 대상 정보를 표출합니다.
//        self.targetInfoView.bind(self.targetInfo(serviceUnitModel))
        
        // 품목 정보를 표출합니다.
//        let serviceUnitInfo = serviceUnitModel.serviceUnit.info
//        let freights = serviceUnitInfo.freights.compactMap { $0 }
//        self.freightsDescriptionLabel.text = self.freightsDescription(freights)
        
        // 상세 요청 사항을 표출합니다.
        // 메시지 입력 -> 수정 -> 메시지 삭제 시 nil 대신 "" 이 넘어와서 count 로 처리해놓았습니다.
//        if let optMessage = serviceUnitInfo.message, let message = optMessage, message.count > 0 {
//            self.messageView.bind(text: message)
//            self.messageView.isHidden = false
//        } else {
//            self.messageView.isHidden = true
//        }
    }

//    fileprivate func targetInfo(
//        _ serviceUnitModel: CreateServiceUnitModel
//    ) -> CreateServiceTargetInfoModel {
//        let serviceUnit = serviceUnitModel.serviceUnit
//        let targetType = serviceUnit.info.targetType
//
//        if targetType == .recipient {
//            if let recipient = serviceUnit.info.recipients.compactMap({ $0 }).first {
//                return .init(
//                    idx: recipient.targetIdx,
//                    name: serviceUnit.targetName,
//                    groupName: serviceUnit.targetGroupName,
//                    targetType: (recipient.targetType == .user) ? .user : .group
//                )
//            }
//        }
//        // targetType == .stop 인 경우입니다.
//        return .init(
//            idx: (serviceUnit.info.stopIdx ?? 0) ?? 0,
//            name: serviceUnit.targetName,
//            groupName: serviceUnit.targetGroupName,
//            targetType: .stop
//        )
//    }
    
//    func freightsDescription(_ freights: [CreateServiceUnitFreightInput]) -> String {
//        var freights = freights
//
//        if freights.count == 1 {
//            return freights[0].name
//        } else if freights.count > 1 {
//            let first = freights.remove(at: 0)
//            let count = freights.count
//            return "\(first.name) 외 \(count)"
//        }
//        return "(물품 없음)"
//    }
}
