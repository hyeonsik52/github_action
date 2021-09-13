//
//  RecipientsUsersViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by Suzy Park on 2020/07/10.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import SnapKit

class RecipientUserViewController: BaseNavigatableViewController, ReactorKit.View {

    weak var recipientDelegate: CSURecipientDelegate?


    // MARK: - UI

    var collectionViewHeightConstraint: Constraint?

    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 60, height: 70)
        $0.minimumLineSpacing = 4
        $0.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    ).then {
        $0.backgroundColor = .clear
        $0.register(RecipientUserCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        $0.showsHorizontalScrollIndicator = false
    }

    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(RecipientUserCell.self)
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: 100))
    }

    let confirmButton = SRPButton("0명 선택").then {
        $0.isEnabled = false
    }


    // MARK: - Life cycles

    override func setupConstraints() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            self.collectionViewHeightConstraint = $0.height.equalTo(0).constraint
        }

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.collectionView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    override func bind() {
        
    }


    // MARK: - ReactorKit

    func bind(reactor: RecipientUserViewReactor) {
        let dataSource = RxTableViewSectionedReloadDataSource<RecipientUserSection>(
            configureCell: { _, tableView, indexPath, cellReactor in
                let cell = tableView.dequeueCell(ofType: RecipientUserCell.self, indexPath: indexPath)
                cell.reactor = cellReactor
                return cell
            })

        let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<RecipientUserCollectionViewSection>(
            configureCell: { _, collectionView, indexPath, cellReactor in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipientUserCollectionViewCell
                cell.reactor = cellReactor
                return cell
            })

        self.rx.viewDidLoad
            .map { Reactor.Action.setTableViewSection }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.tableView.rx.itemSelected
            .map { Reactor.Action.didSelectTableViewCell($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.collectionView.rx.modelSelected(RecipientUserCollectionViewCellReactor.self)
            .map { Reactor.Action.didSelectCollectionViewCell($0.initialState.idx) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.confirmButton.rx.tap
            .map(reactor.updateCreateServiceUnitModel)
            .subscribe(onNext: { [weak self] serviceUnit in
                self?.recipientDelegate?.didRecipientsSelected(serviceUnit)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.tableViewSection }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.collectionViewSection }
            .bind(to: self.collectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: self.disposeBag)

        let collectionViewItemsCount = reactor.state
            .map { $0.collectionViewSection }
            .map { $0.first?.items.count ?? 0 }

        collectionViewItemsCount
            .map { ($0 > 0) ? 103 : 0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] offset in
                self?.collectionViewHeightConstraint?.update(offset: offset)
            }).disposed(by: self.disposeBag)

        collectionViewItemsCount
            .map { "\($0)명 선택" }
            .bind(to: self.confirmButton.rx.title(for: .normal))
            .disposed(by: self.disposeBag)

        collectionViewItemsCount
            .map { $0 > 0 }
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
}
