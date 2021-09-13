//
//  SelectPlaceViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/16.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
//import PanModal

protocol SelectPlaceViewControllerDelegate: class {
    func didSelect(_ place: ServicePlace)
}

class SelectPlaceViewController: BaseViewController, View {

    private let closeButton = UIButton().then {
        $0.contentMode = .center
        $0.setImage(UIImage(named: "navi-close"), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .bold.20
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "작업 위치 선택"
    }
    
    private let tableView = UITableView().then {
        
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
    
    private var selectedIndexPath: IndexPath?
    weak var delegate: SelectPlaceViewControllerDelegate?
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let container = UIView()
        self.view.addSubview(container)
        container.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        container.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(20)
        }
        
        container.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(self.closeButton).offset(16)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(container.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: SelectPlaceViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map{ Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
        
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
            .subscribe(onNext: { [weak self] place in
                self?.delegate?.didSelect(place)
                self?.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap { $0.places }
            .do(onNext: { [weak self] places in
                guard let row = places.enumerated().first(where: { $1.isSelected })?.offset else { return }
                self?.selectedIndexPath = IndexPath(row: row, section: 0)
            })
            .map { [PlaceModelSection(header: "", items: $0)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
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

extension SelectPlaceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}

extension SelectPlaceViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return self.tableView
    }

    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }
    
    var cornerRadius: CGFloat {
        return 0
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var springDamping: CGFloat {
        return 1
    }
    
    var transitionDuration: Double {
        return 0.4
    }
}
