//
//  TargetMemberViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/03.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources

class TargetMemberViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var targetDelegate: CSUTargetDelegate?
    
    let refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(TargetMemberCell.self)
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

    func bind(reactor: TargetMemberViewReactor) {

        // MARK: RxDataSources
        
        let dataSource = RxTableViewSectionedReloadDataSource<TargetMemeberSection>(
            configureCell: { _, tableView, indexPath, cellReactor in
                let cell = tableView.dequeueCell(ofType: TargetMemberCell.self, indexPath: indexPath)
                cell.reactor = cellReactor
                return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource[index].header
        }
        
        self.tableView.rx.modelSelected(TargetMemberCellReactor.self)
        .map(reactor.updateCreateServiceUnitModel)
        .subscribe(onNext: { [weak self] serviceUnitModel in
            self?.targetDelegate?.didTargetSelected(serviceUnitModel)
        }).disposed(by: self.disposeBag)
        
        
        // MARK: Action
        
        self.rx.viewDidLoad.map { _ in Reactor.Action.loadSections }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in Reactor.Action.refreshSections }
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // MARK: State
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}
