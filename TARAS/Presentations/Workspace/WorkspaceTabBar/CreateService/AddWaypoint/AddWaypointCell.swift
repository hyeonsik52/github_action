//
//  AddWaypointCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class AddWaypointUpperView: UIView {

    let disposeBag = DisposeBag()

    let barView = UIView().then {
        $0.backgroundColor = .lightPurpleEDECF5
    }

    let shadowView = UIImageView().then {
        $0.image = UIImage(named: "waypointShadow")
        $0.alpha = 0
    }

    let circleView = UIView().then {
        $0.backgroundColor = .skyBlue85AEFF
        $0.cornerRadius = 6
    }
    
    let button = UIButton()

    init() {
        super.init(frame: .zero)

        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        self.addSubview(self.barView)
        self.barView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
            $0.width.equalTo(4)
        }
        
        self.addSubview(self.shadowView)
        self.shadowView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        
        self.addSubview(self.circleView)
        self.circleView.snp.makeConstraints {
            $0.width.height.equalTo(12)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(self.button)
        self.button.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.center.equalToSuperview()
        }
    }
}

protocol CreateServiceWaypointCellDelegate: class {
    func didSelectWaypoint(willAppendAt: Int)
}

final class AddWaypointCell: BaseTableViewCell, ReactorKit.View {

    weak var waypointCellDelegate: CreateServiceWaypointCellDelegate?
    
    var cellIndex = PublishRelay<Int>()

    let upperView = AddWaypointUpperView()

    let cellView = CreateServiceCellView(isBypassCell: true).then {
        $0.deleteButton.isHidden = true
        $0.targetInfoView.arrowImageView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.upperView.shadowView.alpha = 0
    }

    override func initial() {
        self.setupConstraints()
    }

    private func setupConstraints() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear

        let stackView = UIStackView().then {
            $0.axis = .vertical
        }

        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }

        stackView.addArrangedSubview(self.upperView)
        self.upperView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(42)
        }

        stackView.addArrangedSubview(self.cellView)
        self.cellView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
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
//
//    fileprivate func targetInfo(
//        _ serviceUnitModel: CreateServiceUnitModel
//    ) -> CreateServiceTargetInfoModel {
//
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
//        // targetType == .stop
//        return .init(
//            idx: (serviceUnit.info.stopIdx ?? 0) ?? 0,
//            name: serviceUnit.targetName,
//            groupName: serviceUnit.targetGroupName,
//            targetType: .stop
//        )
//    }
    
    func bind(reactor: AddWaypointCellViewReactor) {
        
        UIView.animate(
            withDuration: 1.1,
            delay: 0,
            options: [.repeat, .autoreverse],
            animations: {
                self.upperView.shadowView.alpha = 1
                self.upperView.shadowView.layoutIfNeeded()
            }, completion: nil
        )

//        self.cellView.targetInfoView.bind(self.targetInfo(reactor.serviceUnitModel))

        // TODO: - 경유지 처리
        if reactor.serviceUnitModel.hasBypass {
            self.upperView.shadowView.isHidden = true
            self.upperView.circleView.isHidden = true
            self.upperView.button.isHidden = true
            self.cellView.bypassView.isHidden = false
            self.cellView.bypassView.bind(text: reactor.serviceUnitModel.bypass?.targetName ?? "")
            
            self.upperView.snp.updateConstraints {
                $0.height.equalTo(20)
            }
        } else {
            self.upperView.shadowView.isHidden = false
            self.upperView.circleView.isHidden = false
            self.upperView.button.isHidden = false
            self.cellView.bypassView.isHidden = true
            
            self.upperView.snp.updateConstraints {
                $0.height.equalTo(42)
            }
        }
        
        self.upperView.button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.waypointCellDelegate?.didSelectWaypoint(willAppendAt: self.upperView.button.tag)
            }).disposed(by: self.disposeBag)

        self.cellIndex
            .map { "\($0 + 1)" }
            .bind(to: self.cellView.targetInfoView.numberLabel.rx.text)
            .disposed(by: self.disposeBag)

        self.cellIndex
            .map { $0 == 0 }
            .bind(to: self.upperView.rx.isHidden)
            .disposed(by: self.disposeBag)

//        let serviceUnitInfo = reactor.serviceUnitModel.serviceUnit.info
//
//        // 품목 정보를 표출합니다.
//        let freights = serviceUnitInfo.freights.compactMap { $0 }
//        self.cellView.freightsDescriptionLabel.text = self.freightsDescription(freights)
//
//        // 상세 요청 사항을 표출합니다.
//        self.cellView.messageView.bind(text: (serviceUnitInfo.message ?? "") ?? "")
//        self.cellView.messageView.isHidden = (serviceUnitInfo.message == nil)
    }
}
