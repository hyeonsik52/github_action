//
//  SettingTextCellView.swift
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

class SettingTextCellView: UIView {
    
    private var titleLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .black
    }
    
    private let detailLabel = UILabel().then {
        $0.font = .bold.16
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "setting-detail")
        $0.contentMode = .center
    }
    
    let disposeBag = DisposeBag()
    let didSelect = PublishRelay<Void>()
    
    convenience init(title: String, isArrowHidden: Bool = false) {
        self.init(frame: .zero)
        
        self.titleLabel.text = title
        self.arrowImageView.isHidden = isArrowHidden
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
            $0.spacing = 10
            $0.alignment = .center
        }
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        stackView.addArrangedSubview(self.detailLabel)
        stackView.addArrangedSubview(self.arrowImageView)
        
        self.arrowImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 6, height: 10))
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
    
    func bind(_ title: String?) {
        
        self.detailLabel.text = title
    }
}
