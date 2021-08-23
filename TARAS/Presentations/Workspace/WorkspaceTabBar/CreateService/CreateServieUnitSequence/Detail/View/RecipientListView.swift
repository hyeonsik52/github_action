//
//  RecipientListView.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/13.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class RecipientListView: UIView, ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    let headerView = DetailListWithHeaderView()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(self.headerView)
        self.headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints {
            $0.top.equalTo(self.headerView.snp.bottom)
            $0.leading.trailing.equalTo(self.headerView)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: RecipientListViewReactor) {
        self.stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        let cellReactors = reactor.initialState.list
            .map(reactor.reactorForCell)
        
        var index = 0
        
        cellReactors.forEach { reactor in
            let cell = RecipientListCellView()
            cell.reactor = reactor

            self.stackView.addArrangedSubview(cell)
            cell.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(66)
            }

            index += 1
        }
        
        index = 0
        self.layoutIfNeeded()
    }
}
