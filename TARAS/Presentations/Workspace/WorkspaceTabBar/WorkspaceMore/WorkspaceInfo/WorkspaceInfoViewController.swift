//
//  WorkspaceInfoViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/06/30.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit

class WorkspaceInfoViewController: BaseNavigatableViewController, View {

    enum Text {
        static let WI_VC_1 = "워크스페이스 정보"
        static let WI_VC_2 = "정차지 정보"
    }
    
    private let scrollView = UIScrollView().then {
        $0.refreshControl = UIRefreshControl()
    }
    
    private let swsInfoView = WorkspaceInfoView()

    private let stopInfoHeader = SettingScrollViewHeader(title: Text.WI_VC_2)
    private let stopInfoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 10
        $0.backgroundColor = .lightGrayF5F5F5
    }

    private let stopInfoButton = UIButton()

    override func setupConstraints() {
        super.setupConstraints()

        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        let contentView = UIStackView().then {
            $0.axis = .vertical
        }
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        contentView.addArrangedSubview(self.swsInfoView)
        swsInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        contentView.addArrangedSubview(self.stopInfoHeader)
        self.stopInfoHeader.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        let stopImageViewContainer = UIView()
        contentView.addArrangedSubview(stopImageViewContainer)
        stopImageViewContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        stopImageViewContainer.addSubview(self.stopInfoImageView)
        self.stopInfoImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
            $0.height.equalTo(self.stopInfoImageView.snp.width).multipliedBy(0.77)
        }

        stopImageViewContainer.addSubview(self.stopInfoButton)
        self.stopInfoButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let footerView = UIView()
        contentView.addArrangedSubview(footerView)
        footerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(45)
        }
    }

    override func setupNaviBar() {
        super.setupNaviBar()

        self.title = Text.WI_VC_1
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }

    func bind(reactor: WorkspaceInfoViewReactor) {

        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.loadSwsInfo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)

        self.stopInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let workspace = reactor.currentState.workspace else { return }
                let viewController = WorkspaceStopDetailViewController(workspace)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.loadSwsInfo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        //State
        reactor.state.compactMap { $0.workspace }
            .bind(to: self.swsInfoView.rx.workspace)
            .disposed(by: self.disposeBag)

//        reactor.state.compactMap { $0.workspace?.envMaps.first?.imageUrl }
//            .bind(to: self.stopInfoImageView.rx.image)
//            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] isLoading in
                self?.scrollView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
}
