//
//  WorkRequestTargetView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/14.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class WorkRequestTargetView: UIView {
    
    private let titleView = WorkRequestSectionTitleView(title: "작업 대상")
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 22
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black0F0F0F
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "service-detail-purple")
        $0.contentMode = .center
        $0.isHidden = true
    }
    
    private let disposeBag = DisposeBag()
    let didSelect = PublishRelay<Bool>()
    
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
            $0.height.equalTo(66)
            $0.bottom.equalToSuperview()
        }
        
        container.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(44)
        }
        
        container.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(14)
        }
        
        container.addSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(self.contentLabel.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(18)
        }
        
        let button = UIButton()
        container.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.didSelect.accept(!self.arrowImageView.isHidden)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(content: String?, profileImageUrl: String?, usingSelection: Bool = false) {
        
        self.profileImageView.setImage(strUrl: profileImageUrl)
        self.contentLabel.text = content
        self.arrowImageView.isHidden = !usingSelection
    }
}
