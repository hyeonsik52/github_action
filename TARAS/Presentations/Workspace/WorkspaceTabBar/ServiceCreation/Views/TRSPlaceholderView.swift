//
//  TRSPlaceholderView.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/26.
//

import UIKit
import SnapKit
import Then

class TRSPlaceholderView: UIView {
    
    struct Configuration {
        var title: String
        var edges: UIEdgeInsets = .zero
        var image: UIImage? = nil
        var description: String? = nil
        var subViews: [UIView] = []
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .regular[20]
        $0.textColor = .black1C1B1F
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .regular[16]
        $0.textColor = .gray787579
        $0.textAlignment = .center
    }
    
    init(_ config: Configuration) {
        super.init(frame: .zero)
        
        self.titleLabel.text = config.title
        self.imageView.image = config.image
        self.imageView.isHidden = (config.image == nil)
        self.descriptionLabel.text = config.description
        self.descriptionLabel.isHidden = (config.description?.isEmpty ?? true)
        
        self.setupConstraints(config)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ config: Configuration) {
        
        let contentView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 16
        }
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(config.edges.top)
            $0.leading.equalToSuperview().offset(config.edges.left)
            $0.trailing.equalToSuperview().offset(-config.edges.right)
            $0.bottom.lessThanOrEqualToSuperview().offset(-config.edges.bottom)
        }
        
        contentView.addArrangedSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.height.equalTo(160)
        }
        
        let textContainer = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
        }
        contentView.addArrangedSubview(textContainer)
        
        textContainer.addArrangedSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        textContainer.addArrangedSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        config.subViews.forEach(contentView.addArrangedSubview)
    }
}
