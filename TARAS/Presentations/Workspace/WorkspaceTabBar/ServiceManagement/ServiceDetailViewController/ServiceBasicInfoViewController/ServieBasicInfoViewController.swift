//
//  ServiceBasicInfoViewController.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/09.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift

class ServiceBasicInfoViewController: BaseNavigationViewController, View {

    private let scrollView = UIScrollView().then {
        $0.contentInset.top = 14
        $0.refreshControl = UIRefreshControl()
    }
    
    private let serviceNumberView = SRPDetailInfoCellView(title: "서비스 번호")
    private let serviceCreatorView = SRPDetailInfoCellView(title: "서비스 생성자", forcedSelection: true)
    private let serviceRequestAtView = SRPDetailInfoCellView(title: "서비스 요청 일시")
    private let serviceBeginAtView = SRPDetailInfoCellView(title: "서비스 시작 일시")
    private let serviceEndAtView = SRPDetailInfoCellView(title: "서비스 종료 일시")
    private let serviceTimeView = SRPDetailInfoCellView(title: "서비스 소요 시간")
    private let serviceRobotNameView = SRPDetailInfoCellView(title: "배정 로봇 이름")
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentView = UIStackView().then {
            $0.axis = .vertical
        }
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        func addContent(_ view: UIView) {
            contentView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.leading.trailing.equalTo(contentView)
                $0.height.equalTo(48)
            }
        }
        
        addContent(self.serviceNumberView)
        addContent(self.serviceCreatorView)
        addContent(self.serviceRequestAtView)
        addContent(self.serviceBeginAtView)
        addContent(self.serviceEndAtView)
        addContent(self.serviceTimeView)
        addContent(self.serviceRobotNameView)
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "서비스 기본 정보"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func bind(reactor: ServiceBasicInfoViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        self.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.serviceCreatorView.didSelect
            .subscribe(onNext: { [weak self] in
                guard let service = reactor.currentState.service else { return }
                
                let viewController = SWSUserInfoViewController()
                viewController.reactor = reactor.reactorForSwsUserInfo(userId: service.creator.id)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        //State
        let service = reactor.state.compactMap { $0.service }
        
        service
            .map { ($0.serviceNumber, false) }
            .bind(to: self.serviceNumberView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.creator.displayName, false) }
            .bind(to: self.serviceCreatorView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.requestedAt.overDescription, false) }
            .bind(to: self.serviceRequestAtView.rx.info)
            .disposed(by: self.disposeBag)
        
        //temp
        service
            .map { ($0.requestedAt.overDescription, false) }
            .bind(to: self.serviceBeginAtView.rx.info)
            .disposed(by: self.disposeBag)
        
        //temp
        service
            .map { ($0.requestedAt.overDescription, false) }
            .bind(to: self.serviceEndAtView.rx.info)
            .disposed(by: self.disposeBag)
        
//        service
//            .map {
//                guard let endAt = $0.endAt, let beginAt = $0.beginAt else { return "-" }
//                return (endAt.timeIntervalSince1970-beginAt.timeIntervalSince1970).toTimeString
//        }
        Observable.just("00:00")
        .map { ($0, false) }
        .bind(to: self.serviceTimeView.rx.info)
        .disposed(by: self.disposeBag)
        
        service
            .map { ($0.robot?.name ?? "-", false) }
            .bind(to: self.serviceRobotNameView.rx.info)
            .disposed(by: self.disposeBag)
        
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
