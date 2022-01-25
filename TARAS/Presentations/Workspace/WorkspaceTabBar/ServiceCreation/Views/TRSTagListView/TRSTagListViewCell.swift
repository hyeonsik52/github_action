//
//  TRSTagListViewCell.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/24.
//

import UIKit
import SnapKit
import Then

protocol TRSTagListViewCellDelegate: AnyObject {
    func tagListCell(_ tagListCell: TRSTagListViewCell, didRemoveSelect model: TRSTagListViewModel)
}

class TRSTagListViewCell: UICollectionViewCell {
    
    enum Image {
        static let remove = UIImage(named: "delete")
    }
    
    private let removeButton = UIButton().then {
        $0.setImage(Image.remove, for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .regular[14]
        $0.textColor = .darkGray49454F
    }
    
    weak var delegate: TRSTagListViewCellDelegate?
    
    private var current: TRSTagListViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
        
        self.removeButton.addTarget(self, action: #selector(self.removeTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.contentView.backgroundColor = .purpleEEE8F4
        
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 14
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(28)
        }
        
        self.contentView.addSubview(self.removeButton)
        self.removeButton.snp.makeConstraints {
            $0.leading.equalTo(self.titleLabel.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(32)
        }
    }
    
    func bind(_ model: TRSTagListViewModel) {
        
        self.current = model
        self.titleLabel.text = model.title
    }
    
    @objc func removeTapped(_ button: UIButton) {
        guard let model = self.current else { return }
        self.delegate?.tagListCell(self, didRemoveSelect: model)
    }
}
