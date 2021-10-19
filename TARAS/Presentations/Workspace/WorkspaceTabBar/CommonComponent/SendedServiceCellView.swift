//
//  SendedServiceCellView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class SendedServiceCellView: UIView {
    
    private var imageViews = [UIImageView]()
    
    private var titleLabel = UILabel().then{
        $0.font = .bold.20
        $0.textColor = .black
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
    }
    
    private var secondaryLabel = UILabel().then{
        $0.font = .medium.16
        $0.textColor = .black
    }
    
    private var targetsView: ServiceTargetsView!
    
    private var targetContentLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .black
        $0.lineBreakMode = .byTruncatingMiddle
    }
    
    private var tertiaryLabel = UILabel().then{
        $0.font = .medium.16
        $0.textColor = .grayA0A0A0
    }
    
    ///작업 진행 순번 ex) 3/12
    private var requestStatusContainer = UIView().then {
        $0.clipsToBounds = true
        $0.cornerRadius = 6
        $0.backgroundColor = .lightGrayF1F1F1
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
    }
    private var requestStatusLabel = UILabel().then {
        $0.font = .bold.14
        $0.textColor = .purple4A3C9F
    }
    
    ///작업 순번과 위치 ex) 3 회의실
    private var sequenceContainer = UIView()
    private var sequenceNumberLabel = UILabel().then {
        $0.clipsToBounds = true
        $0.cornerRadius = 10
        $0.backgroundColor = .skyBlue85AEFF
        $0.textAlignment = .center
        $0.font = .bold.12
        $0.textColor = .white
    }
    private var placeLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .black
    }
    
    convenience init(_ maxWidth: CGFloat = UIScreen.main.bounds.width) {
        self.init(frame: .zero)
        
        self.setupConstraints(maxWidth)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ maxWidth: CGFloat) {
        
        self.backgroundColor = .lightGrayF1F1F1
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(30)
            $0.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
        
        
        self.addSubview(self.requestStatusContainer)
        self.requestStatusContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(16)
        }
        
        self.requestStatusContainer.addSubview(self.requestStatusLabel)
        self.requestStatusLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalToSuperview().offset(2)
            $0.bottom.equalToSuperview().offset(-2)
        }
        
        
        //컨테이너 만들고 넣기, 용도에 따라 on off 해서 사용
        self.addSubview(self.sequenceContainer)
        self.sequenceContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        self.sequenceNumberLabel.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
        self.sequenceContainer.addSubview(self.sequenceNumberLabel)
        self.sequenceNumberLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        self.sequenceContainer.addSubview(self.placeLabel)
        self.placeLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(self.sequenceNumberLabel.snp.trailing).offset(4)
        }
        
        
        self.addSubview(self.secondaryLabel)
        self.secondaryLabel.snp.makeConstraints{
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        self.targetsView = ServiceTargetsView(maxWidth - 30*2)
        self.addSubview(self.targetsView)
        self.targetsView.snp.makeConstraints{
            $0.top.equalTo(self.secondaryLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        self.addSubview(self.targetContentLabel)
        self.targetContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.targetsView)
            $0.leading.equalTo(self.targetsView).offset(40)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        self.addSubview(self.tertiaryLabel)
        self.tertiaryLabel.snp.makeConstraints{
            $0.top.equalTo(self.targetsView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
    }
    
    func bind(
        title: String?,
        subTitle: String?,
        detail: String?,
//        targets: [ServiceNode],
        targetContent: String? = nil//,
//        answerStates: AnswerStates? = nil,
//        sequenceInfo: (number: Int, node: ServiceNode)? = nil
    ) {
        
        self.titleLabel.text = title
        
//        if let answerStates = answerStates {
//            self.requestStatusContainer.isHidden = false
//            self.requestStatusLabel.text = "\(answerStates.accepted)/\(answerStates.total)"
//        }else{
//            self.requestStatusContainer.isHidden = true
//            self.requestStatusLabel.text = nil
//        }
//
//        if let sequenceInfo = sequenceInfo {
//            self.sequenceContainer.isHidden = false
//            self.sequenceNumberLabel.text = sequenceInfo.number.description
//            self.placeLabel.text = sequenceInfo.node.name
//        }else{
//            self.sequenceContainer.isHidden = true
//            self.sequenceNumberLabel.text = nil
//            self.placeLabel.text = nil
//        }
        
        self.secondaryLabel.text = subTitle
        
//        self.targetsView.bind(targets)
        self.targetContentLabel.text = targetContent == nil ? nil: "\(targetContent!)님의 요청"
        
        self.tertiaryLabel.text = detail
    }
}
