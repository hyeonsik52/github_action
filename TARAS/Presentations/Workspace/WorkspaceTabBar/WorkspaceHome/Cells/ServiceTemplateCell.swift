//
//  ServiceTemplateCell.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/12/29.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class ServiceTemplateCell: UICollectionViewCell, View {
        
    private let titleLabel = UILabel().then{
        $0.font = .bold[16]
        $0.textColor = .black0F0F0F
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .regular[14]
        $0.textColor = .gray888888
        $0.numberOfLines = 0
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = nil
        self.contentView.layer.borderWidth = 1
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 8
        }
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(16)
            $0.bottom.equalTo(-16)
            $0.width.equalTo(UIScreen.main.bounds.width-16*4-16-8)
        }
        
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.descriptionLabel)
        
        let imageView = UIImageView(image: .init(named: "enterRight"))
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(stackView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(16)
        }
    }
    
    func bind(reactor: ServiceTemplateCellReactor) {
        let template = reactor.initialState
        
        self.titleLabel.text = template.name
        
        self.descriptionLabel.isHidden = template.description?.isEmpty ?? true
        self.descriptionLabel.text = template.description
        
        self.contentView.layer.borderColor = (template.isCompiled ? UIColor.clear: .grayEDEDED).cgColor
        self.contentView.backgroundColor = (template.isCompiled ? .cellHighlightPurpleF7F6FF: .white)
    }
}
