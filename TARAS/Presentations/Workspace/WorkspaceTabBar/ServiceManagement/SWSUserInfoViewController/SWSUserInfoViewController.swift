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

class SWSUserInfoViewController: BaseNavigatableViewController, View {

    private let scrollView = UIScrollView().then {
        $0.contentInset.top = 14
        $0.refreshControl = UIRefreshControl()
    }
    
    private let nameView = SRPDetailInfoCellView(title: "이름")
    private let idView = SRPDetailInfoCellView(title: "아이디")
    private let emailView = SRPDetailInfoCellView(title: "이메일")
    private let phoneNumberView = SRPDetailInfoCellView(title: "전화번호")
    
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
        
        addContent(self.nameView)
        addContent(self.idView)
        addContent(self.emailView)
        addContent(self.phoneNumberView)
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
        
        self.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .map {_ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        //State
        let service = reactor.state.compactMap { $0.userInfo }

        service
            .map { ($0.displayName, false) }
            .bind(to: self.nameView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.username, true) }
            .bind(to: self.idView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.email, true) }
            .bind(to: self.emailView.rx.info)
            .disposed(by: self.disposeBag)
        
        service
            .map { ($0.phonenumber, true) }
            .bind(to: self.phoneNumberView.rx.info)
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
