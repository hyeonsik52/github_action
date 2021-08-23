//
//  SRPDetailInfoCellView.swift
//  Dev-ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class SRPDetailInfoCellView: UIView {

    private let titleLabel = UILabel().then {
        $0.font = Font.BOLD_16
        $0.textColor = Color.BLACK_0F0F0F
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
    }
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 18
        $0.isHidden = true
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
    }
    private let contentLabel = UILabel().then {
        $0.font = Font.BOLD_16
        $0.textColor = Color.BLACK_0F0F0F
    }
    private let arrowImageView = UIImageView().then {
        $0.contentMode = .center
        $0.image = UIImage(named: "setting-detail")
        $0.setContentCompressionResistancePriority(.defaultHigh+2, for: .horizontal)
        $0.isHidden = true
    }
    
    let didSelect = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    var forcedSelection = false
    
    convenience init(title: String, forcedSelection: Bool = false) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.forcedSelection = forcedSelection
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
        
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        stackView.addArrangedSubview(self.profileImageView)
        self.profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        stackView.addArrangedSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(12)
        }
        
        let button = UIButton()
        self.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                    self.forcedSelection || !self.arrowImageView.isHidden else { return }
                self.didSelect.accept(())
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(
        text: String? = nil,
        fixedProfile: Bool = false,
        profileImageUrl: String? = nil,
        usingArrow: Bool = false
    ) {
        if let text = text {
            self.contentLabel.isHidden = false
            self.contentLabel.text = text
        }else{
            self.contentLabel.isHidden = true
        }

        self.profileImageView.setImage(strUrl: profileImageUrl)
        if fixedProfile {
            self.profileImageView.isHidden = false
        }else if profileImageUrl != nil {
            self.profileImageView.isHidden = false
        }else{
            self.profileImageView.isHidden = true
        }
        
        self.arrowImageView.isHidden = !usingArrow
    }
}
