//
//  RecipientListCellView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

struct RecipientListCellModel {
    var type: ServiceUnitRecipientType
    var name: String
    var groupName: String?
}

class RecipientListCellView: UIView, ReactorKit.View {

    var disposeBag = DisposeBag()

    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.cornerRadius = 22
        $0.clipsToBounds = true
    }

    let nameLabel = UILabel().then {
        $0.font = Font.MEDIUM_16
        $0.textColor = Color.BLACK_0F0F0F
    }

    let groupNameLabel = UILabel().then {
        $0.text = "-"
        $0.font = Font.MEDIUM_12
        $0.textColor = Color.GRAY_999999
    }

    init() {
        super.init(frame: .zero)

        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: RecipientListCellViewReactor) {
        Observable
            .just(Reactor.Action.setData)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.name }
            .filterNil()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.groupName }
            .bind(to: self.groupNameLabel.rx.text)
            .disposed(by: self.disposeBag)
    }

    func setupConstraints() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(26)
        }

        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fillProportionally
        }

        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.centerY.equalTo(self.profileImageView)
            $0.trailing.lessThanOrEqualToSuperview().offset(-24)
        }

        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.groupNameLabel)
    }
}

