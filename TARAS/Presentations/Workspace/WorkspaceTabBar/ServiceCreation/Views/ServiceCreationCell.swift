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
    }
    
    let removeImageView = UIImageView(image: .init(named: "iconBkEx16"))
    let removeButton = UIButton()
    
    private let detailLabel = UILabel().then {
        $0.font = .regular[14]
        $0.textColor = .gray666666
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let receiversLabel = UILabel().then {
        $0.font = .regular[12]
        $0.textColor = .grayA0A0A0
        $0.textAlignment = .right
    }
    
    var disposeBag = DisposeBag()
    
    private let detailIcon = NSTextAttachment().then {
        let icon = UIImage(named: "iconGyMessage16")!
        var iconBounds = CGRect(origin: .zero, size: icon.size)
        iconBounds.origin.y = (UIFont.regular[14].capHeight - icon.size.height).rounded() / 2
        $0.bounds = iconBounds
        $0.image = icon
    }
    
    private let receiversIcon = NSTextAttachment().then {
        let icon = UIImage(named: "iconGySend16")!
        var iconBounds = CGRect(origin: .zero, size: icon.size)
        iconBounds.origin.y = (UIFont.regular[12].capHeight - icon.size.height).rounded() / 2
        $0.bounds = iconBounds
        $0.image = icon
    }
    
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
            $0.layer.cornerRadius = 12
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
            
            topContainer.addSubview(self.removeImageView)
            self.removeImageView.snp.makeConstraints {
                $0.top.trailing.equalToSuperview()
                $0.size.equalTo(16)
                $0.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
            }
            
            $0.addSubview(self.removeButton)
            self.removeButton.snp.makeConstraints {
                $0.center.equalTo(self.removeImageView)
                $0.size.equalTo(32)
            }
            
            stackView.addArrangedSubview(self.detailLabel)
            stackView.addArrangedSubview(self.receiversLabel)
        }
    }
    
    func bind(reactor: ServiceCreationCellReactor) {
        let serviceUnit = reactor.initialState
        
        self.titleLabel.text = serviceUnit.stop.name
        
        self.detailLabel.isHidden = (serviceUnit.detail == nil)
        if let detail = serviceUnit.detail {
            let componeted = detail.components(separatedBy: .newlines)
            let isLineMultiple = (componeted.count > 1)
            let attributedText = NSMutableAttributedString(attachment: self.detailIcon)
            if isLineMultiple {
                let truncatedFirstLine = "\(componeted[0])..."
                attributedText.append(.init(string: " \(truncatedFirstLine)"))
            } else {
                attributedText.append(.init(string: " \(detail)"))
            }
            self.detailLabel.attributedText = attributedText
        }
        
        let attributedText = NSMutableAttributedString(attachment: self.receiversIcon)
        let receiverName = serviceUnit.receiver?.name ?? "알 수 없는 사용자"
        attributedText.append(.init(string: " \(receiverName)"))
        self.receiversLabel.attributedText = attributedText
        
        self.disposeBag = DisposeBag()
        self.removeButton.rx.tap
            .map { Reactor.Action.remove }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
