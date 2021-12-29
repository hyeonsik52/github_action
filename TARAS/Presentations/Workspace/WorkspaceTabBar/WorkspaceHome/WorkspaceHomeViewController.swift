//
//  WorkspaceHomeViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/05/29.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class WorkspaceHomeViewController: BaseViewController, View {
    
    private var workspaceView = WorkspaceSelectView()
    private var headerView = WorkspaceHeaderView()
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        let width = UIScreen.main.bounds.width - 16 * 2
        $0.minimumLineSpacing = 12
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    private lazy var collectionView = UICollectionView.init(
        frame: .zero,
        collectionViewLayout: self.flowLayout
    ).then {
        $0.alwaysBounceVertical = true
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
        $0.backgroundColor = .clear
        
        $0.refreshControl = UIRefreshControl()
        
        $0.register(ServiceTemplateCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<ServiceTemplateListSection>(
        configureCell: { dataSource, collectionView, indexPath, reactor -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath) as! ServiceTemplateCell
            cell.reactor = reactor
            
            return cell
        }
    )
    
    let backgroundView = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .regular[16]
        $0.textColor = .gray444444
        $0.textAlignment = .center
        $0.attributedText = .init(
            string: "생성 가능한 서비스 템플릿이 없습니다.\n관리자에게 문의해주세요.",
            attributes: [
                .paragraphStyle: NSMutableParagraphStyle().then {
                    $0.minimumLineHeight = 24
                    $0.alignment = .center
                }
            ]
        )
        $0.isHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        let topContainer = UIView()
        self.view.addSubview(topContainer)
        topContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        topContainer.addSubview(self.workspaceView)
        self.workspaceView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.lessThanOrEqualToSuperview().offset(-12)
        }
        
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.height.equalTo(104)
            make.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func bind(reactor: WorkspaceHomeReactor) {
        
        //Action
        self.rx.viewWillAppear
            .map {_ in Reactor.Action.refreshInfo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable.merge(
            self.rx.viewDidLoad.map{},
            self.collectionView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()
        ).map { Reactor.Action.loadTemplates }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
        
        self.workspaceView.didSelect
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.reactor?.provider.userManager.userTB.update {
                    $0.lastWorkspaceId = nil
                }
                self.tabBarController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        //State
        reactor.state.compactMap { $0.worspace }
            .bind(to: self.workspaceView.rx.workspace)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap { $0.myUserInfo }
            .bind(to: self.headerView.rx.user)
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.templates)
            .map { [ServiceTemplateListSection(header: "", items: $0.map(ServiceTemplateCellReactor.init))] }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.collectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
}
