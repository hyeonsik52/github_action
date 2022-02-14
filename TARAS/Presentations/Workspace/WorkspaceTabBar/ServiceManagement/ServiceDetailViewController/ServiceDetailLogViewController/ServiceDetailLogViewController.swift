//
//  ServiceDetailLogViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources

class ServiceDetailLogViewController: BaseNavigationViewController, View {

    enum Text {
        static let title = "서비스 로그"
    }
    
    private let tableView = UITableView().then {
        
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        
        $0.register(ServiceDetailLogTableViewCell.self, forCellReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ServiceLogSection>(configureCell :{ dataSource, tableView, indexPath, reactor -> UITableViewCell in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceDetailLogTableViewCell
        cell.reactor = reactor
        
        return cell
    })
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = Text.title
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let line = UIView().then {
            $0.backgroundColor = .grayF8F8F8
        }
        self.view.addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func bind(reactor: ServiceDetailLogViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state
            .map { [.init(items: $0.serviceLogs.map(ServiceLogCellReactor.init))] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] isLoading in
                if self?.tableView.refreshControl?.isRefreshing == true {
                    DispatchQueue.main.async {
                        self?.tableView.refreshControl?.endRefreshing()
                    }
                }
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}
