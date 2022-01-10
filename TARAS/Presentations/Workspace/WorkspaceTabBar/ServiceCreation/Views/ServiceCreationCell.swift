//
//  ServiceCreationCell.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/10/29.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

class ServiceCreationCell: UICollectionViewCell, View {
    
    private let titleLabel = UILabel().then {
        $0.font = .medium[16]
        $0.textColor = .darkGray303030
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .regular[14]
        $0.textColor = .gray666666
    }
    
    private let destinationLabel = UILabel().then {
        $0.font = .medium[18]
        $0.textColor = .purple4A3C9F
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGrayDDDDDD.cgColor
        $0.backgroundColor = .grayF6F6F6
    }
    
    private let removeImageView = UIImageView().then {
        $0.image = .init(named: "navi-close")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .grayA2A2A2
    }
    let removeButton = UIButton()
    
    private let detailContainer = UIView()
    private let detailLabel = UILabel().then {
        $0.font = .regular[14]
        $0.textColor = .darkGray303030
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    
    private let receiversContainer = UIView()
    private let receiversLabel = UILabel().then {
        $0.font = .regular[14]
        $0.textColor = .darkGray303030
        $0.textAlignment = .right
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.contentView.do {
            
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGrayDDDDDD.cgColor
            
            $0.backgroundColor = .white
            
            let stackView = UIStackView().then {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.spacing = 8
            }
            
            $0.addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(12)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-12)
                $0.width.equalTo(UIScreen.main.bounds.width-16*2*2)
            }
            
            let topContainer = UIView()
            stackView.addArrangedSubview(topContainer)
                        
            topContainer.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
            }
            
            topContainer.addSubview(self.subTitleLabel)
            self.subTitleLabel.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
            }
            
            topContainer.addSubview(self.removeImageView)
            self.removeImageView.snp.makeConstraints {
                $0.top.trailing.equalToSuperview()
                $0.size.equalTo(12)
                $0.leading.equalTo(self.subTitleLabel.snp.trailing).offset(8)
            }
            
            $0.addSubview(self.removeButton)
            self.removeButton.snp.makeConstraints {
                $0.center.equalTo(self.removeImageView)
                $0.size.equalTo(32)
            }
            
            stackView.addArrangedSubview(self.destinationLabel)
            self.destinationLabel.snp.makeConstraints {
                $0.height.equalTo(48)
            }
            
            
            stackView.addArrangedSubview(self.receiversContainer)
            
            let receiversTitle = UILabel().then {
                $0.font = .regular[14]
                $0.textColor = .gray888888
                $0.text = "수신자"
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            self.receiversContainer.addSubview(receiversTitle)
            receiversTitle.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
            }
            
            self.receiversContainer.addSubview(self.receiversLabel)
            self.receiversLabel.snp.makeConstraints {
                $0.top.bottom.trailing.equalToSuperview()
                $0.leading.equalTo(receiversTitle.snp.trailing).offset(8)
            }
            
            
            stackView.addArrangedSubview(self.detailContainer)
            
            let detailTitle = UILabel().then {
                $0.font = .regular[14]
                $0.textColor = .gray888888
                $0.text = "요청사항"
                $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            self.detailContainer.addSubview(detailTitle)
            detailTitle.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.bottom.lessThanOrEqualToSuperview()
            }
            
            self.detailContainer.addSubview(self.detailLabel)
            self.detailLabel.snp.makeConstraints {
                $0.top.bottom.trailing.equalToSuperview()
                $0.leading.equalTo(detailTitle.snp.trailing).offset(8)
            }
        }
    }
    
    func bind(reactor: ServiceCreationCellReactor) {
        let serviceUnit = reactor.initialState
        
        self.titleLabel.text = reactor.destinationType.description
        
        self.destinationLabel.text = serviceUnit.stop.name
        
        self.detailContainer.isHidden = (serviceUnit.detail == nil)
        self.detailLabel.text = serviceUnit.detail
        
        self.disposeBag = DisposeBag()
        self.removeButton.rx.tap
            .map { Reactor.Action.remove }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
