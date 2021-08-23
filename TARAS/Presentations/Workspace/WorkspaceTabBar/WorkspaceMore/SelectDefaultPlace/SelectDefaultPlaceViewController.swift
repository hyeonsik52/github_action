//
//  SelectDefaultPlaceViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/01.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class SelectDefaultPlaceViewController: BaseNavigationViewController, View {
    
    enum Text {
        static let SDP_VC_1 = "기본 위치 설정"
        static let SDP_VC_2 = "기본 위치가 변경되었습니다."
    }
    
    private var selectedIndexPath: IndexPath?
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        
        $0.contentInset.top = 14
        $0.backgroundColor = .clear
        
        $0.register(SRPProfileTextTableViewCell.self, forCellReuseIdentifier: "cell")
        
        $0.separatorStyle = .none
        
        $0.refreshControl = UIRefreshControl()
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<PlaceModelSection>(configureCell: { [weak self] dataSource, tableview, indexPath, item -> UITableViewCell in
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SRPProfileTextTableViewCell
        cell.usingSelection = true
        cell.bind(text: item.name, profileImage: item.profileImageURL, isSelected: item.isSelected)
        
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
        
        self.title = Text.SDP_VC_1
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func bind(reactor: SelectDefaultPlaceViewReactor) {
        
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
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard self?.selectedIndexPath != indexPath else { return }
                if let selected = self?.selectedIndexPath {
                    self?.dataSource[selected].isSelected = false
                    self?.tableView.reloadRows(at: [selected], with: .none)
                }
                self?.dataSource[indexPath].isSelected = true
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                self?.selectedIndexPath = indexPath
            })
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(ServicePlace.self)
            .map { Reactor.Action.update(stopIdx: $0.idx) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap { $0.swsPlaces }
            .do(onNext: { [weak self] places in
                print(places.count)
                guard let row = places.enumerated().first(where: { $1.isSelected })?.offset else { return }
                self?.selectedIndexPath = IndexPath(row: row, section: 0)
            })
            .map { [PlaceModelSection(header: "", items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isProcessing }
            .distinctUntilChanged()
            .filter { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                Text.SDP_VC_2.sek.showToast()
            })
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

extension SelectDefaultPlaceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
