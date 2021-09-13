//
//  WorkspaceSearchResultView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/05/06.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

class WorkspaceSearchResultView: UIView {
    
    enum Text {
        static let WSSRV_1 = "찾으신 워크스페이스가 맞나요?\n하단 버튼을 눌러 가입해보세요."
        static let WSSRV_2 = "이미 가입한 워크스페이스입니다. "
        static let WSSRV_3 = "가입 신청하기"
        static let WSSRV_4 = "입장하기"
        static let WSSRV_5 = "가입 신청 취소하기"
        static let WSSRV_6 = "가입 신청을 완료하였습니다."
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = .bold.22
        $0.numberOfLines = 0
    }
    
    let createdAtLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .grayA0A0A0
        $0.font = .bold.14
        $0.numberOfLines = 0
    }
    
    let memberCountLabel = UILabel().then {
        $0.textColor = .purple4A3C9F
        $0.backgroundColor = .LIGHT_PUPLE_EBEAF4
        $0.font = .bold.13
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    let guideLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .medium.16
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
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(86)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.createdAtLabel)
        self.createdAtLabel.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(self.memberCountLabel)
        self.memberCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.createdAtLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(0)
            $0.height.equalTo(30)
        }
        
        self.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalTo(self.memberCountLabel.snp.bottom).offset(32)
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
    
    func setupView(with info: WorkspaceListCellModel) {
        self.nameLabel.text = info.name
        // info.createAt: '2020-05-11T15:13:57+09:00' 형태의 String
        // ISO8601DateFormatter를 통해 Date 타입으로 변환 후, Formatter 로 String 재 변환
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: info.creatAt ?? "")
        self.createdAtLabel.text = Formatter.YYMMDD.string(from: date ?? Date()) + " 생성"
        self.memberCountLabel.text = "회원 \(info.memberCount ?? 0)명"
        self.enterButton.setBackgroundColor(color: .purple4A3C9F, forState: .normal)
        
        if let profileImageURL = info.profileImageURL, let url = URL(string: profileImageURL) {
            self.profileImageView.kf.setImage(with: url)
        }
        
        switch info.joinState {
        case .new, .none:
            self.guideLabel.text = Text.WSSRV_1
            self.enterButton.setTitle(Text.WSSRV_3, for: .normal)
            
        case .joined:
            self.guideLabel.text = Text.WSSRV_2
            self.enterButton.setTitle(Text.WSSRV_4, for: .normal)
            
        case .requested:
            self.guideLabel.text = Text.WSSRV_6
            self.enterButton.setBackgroundColor(color: .grayE6E6E6, forState: .normal)
            self.enterButton.setTitle(Text.WSSRV_5, for: .normal)
        }
    }
}
