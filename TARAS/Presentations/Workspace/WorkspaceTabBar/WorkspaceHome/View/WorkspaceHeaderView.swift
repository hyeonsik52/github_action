//
//  WorkspaceHeaderView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class WorkspaceHeaderView: UIView {

    private var userNameLabel = UILabel().then{
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.6
        $0.lineBreakMode = .byTruncatingHead
        $0.font = .regular[20]
        $0.textColor = .black
        $0.text = " "
    }
    
    let didSelect = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        let container = UIView()
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(22)
        }
        
        container.addSubview(self.userNameLabel)
        self.userNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        let staticLabel = UILabel().then{
            $0.minimumScaleFactor = 0.8
            $0.adjustsFontSizeToFitWidth = true
            $0.font = .bold[24]
            $0.textColor = .black
            $0.text = "서비스를 생성해보세요"
        }
        container.addSubview(staticLabel)
        staticLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(6)
            make.leading.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        let addButton = UIButton().then{
            $0.backgroundColor = .purple4A3C9F
            $0.setImage(UIImage(named: "sws-create"), for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.contentMode = .center
        }
        self.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerY.equalToSuperview()
            make.leading.equalTo(container.snp.trailing).offset(22)
            make.trailing.equalToSuperview().offset(-22)
        }
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSelect.accept(())
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(_ user: User) {
        
        self.userNameLabel.text = "\(user.displayName)님!"
    }
}
