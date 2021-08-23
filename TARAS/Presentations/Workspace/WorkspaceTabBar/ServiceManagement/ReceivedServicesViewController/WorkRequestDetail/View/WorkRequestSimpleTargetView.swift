//
//  WorkRequestSimpleTargetView.swift
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

class WorkRequestSimpleTargetView: UIView {

    private let titleLabel = UILabel().then {
        $0.font = Font.BOLD_16
        $0.textColor = Color.PURPLE_4A3C9F
        $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
    }
    
    private let contentLabel = UILabel().then {
        $0.font = Font.BOLD_16
        $0.textColor = Color.PURPLE_4A3C9F
        $0.lineBreakMode = .byTruncatingMiddle
    }
    
    private let disposeBag = DisposeBag()
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
            $0.leading.equalToSuperview().offset(26)
        }
        
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(22)
        }
        
        let arrowImageView = UIImageView().then {
            $0.image = UIImage(named: "service-detail-purple")
            $0.contentMode = .center
        }
        self.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.contentLabel.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(18)
        }
        
        let button = UIButton()
        self.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didSelect.accept(())
            })
            .disposed(by: self.disposeBag)
    }
    
    func bind(content: String?) {
        
        self.contentLabel.text = content
    }
}
