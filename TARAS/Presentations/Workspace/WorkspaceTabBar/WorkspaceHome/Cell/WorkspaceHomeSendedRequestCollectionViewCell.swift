//
//  WorkspaceHomeSendedRequestCollectionViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import ReactorKit
import SkeletonView

class WorkspaceHomeSendedRequestCollectionViewCell: UICollectionViewCell, ReactorKit.View {
    typealias Reactor = ServiceCellReactor
    
    var disposeBag = DisposeBag()
    
    private var view: SendedServiceCellView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.isSkeletonable = true
        
        self.view = SendedServiceCellView(260)
        self.contentView.addSubview(self.view)
        self.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: ServiceCellReactor) {
        let service = reactor.currentState.service
        
        let destinationTargets = service.serviceUnitList.compactMap{$0.receiverList.last}
        
        let title = service.statusString
        let subTitle = "\(service.serviceUnitList.count)개의 목적지"
        
        let assginTime = ((service.robotAssignAt ?? Date()).timeIntervalSince1970 - service.createAt.timeIntervalSince1970).toTimeString
        let detail = (service.status == .waitingRobotAssignment ? "로봇 배정 소요 시간 \(assginTime)" : (service.requestAt ?? service.createAt).overDescription)
        
        let answerStates = (service.status == .waitingResponse ? service.answerStates: nil)
        
        self.view.bind(
            title: title,
            subTitle: subTitle,
            detail: detail,
            targets: destinationTargets,
            answerStates: answerStates
        )
    }
}
