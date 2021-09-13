//
//  FreightListView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/07.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class FreightListView: UIView, ReactorKit.View {
    
    var indexOfDeletedButton = PublishRelay<Int>()
    
    var disposeBag = DisposeBag()
    
    let headerView: DetailListWithHeaderView
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
//    init(type: ServiceUnitFreightType) {
//        self.headerView = DetailListWithHeaderView(type: type)
//        super.init(frame: .zero)
//
//        self.addSubview(self.headerView)
//        self.headerView.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(60)
//        }
//
//        self.addSubview(self.stackView)
//        self.stackView.snp.makeConstraints {
//            $0.top.equalTo(self.headerView.snp.bottom)
//            $0.leading.trailing.equalTo(self.headerView)
//            $0.bottom.equalToSuperview()
//        }
//    }
    //temp
    init() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: FreightListViewReactor) {
        self.stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

//        let cellReactors = reactor.initialState.list
//            .map { FreightListCellModel(type: $0.type, name: $0.name, quantity: $0.quantity) }
//            .map(FreightListCellReactor.init)
//
//        var index = 0
//
//        cellReactors.forEach { reactor in
//            let cell = FreightListCellView()
//            cell.reactor = reactor
//            cell.deleteButton.tag = index
//
//            cell.deleteButton.rx.tap
//                .map { _ in cell.deleteButton.tag }
//                .bind(to: self.indexOfDeletedButton)
//                .disposed(by: self.disposeBag)
//
//            self.stackView.addArrangedSubview(cell)
//            cell.snp.makeConstraints {
//                $0.width.equalToSuperview()
//                $0.height.equalTo(50)
//            }
//
//            index += 1
//        }
//
//        index = 0
//        self.layoutIfNeeded()
    }
}
