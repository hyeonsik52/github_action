//
//  WaypointViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Twinny on 2020/07/18.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift
import RxCocoa

protocol CreateServiceWaypointChangeDelegate: class {
    func didCreateServiceWaypointChange(prevStopIdx: Int?, stopIdx: Int)
}

class WaypointViewController: BaseNavigatableViewController, ReactorKit.View {
    
    weak var createServiceWaypointChangeDelegate: CreateServiceWaypointChangeDelegate?
    
    weak var createServiceWaypointSelectDelegate: CreateServiceWaypointSelectDelegate?
    
    
    // MARK: - UI

    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
        $0.register(WaypointCell.self)
    }


    // MARK: - Life cycles
    
    override func setupConstraints() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "경유지 선택"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.isHidden = false
    }

    override func bind() {
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }


    // MARK: - ReactorKit

    func bind(reactor: WaypointViewReactor) {
        let dataSource = RxTableViewSectionedReloadDataSource<WaypointSection>(
            configureCell: { _, tableView, indexPath, cellReactor in
                let cell = tableView.dequeueCell(ofType: WaypointCell.self, indexPath: indexPath)
                cell.reactor = cellReactor
                
                if let selectedStopIdx = reactor.waypointInput?.stopIdx ?? nil {
                    cell.backgroundColor = cellReactor.cellModel.stopIdx == selectedStopIdx ? .LIGHT_GRAY_F6F6F6: .white
                }
                return cell
        })
        
        reactor.action.onNext(.setSection)
        
        reactor.state.map { $0.section }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(WaypointCellViewReactor.self)
            .map { $0.cellModel.stopIdx }
            .filter { [weak self] _ in self?.createServiceWaypointChangeDelegate != nil }
            .subscribe(onNext: { [weak self] stopIdx in
                let prevStopIdx = reactor.waypointInput?.stopIdx ?? nil
                self?.createServiceWaypointChangeDelegate?.didCreateServiceWaypointChange(prevStopIdx: prevStopIdx, stopIdx: stopIdx)
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        
        self.tableView.rx.modelSelected(WaypointCellViewReactor.self)
            .map { $0.cellModel.stopIdx }
            .filter { [weak self] _ in self?.createServiceWaypointSelectDelegate != nil }
            .subscribe(onNext: { [weak self] stopIdx in
                guard let self = self, let willAppendAt = reactor.willAppendAt else { return }
                self.createServiceWaypointSelectDelegate?.didSelectWaypoint(willAppendAt: willAppendAt, stopIndex: stopIdx)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
}
