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
    
    private let selectedCheckImage = UIImage(named: "recipient-checkbox-on")
    private let defaultImage = UIImage(named: "recipient-checkbox-off")
    
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
    
    private func setupConstraints() {
        
        self.selectionStyle = .none
        
        let highlightView = UIView().then {
            $0.backgroundColor = .init(hex: "#6750A41F")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.isHidden = true
        }
        self.addSubview(highlightView)
        highlightView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
        }
        self.backgroundView = highlightView
        
        self.contentView.do {
            $0.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(24)
                $0.height.equalTo(24)
            }
            
            $0.addSubview(self.selectButton)
            self.selectButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().offset(-26)
                $0.size.equalTo(20)
            }
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
