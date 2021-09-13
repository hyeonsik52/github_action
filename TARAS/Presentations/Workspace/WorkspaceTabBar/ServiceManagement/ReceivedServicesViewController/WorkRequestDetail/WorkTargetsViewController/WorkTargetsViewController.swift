//
//  WorkTargetsViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class WorkTargetsViewController: BaseNavigatableViewController, View {

    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.contentInset.top = 14
        $0.separatorStyle = .none
        
        $0.register(SRPProfileTextTagTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<WorkTargetSection>(configureCell: { dataSource, tableView, indexPath, reactor -> UITableViewCell in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SRPProfileTextTagTableViewCell
        cell.reactor = reactor
        
        return cell
    })
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "작업 대상"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(reactor: WorkTargetsViewControllerReactor) {
        
        //Action
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(ServiceTargetCellReactor.self)
            .subscribe(onNext: { [weak self] cellReactor in
                let userIdx = cellReactor.currentState.user.idx
                
                let viewController = SWSUserInfoViewController()
                viewController.reactor = reactor.reactorForSwsUserInfo(userIdx: userIdx)
                
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.map { $0 }
            .map{ $0.responseList.map { ServiceTargetCellReactor(response: $0)} }
            .map {  [WorkTargetSection(header: "", items: $0 )] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension WorkTargetsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
