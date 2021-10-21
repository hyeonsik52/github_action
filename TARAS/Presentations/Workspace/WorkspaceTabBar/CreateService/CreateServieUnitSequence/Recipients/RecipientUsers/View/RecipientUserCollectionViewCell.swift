//
//  RecipientUserCollectionViewCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import ReactorKit

class RecipientUserCollectionViewCell: UICollectionViewCell, ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    /// 수신자의 프로필 이미지를 표출합니다.
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
        $0.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    /// 선택된 수신자를 선택 해제할 수 있습니다.
    let profileDeleteButton = UIButton().then {
        let image = UIImage(named: "navi-close")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .white
        $0.setImage(image, for: .normal)
        $0.setBackgroundColor(color: .black.withAlphaComponent(0.1), forState: .normal)
        $0.cornerRadius = 22
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    /// 수신자의 이름을 표출합니다.
    let nameLabel = UILabel().then {
        $0.font = .medium[14]
        $0.textAlignment = .center
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Binding
    
    func bind(reactor: RecipientUserCollectionViewCellReactor) {
        let recipientInfo = reactor.currentState
        
        self.nameLabel.text = recipientInfo.name
    }
    
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.top.centerX.equalToSuperview()
        }
        
        self.addSubview(self.profileDeleteButton)
        self.profileDeleteButton.snp.makeConstraints {
            $0.edges.equalTo(self.profileImageView)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview()
        }
    }
}
