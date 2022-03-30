//
//  ServiceBasicInfoViewController.swift
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
    private let serviceCreatorView = SRPDetailInfoCellView(title: "서비스 생성자")
    private let serviceRequestAtView = SRPDetailInfoCellView(title: "서비스 요청 일시")
    private let serviceBeginAtView = SRPDetailInfoCellView(title: "서비스 시작 일시")
    private let serviceEndAtView = SRPDetailInfoCellView(title: "서비스 종료 일시")
    private let serviceTimeView = SRPDetailInfoCellView(title: "서비스 소요 시간")
    private let serviceRobotMovingDistanceView = SRPDetailInfoCellView(title: "이동 거리")
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
        addContent(self.serviceRobotMovingDistanceView)
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
        
        self.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        let service = reactor.state.map(\.service).share()
        
        service.map(\.?.serviceNumber)
            .bind(to: self.serviceNumberView.rx.content)
            .disposed(by: self.disposeBag)
        
        service.map(\.?.creator.displayName)
            .bind(to: self.serviceCreatorView.rx.content)
            .disposed(by: self.disposeBag)
        
        service.map(\.?.requestedAt.infoDateTimeFormatted)
            .bind(to: self.serviceRequestAtView.rx.content)
            .disposed(by: self.disposeBag)
        
        service.map(\.?.startedAt?.infoDateTimeFormatted)
            .bind(to: self.serviceBeginAtView.rx.content)
            .disposed(by: self.disposeBag)
        
        service.map(\.?.finishedAt?.infoDateTimeFormatted)
            .bind(to: self.serviceEndAtView.rx.content)
            .disposed(by: self.disposeBag)
        
        service
            .map { service -> String? in
                guard let beginAt = service?.startedAt,
                      let endAt = service?.finishedAt
                else { return nil }
                return beginAt.infoReadableTimeTakenFromThis(to: endAt)
            }.bind(to: self.serviceTimeView.rx.content)
            .disposed(by: self.disposeBag)
        
        service
            .map { $0?.travelDistance == nil ? nil: "\(Int($0!.travelDistance!))m" }
            .bind(to: self.serviceRobotMovingDistanceView.rx.content)
            .disposed(by: self.disposeBag)
        
        service.map(\.?.robot?.name)
            .bind(to: self.serviceRobotNameView.rx.content)
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
                if let control = self?.scrollView.refreshControl, control.isRefreshing {
                    DispatchQueue.main.async { [weak self] in
                        self?.scrollView.refreshControl?.endRefreshing()
                    }
                }
            }).disposed(by: self.disposeBag)
    }
}
