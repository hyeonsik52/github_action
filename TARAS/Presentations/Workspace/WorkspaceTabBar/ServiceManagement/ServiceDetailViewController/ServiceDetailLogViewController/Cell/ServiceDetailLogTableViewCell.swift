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
        $0.font = .medium[16]
        $0.numberOfLines = 0
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textColor = .gray9A9A9A
    }
    
    var disposeBag = DisposeBag()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
    }
    
    
    // MARK: - Constraints
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        let bottomLine = UIView().then {
            $0.backgroundColor = .grayF8F8F8
        }
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: - Binding
    
    func bind(reactor: ServiceLogCellReactor) {
        let serviceLog = reactor.currentState
        
        self.contentLabel.attributedText = serviceLog.type.styledMessage
        self.dateLabel.text = serviceLog.date.infoDateTimeFormatted
    }
}
