//
//  WorkRequestTaskView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/19.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WorkRequestTaskView: UIView {

    private var titleView: WorkRequestSectionTitleView!
    
    private var itemStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    convenience init(frame: CGRect = .zero, title: String) {
        self.init(frame: frame)
        
        self.setupConstraints(title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(_ title: String) {
        
        self.titleView = WorkRequestSectionTitleView(title: title)
        self.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        let container = UIView().then {
            $0.clipsToBounds = true
            $0.cornerRadius = 8
            $0.backgroundColor = .lightGrayF1F1F1
        }
        self.addSubview(container)
        container.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().offset(-26)
            $0.bottom.equalToSuperview()
        }
        
        container.addSubview(self.itemStackView)
        self.itemStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-18)
        }
    }
    
    private func cellView(_ task: Task) -> UIView {
        
        let view = UIView()
        
        let nameLabel = UILabel().then {
            $0.font = .regular.16
            $0.textColor = .black
            $0.text = task.object.name
        }
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        
        let quantityLabel = UILabel().then {
            $0.font = .bold.16
            $0.textColor = .black
            $0.text = "\(task.count.currencyFormatted) 개"
            $0.setContentCompressionResistancePriority(.defaultHigh+1, for: .horizontal)
        }
        view.addSubview(quantityLabel)
        quantityLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        return view
    }
    
    func bind(tasks: [Task]) {
        
        self.itemStackView.subviews
            .forEach{$0.removeFromSuperview()}
        
        for task in tasks {
            let cell = cellView(task)
            self.itemStackView.addArrangedSubview(cell)
            cell.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(48)
            }
        }
    }
}
