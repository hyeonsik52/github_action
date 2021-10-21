//
//  ServiceUnitManagementCollectionViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit

class ServiceUnitManagementCollectionViewCell: UICollectionViewCell, View {
    
    private let backgroundHighlightView = UIView().then {
        $0.backgroundColor = .lightPurpleEDECF5
        $0.isHidden = true
    }
    private let bypassView = TRSBypassView()
    private let profileNumberView = ServiceDetailNumberProfileView()
    private let answerStateView = SRPStateView()
    private let serviceStateView = SRPStateView()
    private let freightsDescriptionView = UILabel().then {
        $0.font = .bold[20]
        $0.textColor = .purple4A3C9F
        $0.textAlignment = .right
        $0.lineBreakMode = .byTruncatingMiddle
    }
    private let messageView = SRPServiceUnitDetailView()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.contentView.clipsToBounds = true
        self.contentView.cornerRadius = 8
        self.contentView.backgroundColor = .white
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width-16*2)
        }
        
        self.contentView.addSubview(self.backgroundHighlightView)
        self.backgroundHighlightView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let topHorizontalStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 20
        }
        self.contentView.addSubview(topHorizontalStackView)
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

        topLeftVerticalStackView.addArrangedSubview(self.bypassView)
        self.bypassView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        topLeftVerticalStackView.addArrangedSubview(self.profileNumberView)
        self.profileNumberView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        topHorizontalStackView.addArrangedSubview(self.answerStateView)
        self.answerStateView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(42)
        }

        let bottomVerticalStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 19
        }
        self.contentView.addSubview(bottomVerticalStackView)
        bottomVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(topHorizontalStackView.snp.bottom).offset(30).priority(.high)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
        }

        let serviceObjectContainer = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 20
        }
        bottomVerticalStackView.addArrangedSubview(serviceObjectContainer)
        serviceObjectContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        serviceObjectContainer.addArrangedSubview(self.serviceStateView)
        self.serviceStateView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(53)
        }

        serviceObjectContainer.addArrangedSubview(self.freightsDescriptionView)
        self.freightsDescriptionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }

        bottomVerticalStackView.addArrangedSubview(self.messageView)
        self.messageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    func bind(reactor: ServiceUnitCellReactor) {
        
        let service = reactor.currentState.serviceSet.service
        let serviceUnit = reactor.currentState.serviceSet.serviceUnit
        
//        //내가 수신자가 아니거나, 거절자, 다른 수신자가 수락한 경우 하이라이트하지 않는다
//        self.backgroundHighlightView.isHidden = !serviceUnit.amIRecipient || serviceUnit.amIRejector || serviceUnit.isAnotherAccepted
//
//        if let waypoint = serviceUnit.bypassPlace {
//            self.bypassView.bind(text: waypoint.name)
//            self.bypassView.isHidden = false
//        }else{
//            self.bypassView.isHidden = true
//        }
//
//
//        let target = serviceUnit.target
//        let userTargetTeamName = (target as? ServiceUser)?.teamName
//        self.profileNumberView.bind(
//            number: reactor.currentState.serviceSet.serviceUnitOffset,
//            title: target.name,
//            content: userTargetTeamName,
//            profileImage: target.profileImageURL
//        )
//
//        if service.combinePause(conditions: .waitingResponse, .canceledOnWaiting) {
//            if serviceUnit.status == .rejected {
//                self.answerStateView.setReject()
//                self.answerStateView.isHidden = false
//            }else{
//                if serviceUnit.isAcceptorExisted {
//                    self.answerStateView.setAllow()
//                    self.answerStateView.isHidden = false
//                }else{
//                    self.answerStateView.isHidden = true
//                }
//            }
//        }else{
//            self.answerStateView.isHidden = true
//        }
//
//        if service.isProcessing {
//            if serviceUnit.isProcessing {
//                self.serviceStateView.setProcessing()
//                self.serviceStateView.isHidden = false
//            }else{
//                self.serviceStateView.isHidden = true
//            }
//        }else{
//            self.serviceStateView.isHidden = true
//        }
//
//
//        var taskList = serviceUnit.taskList
//        if taskList.isEmpty {
//            self.freightsDescriptionView.text = "물품이 없습니다."
//        }else if taskList.count == 1 {
//            self.freightsDescriptionView.text = taskList[0].object.name
//        }else{
//            let first = taskList.remove(at: 0)
//            let count = taskList.count
//
//            self.freightsDescriptionView.text = "\(first.object.name) 외 \(count)"
//        }
//
//        if let detail = serviceUnit.requestDetails {
//            self.messageView.bind(text: detail)
//            self.messageView.isHidden = false
//        }else{
//            self.messageView.isHidden = true
//        }
    }
}
