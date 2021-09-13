//
//  RecipientsGroupsViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources

class RecipientGroupViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var recipientDelegate: CSURecipientDelegate?


    // MARK: - UI
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(RecipientGroupCell.self)
    }


    // MARK: - Life cycles

    override func setupConstraints() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func bind() {

    }


    // MARK: - ReactorKit

    func bind(reactor: RecipientsGroupViewReactor) {
        let dataSource = RxTableViewSectionedReloadDataSource<RecipientGroupSection>(
            configureCell: { _, tableView, indexPath, cellReactor in
                let cell = tableView.dequeueCell(ofType: RecipientGroupCell.self, indexPath: indexPath)
                cell.reactor = cellReactor
                return cell
            })

        self.rx.viewDidLoad
            .map { Reactor.Action.setTableViewSection }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.tableView.rx.modelSelected(RecipientGroupCellReactor.self)
            .map(reactor.updateCreateServiceUnitModel)
            .subscribe(onNext: { [weak self] serviceUnit in
                self?.recipientDelegate?.didRecipientsSelected(serviceUnit)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.tableViewSection }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}
