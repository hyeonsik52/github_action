//
//  WorkspaceListCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/06/23.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class WorkspaceListCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = WorkspaceListCellReactor
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Twinny_대전 지사"
        $0.textColor = .black
        $0.font = .bold.16
        $0.numberOfLines = 2
    }
    
    let memberCountLabel = UILabel().then {
        $0.text = "회원 123명"
        $0.textColor = .grayA0A0A0
        $0.font = .regular.12
    }
    
    private let separatorLabel = UILabel().then {
        $0.text = " ㆍ "
        $0.textColor = .grayA0A0A0
        $0.font = .regular.12
    }
    
    let createdAtLabel = UILabel().then {
        $0.text = "20.05.10 생성"
        $0.textColor = .grayA0A0A0
        $0.font = .regular.12
    }
    
    
    // MARK: - Init
    
    override func initial() {
        super.initial()
        
        self.setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.titleLabel.text = nil
        self.memberCountLabel.text = nil
        self.createdAtLabel.text = nil
    }
    
    
    // MARK: Binding

    func bind(reactor: Reactor) {
        self.titleLabel.text = reactor.currentState.name
        // info.createAt: '2020-05-11T15:13:57+09:00' 형태의 String
        // ISO8601DateFormatter를 통해 Date 타입으로 변환 후, Formatter 로 String 재 변환
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: reactor.currentState.creatAt ?? "")
        self.createdAtLabel.text = Formatter.YYMMDD.string(from: date ?? Date()) + " 생성"
        self.memberCountLabel.text = "회원 \(reactor.currentState.memberCount ?? 0)명"
        self.profileImageView.setImage(strUrl: reactor.currentState.profileImageURL)
    }
    
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
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
