//
//  TargetUserViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources

class TargetStopViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var targetDelegate: CSUTargetDelegate?

    
    // MARK: - UI
    
    let refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(TargetStopCell.self)
        $0.refreshControl = self.refreshControl
    }


    // MARK: - Life cycles

    override func setupConstraints() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
    // MARK: - ReactorKit

    func bind(reactor: TargetStopViewReactor) {
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in Reactor.Action.refreshSections }
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<TargetStopSection>(
            configureCell: { _, tableView, indexPath, cellReactor in
                let cell = tableView.dequeueCell(ofType: TargetStopCell.self, indexPath: indexPath)
                cell.reactor = cellReactor
                return cell
            })

        self.rx.viewDidLoad
            .map { Reactor.Action.loadSections }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.tableView.rx.modelSelected(TargetStopCellReactor.self)
            .map(reactor.updateCreateServiceUnitInput)
            .subscribe(onNext: { [weak self] serviceUnit in
                self?.targetDelegate?.didTargetSelected(serviceUnit)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}
