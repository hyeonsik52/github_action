//
//  WorkspaceListCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

final class WorkspaceListCell: BaseTableViewCell, ReactorKit.View {
    
    let titleLabel = UILabel().then {
        $0.textColor = .black0F0F0F
        $0.font = .bold[16]
        $0.numberOfLines = 2
    }
    
    let memberCountLabel = UILabel().then {
        $0.textColor = .gray9A9A9A
        $0.font = .regular[12]
    }
    
    private let separatorLabel = UILabel().then {
        $0.textColor = .gray9A9A9A
        $0.font = .regular[12]
    }
    
    let createdAtLabel = UILabel().then {
        $0.textColor = .gray9A9A9A
        $0.font = .regular[12]
    }
    
    
    // MARK: - Init
    
    override func initial() {
        super.initial()
        
        self.setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
        self.memberCountLabel.text = nil
        self.createdAtLabel.text = nil
    }
    
    
    // MARK: Binding

    func bind(reactor: WorkspaceListCellReactor) {
        let workspace = reactor.initialState
        
        self.titleLabel.text = workspace.name
        self.createdAtLabel.text = workspace.createdAt.toString("yy.MM.dd") + " 생성"
        self.memberCountLabel.text = "회원 \(reactor.currentState.memberCount)명"
    }
    
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        self.addSubview(self.memberCountLabel)
        self.memberCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(self.titleLabel)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        self.addSubview(self.separatorLabel)
        self.separatorLabel.snp.makeConstraints {
            $0.top.equalTo(self.memberCountLabel)
            $0.leading.equalTo(self.memberCountLabel.snp.trailing)
            $0.bottom.equalTo(self.memberCountLabel)
        }
        
        self.addSubview(self.createdAtLabel)
        self.createdAtLabel.snp.makeConstraints {
            $0.top.equalTo(self.memberCountLabel)
            $0.leading.equalTo(self.separatorLabel.snp.trailing)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalTo(self.memberCountLabel)
        }
    }
}
