//
//  ReceivedRequestTableViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import ReactorKit

class ReceivedRequestTableViewCell: UITableViewCell, ReactorKit.View {
    
    typealias Reactor = ServiceCellReactor
    
    var disposeBag = DisposeBag()
    
    private var view = ReceivedServiceCellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.view)
        self.view.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
    }
    
    func bind(reactor: ServiceCellReactor) {
        let service = reactor.currentState.service
        let offset = reactor.currentState.serviceUnitOffset ?? -1
        let isAccepted = (reactor.currentState.serviceUnit?.isAcceptorExisted ?? false)
        
        let title = "\(service.serviceUnitList.count)개 목적지 중 \(offset+1)번째 작업"
        let subTitle = "\(service.creator.name)님의 요청"
        let detail = (isAccepted ? service.statusString: (service.requestAt ?? service.createAt).overDescription)
        
        self.view.bind(
            title: title,
            subTitle: subTitle,
            detail: detail,
            profileImageURL:
            service.creator.profileImageURL
        )
    }
}
