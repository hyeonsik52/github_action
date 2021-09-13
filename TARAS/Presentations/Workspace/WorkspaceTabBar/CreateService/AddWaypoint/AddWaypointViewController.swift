//
//  AddWaypointViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift
import RxCocoa

class AddWaypointViewController: BaseViewController, ReactorKit.View {

    weak var createServiceWaypointChangeDelegate: CreateServiceWaypointChangeDelegate?

    weak var createServiceWaypointSelectDelegate: CreateServiceWaypointSelectDelegate?

    
    // MARK: - UI

    let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "navi-close"), for: .normal)
    }

    let titleLabel = UILabel().then {
        $0.font = .bold.20
        $0.textColor = .black
        $0.text = "경유지 추가 위치 선택"
    }

    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor.clear
        $0.register(AddWaypointCell.self)
        $0.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }

    
    // MARK: - Life cycles

    override func setupConstraints() {
        self.view.backgroundColor = .LIGHT_GRAY_F6F6F6

        self.view.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }

        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.closeButton)
            $0.centerX.equalToSuperview()
        }

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.closeButton.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupNaviBar() {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func bind() {
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }


    // MARK: - ReactorKit

    func bind(reactor: AddWaypointViewReactor) {
        let dataSource = RxTableViewSectionedReloadDataSource<AddWaypointSection>(
            configureCell: { _, tableView, indexPath, cellReactor in
                let cell = tableView.dequeueCell(ofType: AddWaypointCell.self, indexPath: indexPath)
                cell.reactor = cellReactor
                cell.cellIndex.accept(indexPath.row)
                cell.upperView.button.tag = indexPath.row
                cell.waypointCellDelegate = self
                return cell
            })

        reactor.action.onNext(.setSection)

        reactor.state.map { $0.section }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension AddWaypointViewController: CreateServiceWaypointCellDelegate {
    func didSelectWaypoint(willAppendAt: Int) {
        let viewController = WaypointViewController()
        viewController.reactor = self.reactor?.reactorForWaypoint(willAppendAt)
        viewController.createServiceWaypointSelectDelegate = self.createServiceWaypointSelectDelegate
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
