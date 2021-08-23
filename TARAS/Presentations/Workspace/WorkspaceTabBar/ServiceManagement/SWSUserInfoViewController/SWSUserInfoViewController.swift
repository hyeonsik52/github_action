//
//  SWSUserInfoViewController.swift
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

class SWSUserInfoViewController: BaseNavigationViewController, View {

    private let scrollView = UIScrollView().then {
        $0.contentInset.top = 14
        $0.refreshControl = UIRefreshControl()
    }
    
    private let profileView = SRPDetailInfoCellView(title: "프로필 사진")
    private let nameView = SRPDetailInfoCellView(title: "이름")
    private let idView = SRPDetailInfoCellView(title: "아이디")
    private let emailView = SRPDetailInfoCellView(title: "이메일")
    private let phoneNumberView = SRPDetailInfoCellView(title: "전화번호")
    private let belongingGroupView = SRPDetailInfoCellView(title: "소속 그룹")
    private let defaultPlaceView = SRPDetailInfoCellView(title: "기본 위치")
    private let stopInCharge = SRPDetailInfoCellView(title: "담당 정차지")
    
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
        
        addContent(self.profileView)
        addContent(self.nameView)
        addContent(self.idView)
        addContent(self.emailView)
        addContent(self.phoneNumberView)
        addContent(self.belongingGroupView)
        addContent(self.defaultPlaceView)
        addContent(self.stopInCharge)
    }
    
    override func setupNaviBar() {
        super.setupNaviBar()
        
        self.title = "사용자 정보"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func bind(reactor: SWSUserInfoViewReactor) {
        
        //Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.back()
            }).disposed(by: self.disposeBag)
        
        self.belongingGroupView.didSelect
            .subscribe(onNext: { [weak self] in
                
                let viewController = BelongingGroupListViewController()
                viewController.preferredTitle = "소속 그룹"
                viewController.reactor = reactor.reactorForBelongingGroup()
                
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.stopInCharge.didSelect
            .subscribe(onNext: { [weak self] in
                
                let viewController = StopInChargeListViewController()
                viewController.reactor = reactor.reactorForStopInCharge()
                
                self?.navigationController?.pushViewController(viewController, animated: true)
                
            }).disposed(by: self.disposeBag)
        
        self.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        let service = reactor.state.compactMap { $0.userInfo }

        service
            .map { (nil, true, $0.validProfileImageUrl, false) }
            .bind(to: self.profileView.rx.info)
            .disposed(by: self.disposeBag)

        service
            .map { ($0.validName, false, nil, false) }
            .bind(to: self.nameView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.userId, false, nil, false) }
            .bind(to: self.idView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.validEmail, false, nil, false) }
            .bind(to: self.emailView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.validPhoneNumber, false, nil, false) }
            .bind(to: self.phoneNumberView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .compactMap { $0.swsUserInfo }
            .map{ info -> String in
                if info.groups.isEmpty {
                    return "없음"
                }else if info.groups.count == 1 {
                    return info.groups.first!.name
                }else{
                    let first = info.groups.first!
                    let remainder = info.groups.count-1
                    return "\(first.name) 외 \(remainder)"
                }
        }
        .map { ($0, false, nil, true) }
        .bind(to: self.belongingGroupView.rx.info)
        .disposed(by: self.disposeBag)
        
        service
            .map { ($0.swsUserInfo?.place?.name ?? $0.swsUserInfo?.groups.first?.place?.name ?? "-", false, nil, false) }
            .bind(to: self.defaultPlaceView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .compactMap { $0.swsUserInfo?.groups.first.map{$0.stopsInCharge} }
            .map{ stops -> String in
                if stops.isEmpty {
                    return "없음"
                }else if stops.count == 1 {
                    return stops.first!.name
                }else{
                    let first = stops.first!
                    let remainder = stops.count-1
                    return "\(first.name) 외 \(remainder)"
                }
        }
        .map { ($0, false, nil, true) }
        .bind(to: self.stopInCharge.rx.info)
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .queueing(2)
            .map { $0[0] == nil && $0[1] == true }
            .bind(to: self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] isLoading in
                self?.scrollView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
}
