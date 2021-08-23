//
//  ServiceStateHeaderView.swift
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

class ServiceStateHeaderView: UITableViewHeaderFooterView {
        
    private var titleLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = Color.BLACK_0F0F0F
    }
    private var arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "sws-toDetail")
        $0.contentMode = .center
    }
    
    private var selection: (() -> Void)?
    private let disposeBag = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.backgroundView = UIView().then{
            $0.backgroundColor = .white
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
        }
        
        self.addSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(self.titleLabel).offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.width.equalTo(18)
            $0.height.equalTo(18)
        }
        
        let button = UIButton()
        self.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.selection?()
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(_ title: String, selection: (() -> Void)?) {
        
        self.titleLabel.text = title
        
        self.selection = selection
    }
}
