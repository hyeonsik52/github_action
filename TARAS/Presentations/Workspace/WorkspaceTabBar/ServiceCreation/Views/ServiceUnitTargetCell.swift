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
        $0.textColor = .darkGray303030
    }
    
    private let selectedCheckImage = UIImage(named: "iconCheckBoxSel2")
    private let selectedRadioImage = UIImage(named: "iconRadio24Sel2")
    private let defaultImage = UIImage()
    
    private lazy var selectButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(self.defaultImage, for: .normal)
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
        self.contentView.do {
                        
            $0.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
                $0.height.equalTo(24)
            }
            
            $0.addSubview(self.selectButton)
            self.selectButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.titleLabel.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().offset(-16)
                $0.size.equalTo(20)
            }
        }
    }
    
    func bind(reactor: ServiceUnitTargetCellReactor) {
        let type = reactor.selectionType
        let target = reactor.initialState
        
        self.titleLabel.text = target.name
        
        switch type {
        case .radio:
            self.selectButton.setImage(self.selectedRadioImage, for: .selected)
        case .check:
            self.selectButton.setImage(self.selectedCheckImage, for: .selected)
        }
        
        self.selectButton.isSelected = target.isSelected
    }
}
