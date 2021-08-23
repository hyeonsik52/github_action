//
//  CreateServiceCell.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

protocol CreateServiceCellDelegate: class {
    func didBypassButtonTap(index: Int)
    func didDeleteButtonTap(index: Int)
}

final class CreateServiceCell: BaseTableViewCell, ReactorKit.View {

    weak var createServiceCellDelegate: CreateServiceCellDelegate?

    private let cellView = CreateServiceCellView()

    override func initial() {
        self.setupConstraints()
        
        self.cellView.bypassEditButton.addTarget(
            self,
            action: #selector(didBypassButtonTap(_:)),
            for: .touchUpInside
        )
        
        self.cellView.deleteButton.addTarget(
            self,
            action: #selector(didDeleteButtonTap(_:)),
            for: .touchUpInside
        )
    }

    @objc func didBypassButtonTap(_ sender: UIButton) {
        self.createServiceCellDelegate?.didBypassButtonTap(index: sender.tag)
    }

    @objc func didDeleteButtonTap(_ sender: UIButton) {
        self.createServiceCellDelegate?.didDeleteButtonTap(index: sender.tag)
    }
    
    private func setupConstraints() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear

        self.contentView.addSubview(self.cellView)
        self.cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(reactor: CreateServiceCellReactor) {
        self.cellView.bind(reactor.serviceUnitModel)
    }
    
    func setIndex(row: Int) {
        self.cellView.deleteButton.tag = row
        self.cellView.bypassEditButton.tag = row
        self.cellView.targetInfoView.numberLabel.text = "\(row + 1)"
    }
}
