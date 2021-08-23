//
//  SRPProfileTextTagTableViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

class SRPProfileTextTagTableViewCell: UITableViewCell, ReactorKit.View {

    enum State {
        case none
        case allowed
        case rejected
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 22
        $0.backgroundColor = Color.GRAY_EDEDED
    }
    
    private let label = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = Color.BLACK_0F0F0F
    }
    
    private let stateView = SRPStateView()
    
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
        
        self.contentView.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(44)
        }
        
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 14
        }
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().offset(-22)
            $0.height.equalTo(22)
        }
        
        stackView.addArrangedSubview(self.label)
        self.label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(self.stateView)
        self.stateView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(42)
        }
    }
    
    func bind(text: String?, profileImage: String?, state: State = .none) {
        
        self.profileImageView.setImage(strUrl: profileImage)
        
        self.label.text = text
        
        if state == .allowed {
            self.stateView.setAllow()
        }else if state == .rejected {
            self.stateView.setReject()
        }
        self.stateView.isHidden = (state == .none)
    }
    
    func bind(reactor: ServiceTargetCellReactor) {
        
        let user = reactor.currentState.user
        let response = reactor.currentState.response
        let state: State = response == .accepted ? .allowed: (response == .rejected ? .rejected: .none)
        
        self.bind(
            text: user.name,
            profileImage: user.profileImageURL,
            state: state
        )
    }
}
