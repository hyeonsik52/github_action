//
//  WorkspaceSearchResultView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkspaceSearchResultView: UIView {
    
    enum Text {
        static let WSSRV_1 = "찾으신 워크스페이스가 맞나요?\n하단 버튼을 눌러 가입해보세요."
        static let WSSRV_2 = "이미 가입한 워크스페이스입니다.\n하단 버튼을 눌러 입장하세요."
        static let WSSRV_3 = "가입 신청"
        static let WSSRV_4 = "워크스페이스 입장"
        static let WSSRV_5 = "가입 신청 취소"
        static let WSSRV_6 = "가입 신청중인 워크스페이스입니다."
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black0F0F0F
        $0.font = .bold[24]
        $0.numberOfLines = 0
    }
    
    let createdAtLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .gray9A9A9A
        $0.font = .bold[14]
    }
    
    let memberCountLabel = UILabel().then {
        $0.textColor = .purple4A3C9F
        $0.font = .bold[13]
        $0.textAlignment = .center
    }
    
    let guideLabel = UILabel().then {
        $0.textColor = .black0F0F0F
        $0.font = .medium[16]
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let enterButton = SRPButton(Text.WSSRV_3)
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constaraints
    
    func setupContraints() {
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.createdAtLabel)
        self.createdAtLabel.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        let memberCountContainer = UIView().then {
            $0.backgroundColor = .lightPurpleEBEAF4
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        self.addSubview(memberCountContainer)
        memberCountContainer.snp.makeConstraints {
            $0.top.equalTo(self.createdAtLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        memberCountContainer.addSubview(self.memberCountLabel)
        self.memberCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalTo(memberCountContainer.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.enterButton)
        self.enterButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func setupView(with info: Workspace) {
        
        self.nameLabel.text = info.name
        self.createdAtLabel.text = "\(info.createdAt.toString("yy.MM.dd")) 생성"
        self.memberCountLabel.text = "회원 \(info.memberCount)명"
        
        switch info.myMemberState {
        case .notMember:
            self.guideLabel.text = Text.WSSRV_1
            self.enterButton.setTitle(Text.WSSRV_3, for: .normal)
            self.enterButton.setBackgroundColor(color: .purple4A3C9F, forState: .normal)

        case .member:
            self.guideLabel.text = Text.WSSRV_2
            self.enterButton.setTitle(Text.WSSRV_4, for: .normal)
            self.enterButton.setBackgroundColor(color: .purple4A3C9F, forState: .normal)

        case .requestingToJoin:
            self.guideLabel.text = Text.WSSRV_6
            self.enterButton.setTitle(Text.WSSRV_5, for: .normal)
            self.enterButton.setBackgroundColor(color: .grayE6E6E6, forState: .normal)
        }
    }
}
