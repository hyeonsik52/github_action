//
//  SettingProfileCellView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class SettingProfileCellView: UIView {
    
    private var titleLabel = UILabel().then {
        $0.font = .bold[16]
        $0.textColor = .black
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 18
        $0.image = UIImage(named: "common-workspacePlaceholder-happy")
    }
    
    let disposeBag = DisposeBag()
    let didSelect = PublishRelay<Void>()
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        self.titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
        }
        
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        let arrowImageView = UIImageView().then {
            $0.image = UIImage(named: "setting-detail")
            $0.contentMode = .center
        }
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-18)
            $0.width.height.equalTo(18)
        }
        
        let button = UIButton()
        addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSelect.accept(())
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(_ info: User) {
                
        self.profileImageView.setImage(strUrl: nil)
    }
}
