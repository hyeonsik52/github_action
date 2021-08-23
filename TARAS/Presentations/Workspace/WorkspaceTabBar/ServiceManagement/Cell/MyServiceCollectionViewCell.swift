//
//  MyServiceCollectionViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import ReactorKit
import SkeletonView

class MyServiceCollectionViewCell: UICollectionViewCell, ReactorKit.View {
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
        
        let maxWidth = UIScreen.main.bounds.width - 22*2
        self.view = SendedServiceCellView(maxWidth)
        self.contentView.addSubview(self.view)
        self.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: ServiceCellReactor) {
        let service = reactor.currentState.service
        let item = reactor.currentState.service.serviceUnitList.enumerated().first{$0.element.status != .completed}
        let currentOffset = item?.offset ?? 0
        let currentNode = item?.element.target ?? ServicePlace(UID: "unknowned", idx: -1, name: "알 수 없는 위치입니다.")
        
        let isReceived = (reactor.mode == .managementReceived)
        
        let targets: [ServiceNode] = {
            if isReceived {
                return [service.creator]
            }else{
                return service.serviceUnitList.compactMap { $0.target }
            }
        }()
        let targetName = (isReceived ? targets.first!.name: nil)
        
        let title = service.statusString
        var subTitle = "\(service.serviceUnitList.count)개의 목적지"
        if isReceived {
            subTitle += " 중 \(service.myUpcomingTaskIndex+1)번째 작업"
        }
        let detail = service.serviceNumber
        
        let sequenceInfo = (service.endAt == nil ? (currentOffset+1, currentNode): nil)
        
        self.view.bind(
            title: title,
            subTitle: subTitle,
            detail: detail,
            targets: targets,
            targetContent: targetName,
            sequenceInfo: sequenceInfo
        )
    }
}
