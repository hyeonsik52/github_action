//
//  WorkspaceSelectView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Kingfisher

class WorkspaceSelectView: UIView {

    private var profileImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.setImage(strUrl: nil)
    }
    private var nameLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = Color.BLACK_0F0F0F
    }
    
    private var swsInfo: SWSInfoType!
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
        
        let arrowImageView = UIImageView().then{
            $0.image = UIImage(named: "sws-selectWorkspace")
            $0.contentMode = .center
        }
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        self.addSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(arrowImageView.snp.trailing).offset(1)
            make.width.height.equalTo(24)
        }

        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        let button = UIButton()
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSelect.accept(())
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(_ workspace: Workspace) {
        
        self.nameLabel.text = workspace.name
        self.profileImageView.setImage(strUrl: workspace.profileImageURL)
    }
}
