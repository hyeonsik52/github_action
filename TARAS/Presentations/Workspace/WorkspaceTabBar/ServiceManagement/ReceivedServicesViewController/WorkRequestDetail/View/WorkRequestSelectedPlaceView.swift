//
//  WorkRequestSelectedPlaceView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkRequestSelectedPlaceView: UIView {
    
    private var titleView = WorkRequestSectionTitleView(title: "작업 위치")
    
    private var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 22
        $0.backgroundColor = .LIGHT_PUPLE_EBEAF4
    }
    
    private var placeNameLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        let container = UIView()
        self.addSubview(container)
        container.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        container.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(44)
        }
        container.addSubview(self.placeNameLabel)
        self.placeNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().offset(-26)
        }
    }
    
    func bind(_ place: ServicePlace) {
        
        self.profileImageView.setImage(strUrl: place.profileImageURL)
        self.placeNameLabel.text = place.name
    }
}
