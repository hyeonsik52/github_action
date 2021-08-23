//
//  StopInChargeListViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources

class StopInChargeListViewController: BaseNavigationViewController, View {

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.contentInset.top = 14
        
        $0.register(SRPProfileTextTableViewCell.self, forCellReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<PlaceModelSection>(configureCell: { dataSource, tableView, indexPath, place -> UITableViewCell in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SRPProfileTextTableViewCell
        cell.bind(text: place.name, profileImage: place.profileImageURL)
        
        return cell
    })
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "담당 정차지"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: StopInChargeListViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
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
        reactor.state.compactMap { $0.userInfo?.swsUserInfo?.groups.first?.stopsInCharge }
            .map { [PlaceModelSection(header: "", items: $0)] }
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

extension StopInChargeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
