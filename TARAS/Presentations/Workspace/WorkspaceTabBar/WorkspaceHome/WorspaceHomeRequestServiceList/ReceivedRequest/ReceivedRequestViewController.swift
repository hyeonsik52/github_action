//
//  ReceivedRequestViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/22.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import ReactorKit
import RxDataSources
import PanModal
import SkeletonView

class ReceivedRequestViewController: BaseNavigationViewController, View {
    
    private var tableView = UITableView(frame: .zero, style: .grouped).then {
        
        $0.tableHeaderView = .init(frame: .init(origin: .zero, size: .init(width: 0.0, height: .leastNonzeroMagnitude)))
        
        $0.contentInset.top = 14
        
        $0.backgroundColor = .clear
        
        $0.register(ReceivedRequestTableViewCell.self, forCellReuseIdentifier: "cell")
        $0.register(RequestTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        
        $0.separatorStyle = .none
        
        $0.isSkeletonable = true
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ServiceModelSection>(configureCell: { dataSource, tableView, indexPath, reactor -> UITableViewCell in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReceivedRequestTableViewCell
        cell.reactor = reactor
        
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
        
        self.title = "받은 요청"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func bind(reactor: PagingReceivedRequestReactor) {
        
        //State
        reactor.state.map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.waitingIsLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { (0, $0) }
            .observeOn(MainScheduler.instance)
            .bind(to: self.tableView.rx.skeleton)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.acceptedIsLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { (1, $0) }
            .observeOn(MainScheduler.instance)
            .bind(to: self.tableView.rx.skeleton)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.waitingIsLoading ?? false && $0.acceptedIsLoading ?? false }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] isLoading in
                if self?.tableView.refreshControl?.isRefreshing ?? false {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.isProcessing }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.retryMoreAccepted }
            .distinctUntilChanged()
            .map { [weak self] _ in self?.tableView.numberOfRows(inSection: 1) ?? 0 }
            .map { Reactor.Action.moreAccepted($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
//        reactor.state.map { $0.isFromPush }
//            .filter { $0 == true }
//            .subscribe(onNext: { [weak self] _ in
//                
//                if reactor.pushInfo?.notificationType == .robotArrived,
//                    let serviceIdx = reactor.pushInfo?.serviceIdx,
//                    let serviceUnitIdx = reactor.pushInfo?.serviceUnitIdx
//                {
//                    let viewController = WorkRequestViewController()
//                    viewController.reactor = reactor.reactorForSelectReceivedService(
//                        serviceIdx: serviceIdx,
//                        serviceUnitIdx: serviceUnitIdx
//                    )
//                    let navigationController = PanModalNavigationController(
//                        rootViewController: viewController
//                    )
//                    self?.presentPanModal(navigationController)
//                }
//                
//            }).disposed(by: self.disposeBag)
        
        //Action
        self.rx.viewDidLoad
            .map{ Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
//        viewDidLoad
//            .map { Reactor.Action.judgeIsFromPush }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(ServiceCellReactor.self)
            .subscribe(onNext: { [weak self] cellReactor in
                
                let serviceIdx = cellReactor.currentState.service.serviceIdx
                let serviceUnitIdx = cellReactor.currentState.serviceUnit?.serviceUnitIdx ?? -1
                
                let viewController = WorkRequestViewController()
                viewController.reactor = reactor.reactorForSelectReceivedService(serviceIdx: serviceIdx, serviceUnitIdx: serviceUnitIdx)
                let navigationController = PanModalNavigationController(rootViewController: viewController)
                
                self?.presentPanModal(navigationController)
            })
            .disposed(by: self.disposeBag)
        
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension ReceivedRequestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = self.dataSource[section].header
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! RequestTableViewHeader
        header.bind(title: title)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = self.dataSource[1].items.count-1
        if indexPath.section == 1, indexPath.row >= lastIndex {
            self.reactor?.action.onNext(.moreAccepted(indexPath.row))
        }
    }
}
