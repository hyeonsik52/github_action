//
//  SettingWorkspaceInfoView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SettingWorkspaceInfoView: UIView {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 14
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .bold.18
        $0.textColor = .black
    }
    
    let disposeBag = DisposeBag()
    let didSelect = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22)
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.height.equalTo(50)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.profileImageView)
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(12)
        }
        
        let arrowImageView = UIImageView().then {
            $0.image = UIImage(named: "setting-detail")
            $0.contentMode = .center
        }
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(self.profileImageView)
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(2)
            $0.trailing.lessThanOrEqualToSuperview().offset(-18)
            $0.width.height.equalTo(18)
        }
        
        let button = UIButton()
        addSubview(button)
        button.snp.makeConstraints {
            $0.top.left.bottom.equalTo(self.profileImageView)
            $0.right.equalTo(arrowImageView)
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSelect.accept(())
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(_ workspace: Workspace) {
        
        self.profileImageView.setImage(strUrl: workspace.profileImageURL)
        
        self.titleLabel.text = workspace.name
    }
}
