//
//  BelongingGroupListViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class BelongingGroupListViewController: BaseNavigatableViewController, View {

    var preferredTitle: String?
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        
        $0.contentInset.top = 14
        $0.backgroundColor = .clear
        
        $0.register(SRPProfileTextTableViewCell.self, forCellReuseIdentifier: "cell")
        
        $0.separatorStyle = .none
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<GroupModelSection>(configureCell: { dataSource, tableview, indexPath, item -> UITableViewCell in
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SRPProfileTextTableViewCell
        cell.usingSelection = false
        cell.bind(text: item.name, profileImage: item.profileImageURL)
        
        return cell
    })
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = self.preferredTitle
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func bind(reactor: BelongingGroupListViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map{ Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap { $0.swsUserInfo?.groups }
            .map { [GroupModelSection(header: "", items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
}
