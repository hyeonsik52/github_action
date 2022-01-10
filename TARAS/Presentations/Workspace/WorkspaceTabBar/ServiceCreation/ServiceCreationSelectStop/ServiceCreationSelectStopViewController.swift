//
//  ServiceCreationSelectStopViewController.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/01.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class ServiceCreationSelectStopViewController: BaseNavigationViewController, View {
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.alwaysBounceVertical = true
        $0.separatorStyle = .none
        $0.rowHeight = 48
        
        $0.register(ServiceUnitTargetCell.self, forCellReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ServiceUnitTargetModelSection>(
        configureCell: { dataSource, tableView, indexPath, cellReactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceUnitTargetCell
            cell.reactor = cellReactor
            return cell
        }
    )
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    var selected = PublishRelay<ServiceUnitTargetModel>()
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "정차지 선택"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: ServiceCreationSelectStopViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(ServiceUnitTargetCellReactor.self)
            .subscribe(onNext: { [weak self] cellReactor in
                guard cellReactor.isEnabled else { return }
                let stop = cellReactor.initialState
                if reactor.mode == .create {
                    switch reactor.entry {
                    case .general:
                        if reactor.templateProcess.peek("receivers") != nil {
                            self?.navigationPush(
                                type: ServiceCreationSelectReceiverViewController.self,
                                reactor: reactor.reactorForSelectReceivers(mode: .create, stop: stop),
                                animated: true,
                                bottomBarHidden: true
                            )
                        } else if reactor.templateProcess.peek(with: "message") != nil {
                            //상세 설정
                            print("detail")
                        } else {
                            //돌아감
                            print("empty")
                        }
                    }
                }
                self?.selected.accept(stop)
            }).disposed(by: self.disposeBag)
        
        //State
        reactor.state.map(\.stops)
            .map { $0.map { .init(model: $0, selectionType: .check, isEnabled: !$0.name.hasPrefix("LS")) } }
            .map { [.init(header: "", items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
//        reactor.state.map(\.isLoading)
//            .distinctUntilChanged()
//            .bind(to: self.activityIndicatorView.rx.isAnimating)
//            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isLoading)
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isLoading in
                if !isLoading {
                    if self?.tableView.refreshControl?.isRefreshing == true {
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.refreshControl?.endRefreshing()
                        }
                    }
                }
            }).disposed(by: self.disposeBag)
    }
}
