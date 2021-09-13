//
//  ServiceDetailLogTableViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit

class ServiceDetailLogTableViewCell: UITableViewCell, View {

    private let contentLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .black
        $0.lineBreakMode = .byTruncatingHead
        $0.numberOfLines = 0 //temp
    }
    private let dateLabel = UILabel().then {
        $0.font = .regular.12
        $0.textColor = .grayA0A0A0
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
    }
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
        }
        
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(self.contentLabel.snp.trailing).offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
    }
    
    func bind(reactor: ServiceLogCellReactor) {
        guard let log = reactor.currentState  else { return }
        
        self.contentLabel.text = log.description
        self.dateLabel.text = log.updateAt.overDescription
    }
}
