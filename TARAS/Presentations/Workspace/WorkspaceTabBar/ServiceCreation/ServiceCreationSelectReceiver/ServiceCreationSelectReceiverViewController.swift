//
//  ServiceCreationSelectReceiverViewController.swift
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

class ServiceCreationSelectReceiverViewController: BaseNavigationViewController, View {
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.alwaysBounceVertical = true
        $0.contentInset.bottom = 88
        $0.separatorStyle = .none
        $0.rowHeight = 48
        
        $0.register(ServiceUnitTargetCell.self, forCellReuseIdentifier: "cell")
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private let tableViewDataSource = RxTableViewSectionedReloadDataSource<ServiceUnitTargetModelSection>(
        configureCell: { dataSource, tableView, indexPath, cellReactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceUnitTargetCell
            cell.reactor = cellReactor
            return cell
        }
    )
    
    let confirmButton = SRPButton("선택 완료").then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
    }
    
    override var navigationPopWithBottomBarHidden: Bool {
        return true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(48)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "서비스 요청"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func bind(reactor: ServiceCreationSelectReceiverViewReactor) {
        
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
            .map(\.initialState)
            .map(Reactor.Action.select)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        if reactor.mode == .create {
            self.confirmButton.rx.tap
                .map { reactor.reactorForDetail(mode: .create) }
                .subscribe(onNext: { [weak self] reactor in
                    self?.navigationPush(
                        type: ServiceCreationDetailViewController.self,
                        reactor: reactor,
                        animated: true,
                        bottomBarHidden: true
                    )
                }).disposed(by: self.disposeBag)
        }
        
        //State
        reactor.state.map(\.users)
            .map { $0.map { .init(model: $0, selectionType: .check) } }
            .map { [.init(header: "", items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: self.tableViewDataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.isLoading)
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
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
        
        reactor.state.map { $0.users.filter(\.isSelected).count > 0 }
        .bind(to: self.confirmButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
    }
}
