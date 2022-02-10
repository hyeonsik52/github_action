//
//  ServiceDetailViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/02.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources

class ServiceDetailViewController: BaseNavigationViewController, View {
    
    enum Metric {
        static let cellHeight: CGFloat = 64
    }
    
    override var navigationPopGestureEnabled: Bool {
        return false
    }
    
    private let moreButton = UIBarButtonItem(
        image: UIImage(named: "service-more")?.withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        
        $0.register(ServiceDetailServiceUnitCell.self)
        $0.rowHeight = Metric.cellHeight
        $0.separatorStyle = .none
        
        let leastHeight = CGFloat.leastNonzeroMagnitude
        $0.sectionHeaderHeight = leastHeight
        $0.sectionFooterHeight = leastHeight
        $0.tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: leastHeight))
        $0.tableFooterView = .init(frame: .init(x: 0, y: 0, width: 0, height: leastHeight))
        
        $0.addSubview(self.refreshControl)
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ServiceDetailServiceUnitSection>(
        configureCell: { dataSource, tableView, indexPath, reactor -> UITableViewCell in
            let cell = tableView.dequeueCell(ofType: ServiceDetailServiceUnitCell.self, indexPath: indexPath)
            reactor.isLastCell = (indexPath.row >= dataSource.sectionModels[indexPath.section].items.count-1)
            cell.reactor = reactor
            cell.layer.zPosition = CGFloat(indexPath.row)
            return cell
        }
    )
    
    // MARK: - Life Cycles
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationItem.setRightBarButton(self.moreButton, animated: true)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: ServiceDetailViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refreshService }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refreshService }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(ServiceDetailServiceUnitCellReactor.self)
            .subscribe(onNext: { [weak self] reactor in
                guard let self = self else { return }
                //TODO: 목적지 상세정보 보기
            }).disposed(by: self.disposeBag)
        
        self.moreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                //TODO: 더보기 메뉴 표시
            }).disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap { $0.service }
            .map(\.stateDescription)
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.service?.stateColor }
        .subscribe(onNext: { [weak self] color in
            UIView.animate(withDuration: 0.25) {
                self?.navigationBarColor = color
            }
        }).disposed(by: self.disposeBag)
        
        reactor.state
            .map { [.init(items: $0.serviceUnitReactors)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isCanceled }
            .distinctUntilChanged()
            .subscribe(onNext: { successed in
                reactor.action.onNext(.refreshService)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard self?.refreshControl.isRefreshing == true else { return }
                self?.refreshControl.endRefreshing()
            }).disposed(by: self.disposeBag)
    }
}
