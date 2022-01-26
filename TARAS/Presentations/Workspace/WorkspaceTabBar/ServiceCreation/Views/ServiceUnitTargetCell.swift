//
//  ServiceUnitTargetCell.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/01.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift

class ServiceUnitTargetCell: UITableViewCell, View {
    
    private let titleLabel = UILabel().then {
        $0.font = .regular[16]
    }
    
    private let selectedCheckImage = UIImage(named: "checkbox-on")
    private let defaultImage = UIImage(named: "checkbox-off")
    
    private lazy var selectButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(self.defaultImage, for: .normal)
        $0.setImage(self.selectedCheckImage, for: .selected)
        $0.isUserInteractionEnabled = false
    }
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundView?.isHidden = true
    }
    
    private func setupConstraints() {
        
        self.selectionStyle = .none
        self.contentView.clipsToBounds = true
        
        let highlightView = UIView().then {
            $0.backgroundColor = .init(hex: "#6750A41F")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.isHidden = true
        }
        self.addSubview(highlightView)
        self.backgroundView = highlightView
        
        let container = UIView()
        
        self.contentView.addSubview(container)
        container.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        container.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        
        container.addSubview(self.selectButton)
        self.selectButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-24)
            $0.size.equalTo(24)
        }
                    
        let separator = UIView().then {
            $0.backgroundColor = .lightGrayF4EFF4
        }
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.equalTo(container.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(1)
        }
        
        highlightView.snp.makeConstraints {
            $0.top.bottom.equalTo(container)
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
        }
    }
    
    func bind(reactor: ServiceUnitTargetCellReactor) {
        let target = reactor.initialState
        
        let isHighlighted = !reactor.highlightRanges.isEmpty
        self.titleLabel.textColor = (isHighlighted ? .gray787579: .black1C1B1F)
        
        if isHighlighted {
            let attributedText = NSMutableAttributedString(string: target.name)
            reactor.highlightRanges.forEach {
                attributedText.addAttributes(
                    [
                        .font: UIFont.medium[16],
                        .foregroundColor: UIColor.black1C1B1F
                    ],
                    range: $0
                )
            }
            self.titleLabel.attributedText = attributedText
        } else {
            self.titleLabel.text = target.name
        }
        
        self.titleLabel.alpha = (reactor.isEnabled ? 1.0: 0.3)
        
        self.selectButton.isHidden = !reactor.isEnabled || !reactor.isIconVisibled
        self.selectButton.isSelected = target.isSelected
    }
}
